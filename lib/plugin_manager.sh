#!/bin/bash

PLUGINS_DIR="${BASE_DIR}/plugins"
PLUGIN_CONFIG_FILE="${BASE_DIR}/.plugins.json"

init_plugin_manager() {
    mkdir -p "$PLUGINS_DIR"
    if [[ ! -f "$PLUGIN_CONFIG_FILE" ]]; then
        jq -n '{
            enabled_plugins: [],
            disabled_plugins: [],
            plugin_metadata: {}
        }' > "$PLUGIN_CONFIG_FILE"
    fi
}

list_plugins() {
    echo "Available Plugins:"
    echo "=================="
    
    if [[ ! -d "$PLUGINS_DIR" ]] || [[ -z "$(ls -A "$PLUGINS_DIR")" ]]; then
        echo "No plugins found in $PLUGINS_DIR"
        return
    fi
    
    local i=1
    for plugin_dir in "${PLUGINS_DIR}"/*; do
        if [[ -d "$plugin_dir" ]]; then
            local plugin_name
            plugin_name=$(basename "$plugin_dir")
            local plugin_file="${plugin_dir}/plugin.sh"
            
            if [[ -f "$plugin_file" ]]; then
                local enabled
                enabled=$(is_plugin_enabled "$plugin_name" && echo "true" || echo "false")
                
                local status_color
                if [[ "$enabled" == "true" ]]; then
                    status_color="${GREEN}"
                else
                    status_color="${RED}"
                fi
                
                printf "  ${GREEN}[%d]${RESET} ${BOLD}%s${RESET} - ${status_color}%s${RESET}\n" "$i" "$plugin_name" "$([ "$enabled" == "true" ] && echo "Enabled" || echo "Disabled")"
                local info_file="${plugin_dir}/plugin.json"
                if [[ -f "$info_file" ]]; then
                    local description
                    description=$(jq -r '.description // "No description"' "$info_file" 2>/dev/null)
                    local version
                    version=$(jq -r '.version // "unknown"' "$info_file" 2>/dev/null)
                    local author
                    author=$(jq -r '.author // "unknown"' "$info_file" 2>/dev/null)
                    
                    printf "      Description: %s\n" "$description"
                    printf "      Version: %s\n" "$version"
                    printf "      Author: %s\n" "$author"
                fi
                echo ""
                ((i++))
            fi
        fi
    done
}

load_plugin() {
    local plugin_name="$1"
    local plugin_dir="${PLUGINS_DIR}/${plugin_name}"
    local plugin_file="${plugin_dir}/plugin.sh"
    
    if [[ ! -f "$plugin_file" ]]; then
        echo "Plugin not found: $plugin_name"
        return 1
    fi
    source "$plugin_file"
    if declare -f "${plugin_name}_init" >/dev/null; then
        "${plugin_name}_init"
    fi
    
    echo "Plugin loaded: $plugin_name"
}

enable_plugin() {
    local plugin_name="$1"
    
    if ! is_plugin_enabled "$plugin_name"; then
        jq --arg plugin "$plugin_name" '.enabled_plugins += [$plugin]' "$PLUGIN_CONFIG_FILE" > "${PLUGIN_CONFIG_FILE}.tmp"
        mv "${PLUGIN_CONFIG_FILE}.tmp" "$PLUGIN_CONFIG_FILE"
        echo "Plugin enabled: $plugin_name"
    else
        echo "Plugin already enabled: $plugin_name"
    fi
}

disable_plugin() {
    local plugin_name="$1"
    
    if is_plugin_enabled "$plugin_name"; then
        jq --arg plugin "$plugin_name" '.enabled_plugins -= [$plugin]' "$PLUGIN_CONFIG_FILE" > "${PLUGIN_CONFIG_FILE}.tmp"
        mv "${PLUGIN_CONFIG_FILE}.tmp" "$PLUGIN_CONFIG_FILE"
        echo "Plugin disabled: $plugin_name"
    else
        echo "Plugin already disabled: $plugin_name"
    fi
}

is_plugin_enabled() {
    local plugin_name="$1"
    local enabled
    enabled=$(jq -r --arg plugin "$plugin_name" '.enabled_plugins[] | select(. == $plugin)' "$PLUGIN_CONFIG_FILE" 2>/dev/null)
    [[ -n "$enabled" ]]
}

load_enabled_plugins() {
    local enabled_plugins
    enabled_plugins=$(jq -r '.enabled_plugins[]' "$PLUGIN_CONFIG_FILE" 2>/dev/null)
    
    for plugin_name in $enabled_plugins; do
        load_plugin "$plugin_name"
    done
}

create_plugin() {
    local plugin_name="$1"
    local description="$2"
    
    if [[ -z "$plugin_name" ]]; then
        echo "Plugin name is required."
        return 1
    fi
    
    local plugin_dir="${PLUGINS_DIR}/${plugin_name}"
    
    if [[ -d "$plugin_dir" ]]; then
        echo "Plugin already exists: $plugin_name"
        return 1
    fi
    
    mkdir -p "$plugin_dir"
    cat > "${plugin_dir}/plugin.json" << EOF
{
  "name": "${plugin_name}",
  "description": "${description:-Custom plugin}",
  "version": "1.0.0",
  "author": "FishMe User",
  "hooks": {
    "on_capture": false,
    "on_session_start": false,
    "on_session_end": false,
    "on_template_load": false
  }
}
EOF
    cat > "${plugin_dir}/plugin.sh" << EOF
#!/bin/bash
${plugin_name}_init() {
    echo "Initializing plugin: ${plugin_name}"
}

${plugin_name}_cleanup() {
    echo "Cleaning up plugin: ${plugin_name}"
}

${plugin_name}_on_capture() {
    local capture_file="\$1"
    echo "Capture received: \$capture_file"
}

${plugin_name}_on_session_start() {
    local session_id="\$1"
    local template="\$2"
    echo "Session started: \$session_id with template \$template"
}

${plugin_name}_on_session_end() {
    local session_id="\$1"
    echo "Session ended: \$session_id"
}

${plugin_name}_on_template_load() {
    local template="\$1"
    echo "Template loaded: \$template"
}
EOF
    
    chmod +x "${plugin_dir}/plugin.sh"
    
    echo "Plugin created: $plugin_name"
    echo "Location: $plugin_dir"
    echo ""
    echo "Next steps:"
    echo "  1. Edit ${plugin_dir}/plugin.sh to add your functionality"
    echo "  2. Enable the plugin with: ./fishme plugin enable $plugin_name"
}

delete_plugin() {
    local plugin_name="$1"
    local plugin_dir="${PLUGINS_DIR}/${plugin_name}"
    
    if [[ ! -d "$plugin_dir" ]]; then
        echo "Plugin not found: $plugin_name"
        return 1
    fi
    disable_plugin "$plugin_name" 2>/dev/null
    if declare -f "${plugin_name}_cleanup" >/dev/null; then
        "${plugin_name}_cleanup"
    fi
    
    rm -rf "$plugin_dir"
    echo "Plugin deleted: $plugin_name"
}

get_plugin_info() {
    local plugin_name="$1"
    local plugin_dir="${PLUGINS_DIR}/${plugin_name}"
    local info_file="${plugin_dir}/plugin.json"
    
    if [[ ! -f "$info_file" ]]; then
        echo "Plugin info not found: $plugin_name"
        return 1
    fi
    
    echo "Plugin Information: $plugin_name"
    echo "=========================="
    jq '.' "$info_file" 2>/dev/null
}

export_plugin() {
    local plugin_name="$1"
    local output_file="${2:-${BASE_DIR}/exports/plugin_${plugin_name}_$(date +%Y%m%d_%H%M%S).tar.gz}"
    local plugin_dir="${PLUGINS_DIR}/${plugin_name}"
    
    if [[ ! -d "$plugin_dir" ]]; then
        echo "Plugin not found: $plugin_name"
        return 1
    fi
    
    tar -czf "$output_file" -C "$PLUGINS_DIR" "$plugin_name"
    echo "Plugin exported to: $output_file"
}

import_plugin() {
    local archive_file="$1"
    
    if [[ ! -f "$archive_file" ]]; then
        echo "Archive not found: $archive_file"
        return 1
    fi
    local temp_dir
    temp_dir=$(mktemp -d)
    
    tar -xzf "$archive_file" -C "$temp_dir"
    local extracted_dir
    extracted_dir=$(find "$temp_dir" -maxdepth 1 -type d -not -name "$temp_dir" | head -1)
    
    if [[ -z "$extracted_dir" ]]; then
        echo "Invalid archive format."
        rm -rf "$temp_dir"
        return 1
    fi
    local plugin_name
    plugin_name=$(basename "$extracted_dir")
    local plugin_dir="${PLUGINS_DIR}/${plugin_name}"
    if [[ -d "$plugin_dir" ]]; then
        echo "Plugin already exists: $plugin_name"
        rm -rf "$temp_dir"
        return 1
    fi
    
    mv "$extracted_dir" "$plugin_dir"
    rm -rf "$temp_dir"
    
    echo "Plugin imported: $plugin_name"
}

call_plugin_hook() {
    local hook_name="$1"
    shift
    local hook_args=("$@")
    
    local enabled_plugins
    enabled_plugins=$(jq -r '.enabled_plugins[]' "$PLUGIN_CONFIG_FILE" 2>/dev/null)
    
    for plugin_name in $enabled_plugins; do
        local hook_function="${plugin_name}_${hook_name}"
        if declare -f "$hook_function" >/dev/null; then
            "$hook_function" "${hook_args[@]}"
        fi
    done
}

validate_plugin() {
    local plugin_name="$1"
    local plugin_dir="${PLUGINS_DIR}/${plugin_name}"
    
    if [[ ! -d "$plugin_dir" ]]; then
        echo "Plugin not found: $plugin_name"
        return 1
    fi
    
    echo "Validating plugin: $plugin_name"
    echo "=========================="
    
    local errors=0
    if [[ -f "${plugin_dir}/plugin.sh" ]]; then
        echo "  ${GREEN}[✓]${RESET} plugin.sh exists"
    else
        echo "  ${RED}[!]${RESET} plugin.sh missing"
        ((errors++))
    fi
    if [[ -f "${plugin_dir}/plugin.json" ]]; then
        echo "  ${GREEN}[✓]${RESET} plugin.json exists"
        if jq empty "${plugin_dir}/plugin.json" 2>/dev/null; then
            echo "  ${GREEN}[✓]${RESET} plugin.json is valid JSON"
        else
            echo "  ${RED}[!]${RESET} plugin.json has invalid JSON"
            ((errors++))
        fi
    else
        echo "  ${RED}[!]${RESET} plugin.json missing"
        ((errors++))
    fi
    
    echo ""
    if [[ $errors -eq 0 ]]; then
        echo "  ${GREEN}Plugin is valid!${RESET}"
        return 0
    else
        echo "  ${RED}Plugin has $errors error(s)${RESET}"
        return 1
    fi
}

update_plugin_metadata() {
    local plugin_name="$1"
    local plugin_dir="${PLUGINS_DIR}/${plugin_name}"
    local info_file="${plugin_dir}/plugin.json"
    
    if [[ ! -f "$info_file" ]]; then
        echo "Plugin info not found: $plugin_name"
        return 1
    fi
    jq --arg loaded "$(date -Iseconds)" '.last_loaded = $loaded' "$info_file" > "${info_file}.tmp"
    mv "${info_file}.tmp" "$info_file"
}
