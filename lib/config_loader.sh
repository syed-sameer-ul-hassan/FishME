#!/bin/bash

CONFIG_FILE="${BASE_DIR}/config/fishme.conf"

DEFAULT_HOST="127.0.0.1"
DEFAULT_PORT="8080"
DEFAULT_TUNNEL="cloudflare"
LOG_LEVEL="info"
COLOR_OUTPUT=true
SHOW_BANNER=true

load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        while IFS='=' read -r key value; do
            [[ "$key" =~ ^#.*$ ]] && continue
            [[ -z "$key" ]] && continue
            [[ "$key" =~ ^\[.*\]$ ]] && continue
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)
            export "FISHME_${key^^}=$value"
        done < "$CONFIG_FILE"
    else
        mkdir -p "$(dirname "$CONFIG_FILE")"
        cat > "$CONFIG_FILE" << 'EOF'
[server]
default_host=127.0.0.1
default_port=8080

[tunnel]
default_tunnel=cloudflare

[logging]
log_level=info
log_file=logs/fishme.log

[ui]
color_output=true
show_banner=true
EOF
    fi
}

get_config() {
    local key="$1"
    local default="$2"
    
    local env_var="FISHME_${key^^}"
    if [[ -n "${!env_var}" ]]; then
        echo "${!env_var}"
        return
    fi
    
    if [[ -f "$CONFIG_FILE" ]]; then
        local value
        value=$(grep "^${key}=" "$CONFIG_FILE" | cut -d'=' -f2 | xargs)
        if [[ -n "$value" ]]; then
            echo "$value"
            return
        fi
    fi
    
    echo "$default"
}

set_config() {
    local key="$1"
    local value="$2"
    
    if [[ -f "$CONFIG_FILE" ]]; then
        if grep -q "^${key}=" "$CONFIG_FILE"; then
            sed -i "s/^${key}=.*/${key}=${value}/" "$CONFIG_FILE"
        else
            echo "${key}=${value}" >> "$CONFIG_FILE"
        fi
    else
        mkdir -p "$(dirname "$CONFIG_FILE")"
        echo "${key}=${value}" >> "$CONFIG_FILE"
    fi
    
    export "FISHME_${key^^}=$value"
}

init_config() {
    load_config
    
    mkdir -p "${BASE_DIR}/logs"
    mkdir -p "${BASE_DIR}/sessions"
    mkdir -p "${BASE_DIR}/exports"
    mkdir -p "${BASE_DIR}/.cache/templates"
}
