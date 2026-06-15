#!/bin/bash

MULTI_SITE_DIR="${BASE_DIR}/.multi_site
SITE_CONFIGS_DIR="${MULTI_SITE_DIR}/configs"
SITE_PIDS_FILE="${MULTI_SITE_DIR}/site_pids"

init_multi_site_manager() {
    mkdir -p "$SITE_CONFIGS_DIR"
    touch "$SITE_PIDS_FILE"
}

create_site_config() {
    local site_id="$1"
    local template="$2"
    local port="$3"
    local tunnel_type="$4"
    
    if [[ -z "$site_id" ]]; then
        echo "Site ID is required."
        return 1
    fi
    
    local config_file="${SITE_CONFIGS_DIR}/${site_id}.json"
    
    if [[ -f "$config_file" ]]; then
        echo "Site configuration already exists: $site_id"
        return 1
    fi
    
    jq -n \
        --arg site_id "$site_id" \
        --arg template "$template" \
        --argjson port "$port" \
        --arg tunnel_type "$tunnel_type" \
        --arg status "stopped" \
        --arg created "$(date -Iseconds)" \
        '{
            site_id: $site_id,
            template: $template,
            port: $port,
            tunnel_type: $tunnel_type,
            status: $status,
            created: $created,
            started: null,
            stopped: null,
            php_pid: null,
            tunnel_pid: null,
            tunnel_url: null
        }' > "$config_file"
    
    echo "Site configuration created: $site_id"
}

list_site_configs() {
    echo "Multi-Site Configurations:"
    echo "========================="
    
    if [[ ! -d "$SITE_CONFIGS_DIR" ]] || [[ -z "$(ls -A "$SITE_CONFIGS_DIR")" ]]; then
        echo "No site configurations found."
        return
    fi
    
    local i=1
    for config_file in "${SITE_CONFIGS_DIR}"/*.json; do
        if [[ -f "$config_file" ]]; then
            local site_id
            site_id=$(jq -r '.site_id' "$config_file" 2>/dev/null)
            local template
            template=$(jq -r '.template' "$config_file" 2>/dev/null)
            local port
            port=$(jq -r '.port' "$config_file" 2>/dev/null)
            local status
            status=$(jq -r '.status' "$config_file" 2>/dev/null)
            local tunnel_type
            tunnel_type=$(jq -r '.tunnel_type' "$config_file" 2>/dev/null)
            
            local status_color
            case "$status" in
                "running") status_color="${GREEN}" ;;
                "stopped") status_color="${RED}" ;;
                "error") status_color="${YELLOW}" ;;
                *) status_color="${RESET}" ;;
            esac
            
            printf "  ${GREEN}[%d]${RESET} ${BOLD}%s${RESET}\n" "$i" "$site_id"
            printf "      Template: %s\n" "$template"
            printf "      Port: %s\n" "$port"
            printf "      Tunnel: %s\n" "$tunnel_type"
            printf "      Status: ${status_color}%s${RESET}\n" "$status"
            echo ""
            ((i++))
        fi
    done
}

start_site() {
    local site_id="$1"
    local config_file="${SITE_CONFIGS_DIR}/${site_id}.json"
    
    if [[ ! -f "$config_file" ]]; then
        echo "Site configuration not found: $site_id"
        return 1
    fi
    
    local template
    template=$(jq -r '.template' "$config_file" 2>/dev/null)
    local port
    port=$(jq -r '.port' "$config_file" 2>/dev/null)
    local tunnel_type
    tunnel_type=$(jq -r '.tunnel_type' "$config_file" 2>/dev/null)
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "Port $port is already in use."
        return 1
    fi
    cd "${BASE_DIR}" || return 1
    FISHME_ACTIVE_SITE="$template" php -S "127.0.0.1:${port}" "${BASE_DIR}/router.php" >/dev/null 2>&1 &
    local php_pid=$!
    local tunnel_pid=""
    local tunnel_url=""
    if [[ "$tunnel_type" != "none" ]]; then
        if [[ "$tunnel_type" == "cloudflare" ]]; then
            local cf_bin
            cf_bin=$(command -v cloudflared 2>/dev/null || echo "${BASE_DIR}/cloudflared")
            local cf_log
            cf_log=$(mktemp)
            
            "$cf_bin" tunnel --url "http://127.0.0.1:${port}" --logfile "$cf_log" >/dev/null 2>&1 &
            tunnel_pid=$!
            local attempts=0
            while [[ $attempts -lt 30 ]]; do
                tunnel_url=$(grep -oP 'https://[a-zA-Z0-9-]+\.trycloudflare\.com' "$cf_log" 2>/dev/null | head -1)
                [[ -n "$tunnel_url" ]] && break
                sleep 0.5
                ((attempts++))
            done
        fi
    fi
    jq --arg status "running" \
       --arg started "$(date -Iseconds)" \
       --argjson php_pid "$php_pid" \
       --argjson tunnel_pid "$tunnel_pid" \
       --arg tunnel_url "$tunnel_url" \
       '.status = $status | .started = $started | .php_pid = $php_pid | .tunnel_pid = $tunnel_pid | .tunnel_url = $tunnel_url' \
       "$config_file" > "${config_file}.tmp"
    mv "${config_file}.tmp" "$config_file"
    echo "${site_id}:${php_pid}:${tunnel_pid}" >> "$SITE_PIDS_FILE"
    
    echo "Site started: $site_id"
    echo "  Template: $template"
    echo "  Port: $port"
    if [[ -n "$tunnel_url" ]]; then
        echo "  Tunnel URL: $tunnel_url"
    fi
}

stop_site() {
    local site_id="$1"
    local config_file="${SITE_CONFIGS_DIR}/${site_id}.json"
    
    if [[ ! -f "$config_file" ]]; then
        echo "Site configuration not found: $site_id"
        return 1
    fi
    
    local php_pid
    php_pid=$(jq -r '.php_pid' "$config_file" 2>/dev/null)
    local tunnel_pid
    tunnel_pid=$(jq -r '.tunnel_pid' "$config_file" 2>/dev/null)
    if [[ -n "$php_pid" ]] && [[ "$php_pid" != "null" ]]; then
        kill "$php_pid" 2>/dev/null
    fi
    
    if [[ -n "$tunnel_pid" ]] && [[ "$tunnel_pid" != "null" ]]; then
        kill "$tunnel_pid" 2>/dev/null
    fi
    jq --arg status "stopped" \
       --arg stopped "$(date -Iseconds)" \
       --arg php_pid "null" \
       --arg tunnel_pid "null" \
       '.status = $status | .stopped = $stopped | .php_pid = ($php_pid | tonumber) | .tunnel_pid = ($tunnel_pid | tonumber)' \
       "$config_file" > "${config_file}.tmp"
    mv "${config_file}.tmp" "$config_file"
    sed -i "/^${site_id}:/d" "$SITE_PIDS_FILE"
    
    echo "Site stopped: $site_id"
}

stop_all_sites() {
    echo "Stopping all sites..."
    
    for config_file in "${SITE_CONFIGS_DIR}"/*.json; do
        if [[ -f "$config_file" ]]; then
            local site_id
            site_id=$(jq -r '.site_id' "$config_file" 2>/dev/null)
            local status
            status=$(jq -r '.status' "$config_file" 2>/dev/null)
            
            if [[ "$status" == "running" ]]; then
                stop_site "$site_id"
            fi
        fi
    done
    
    echo "All sites stopped."
}

get_site_status() {
    local site_id="$1"
    local config_file="${SITE_CONFIGS_DIR}/${site_id}.json"
    
    if [[ ! -f "$config_file" ]]; then
        echo "Site configuration not found: $site_id"
        return 1
    fi
    
    echo "Site Status: $site_id"
    echo "================"
    
    jq -r 'to_entries[] | "\(.key): \(.value)"' "$config_file" 2>/dev/null | sed 's/^/  /'
}

delete_site_config() {
    local site_id="$1"
    local config_file="${SITE_CONFIGS_DIR}/${site_id}.json"
    
    if [[ ! -f "$config_file" ]]; then
        echo "Site configuration not found: $site_id"
        return 1
    fi
    local status
    status=$(jq -r '.status' "$config_file" 2>/dev/null)
    if [[ "$status" == "running" ]]; then
        stop_site "$site_id"
    fi
    
    rm "$config_file"
    echo "Site configuration deleted: $site_id"
}

get_running_sites() {
    local running_sites=()
    
    for config_file in "${SITE_CONFIGS_DIR}"/*.json; do
        if [[ -f "$config_file" ]]; then
            local status
            status=$(jq -r '.status' "$config_file" 2>/dev/null)
            if [[ "$status" == "running" ]]; then
                local site_id
                site_id=$(jq -r '.site_id' "$config_file" 2>/dev/null)
                running_sites+=("$site_id")
            fi
        fi
    done
    
    echo "${running_sites[@]}"
}

monitor_sites() {
    echo "Monitoring all sites (press Ctrl+C to stop)..."
    echo ""
    
    while true; do
        clear
        echo "Multi-Site Monitor"
        echo "=================="
        echo "Updated: $(date)"
        echo ""
        
        for config_file in "${SITE_CONFIGS_DIR}"/*.json; do
            if [[ -f "$config_file" ]]; then
                local site_id
                site_id=$(jq -r '.site_id' "$config_file" 2>/dev/null)
                local template
                template=$(jq -r '.template' "$config_file" 2>/dev/null)
                local port
                port=$(jq -r '.port' "$config_file" 2>/dev/null)
                local status
                status=$(jq -r '.status' "$config_file" 2>/dev/null)
                local tunnel_url
                tunnel_url=$(jq -r '.tunnel_url' "$config_file" 2>/dev/null)
                
                local status_color
                case "$status" in
                    "running") status_color="${GREEN}" ;;
                    "stopped") status_color="${RED}" ;;
                    "error") status_color="${YELLOW}" ;;
                    *) status_color="${RESET}" ;;
                esac
                
                printf "  ${BOLD}%s${RESET}\n" "$site_id"
                printf "    Template: %s\n" "$template"
                printf "    Port: %s\n" "$port"
                printf "    Status: ${status_color}%s${RESET}\n" "$status"
                if [[ -n "$tunnel_url" ]] && [[ "$tunnel_url" != "null" ]]; then
                    printf "    URL: %s\n" "$tunnel_url"
                fi
                echo ""
            fi
        done
        
        sleep 5
    done
}

check_site_health() {
    local site_id="$1"
    local config_file="${SITE_CONFIGS_DIR}/${site_id}.json"
    
    if [[ ! -f "$config_file" ]]; then
        echo "Site configuration not found: $site_id"
        return 1
    fi
    
    local status
    status=$(jq -r '.status' "$config_file" 2>/dev/null)
    
    if [[ "$status" != "running" ]]; then
        echo "Site is not running: $site_id"
        return 1
    fi
    
    local php_pid
    php_pid=$(jq -r '.php_pid' "$config_file" 2>/dev/null)
    local port
    port=$(jq -r '.port' "$config_file" 2>/dev/null)
    
    echo "Site Health Check: $site_id"
    echo "======================"
    if kill -0 "$php_pid" 2>/dev/null; then
        echo "  ${GREEN}[✓]${RESET} PHP server running (PID: $php_pid)"
    else
        echo "  ${RED}[!]${RESET} PHP server not running"
    fi
    
    # Check port
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "  ${GREEN}[✓]${RESET} Port $port is listening"
    else
        echo "  ${RED}[!]${RESET} Port $port is not listening"
    fi
    
    # Check HTTP response
    if curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:${port}" 2>/dev/null | grep -q "200"; then
        echo "  ${GREEN}[✓]${RESET} HTTP server responding"
    else
        echo "  ${RED}[!]${RESET} HTTP server not responding"
    fi
}

export_site_configs() {
    local output_file="${1:-${BASE_DIR}/exports/site_configs_$(date +%Y%m%d_%H%M%S).json}"
    
    jq -n --argjson configs "$(jq -s '.' "${SITE_CONFIGS_DIR}"/*.json 2>/dev/null)" \
       '{configs: $configs, exported: "$(date -Iseconds)"}' > "$output_file"
    
    echo "Site configurations exported to: $output_file"
}

import_site_configs() {
    local input_file="$1"
    
    if [[ ! -f "$input_file" ]]; then
        echo "File not found: $input_file"
        return 1
    fi
    
    local configs
    configs=$(jq -r '.configs[]' "$input_file" 2>/dev/null)
    
    echo "$configs" | jq -c '.' | while IFS= read -r config; do
        local site_id
        site_id=$(echo "$config" | jq -r '.site_id')
        local config_file="${SITE_CONFIGS_DIR}/${site_id}.json"
        
        if [[ -f "$config_file" ]]; then
            echo "Site already exists: $site_id (skipping)"
        else
            echo "$config" > "$config_file"
            echo "Site configuration imported: $site_id"
        fi
    done
}
