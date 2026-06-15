#!/bin/bash

SESSIONS_DIR="${BASE_DIR}/sessions"
CURRENT_SESSION_FILE="${BASE_DIR}/.current_session"

init_session_manager() {
    mkdir -p "$SESSIONS_DIR"
}

create_session() {
    local template="$1"
    local session_id
    session_id="session_$(date +%Y%m%d_%H%M%S)_$(head -c 4 /dev/urandom | xxd -p)"
    
    local session_file="${SESSIONS_DIR}/${session_id}.json"
    jq -n \
        --arg session_id "$session_id" \
        --arg template "$template" \
        --arg start_time "$(date -Iseconds)" \
        --arg status "active" \
        '{
            session_id: $session_id,
            template: $template,
            start_time: $start_time,
            end_time: null,
            status: $status,
            captures: [],
            tunnel_type: null,
            tunnel_url: null,
            local_port: null
        }' > "$session_file"
    echo "$session_id" > "$CURRENT_SESSION_FILE"
    
    echo "$session_id"
}

get_current_session() {
    if [[ -f "$CURRENT_SESSION_FILE" ]]; then
        cat "$CURRENT_SESSION_FILE"
    else
        echo ""
    fi
}

get_session_info() {
    local session_id="$1"
    local session_file="${SESSIONS_DIR}/${session_id}.json"
    
    if [[ ! -f "$session_file" ]]; then
        echo "Session not found: $session_id"
        return 1
    fi
    
    cat "$session_file"
}

update_session_status() {
    local session_id="$1"
    local status="$2"
    local session_file="${SESSIONS_DIR}/${session_id}.json"
    
    if [[ ! -f "$session_file" ]]; then
        return 1
    fi
    
    jq --arg status "$status" '.status = $status' "$session_file" > "${session_file}.tmp"
    mv "${session_file}.tmp" "$session_file"
}

end_session() {
    local session_id
    session_id=$(get_current_session)
    
    if [[ -z "$session_id" ]]; then
        echo "No active session."
        return 1
    fi
    
    local session_file="${SESSIONS_DIR}/${session_id}.json"
    
    if [[ ! -f "$session_file" ]]; then
        return 1
    fi
    jq --arg end_time "$(date -Iseconds)" --arg status "completed" \
        '.end_time = $end_time | .status = $status' "$session_file" > "${session_file}.tmp"
    mv "${session_file}.tmp" "$session_file"
    rm -f "$CURRENT_SESSION_FILE"
    
    echo "Session ended: $session_id"
}

add_capture_to_session() {
    local session_id="$1"
    local capture_file="$2"
    
    if [[ -z "$session_id" ]]; then
        session_id=$(get_current_session)
    fi
    
    if [[ -z "$session_id" ]]; then
        return 1
    fi
    
    local session_file="${SESSIONS_DIR}/${session_id}.json"
    
    if [[ ! -f "$session_file" ]]; then
        return 1
    fi
    local capture_data
    capture_data=$(cat "$capture_file")
    jq --argjson capture "$capture_data" '.captures += [$capture]' "$session_file" > "${session_file}.tmp"
    mv "${session_file}.tmp" "$session_file"
}

set_session_tunnel_info() {
    local session_id="$1"
    local tunnel_type="$2"
    local tunnel_url="$3"
    local local_port="$4"
    
    if [[ -z "$session_id" ]]; then
        session_id=$(get_current_session)
    fi
    
    if [[ -z "$session_id" ]]; then
        return 1
    fi
    
    local session_file="${SESSIONS_DIR}/${session_id}.json"
    
    if [[ ! -f "$session_file" ]]; then
        return 1
    fi
    
    jq --arg tunnel_type "$tunnel_type" \
       --arg tunnel_url "$tunnel_url" \
       --argjson local_port "$local_port" \
       '.tunnel_type = $tunnel_type | .tunnel_url = $tunnel_url | .local_port = $local_port' \
       "$session_file" > "${session_file}.tmp"
    mv "${session_file}.tmp" "$session_file"
}

list_sessions() {
    echo "Sessions:"
    echo "========="
    
    if [[ ! -d "$SESSIONS_DIR" ]] || [[ -z "$(ls -A "$SESSIONS_DIR")" ]]; then
        echo "No sessions found."
        return
    fi
    
    local i=1
    for session_file in "${SESSIONS_DIR}"/*.json; do
        if [[ -f "$session_file" ]]; then
            local session_id
            session_id=$(jq -r '.session_id' "$session_file" 2>/dev/null)
            local template
            template=$(jq -r '.template' "$session_file" 2>/dev/null)
            local status
            status=$(jq -r '.status' "$session_file" 2>/dev/null)
            local start_time
            start_time=$(jq -r '.start_time' "$session_file" 2>/dev/null)
            local capture_count
            capture_count=$(jq -r '.captures | length' "$session_file" 2>/dev/null)
            
            local status_color
            case "$status" in
                "active") status_color="${GREEN}" ;;
                "completed") status_color="${BLUE}" ;;
                "failed") status_color="${RED}" ;;
                *) status_color="${RESET}" ;;
            esac
            
            printf "  ${GREEN}[%d]${RESET} ${BOLD}%s${RESET}\n" "$i" "$session_id"
            printf "      Template: %s\n" "$template"
            printf "      Status: ${status_color}%s${RESET}\n" "$status"
            printf "      Started: %s\n" "$start_time"
            printf "      Captures: %d\n" "$capture_count"
            echo ""
            ((i++))
        fi
    done
}

get_session_stats() {
    local session_id="$1"
    local session_file="${SESSIONS_DIR}/${session_id}.json"
    
    if [[ ! -f "$session_file" ]]; then
        echo "Session not found: $session_id"
        return 1
    fi
    
    local start_time
    start_time=$(jq -r '.start_time' "$session_file" 2>/dev/null)
    local end_time
    end_time=$(jq -r '.end_time // "N/A"' "$session_file" 2>/dev/null)
    local capture_count
    capture_count=$(jq -r '.captures | length' "$session_file" 2>/dev/null)
    local tunnel_type
    tunnel_type=$(jq -r '.tunnel_type // "N/A"' "$session_file" 2>/dev/null)
    local tunnel_url
    tunnel_url=$(jq -r '.tunnel_url // "N/A"' "$session_file" 2>/dev/null)
    
    echo "Session Statistics"
    echo "=================="
    echo "Session ID: $session_id"
    echo "Start Time: $start_time"
    echo "End Time: $end_time"
    echo "Duration: $(calculate_session_duration "$start_time" "$end_time")"
    echo "Captures: $capture_count"
    echo "Tunnel Type: $tunnel_type"
    echo "Tunnel URL: $tunnel_url"
}

calculate_session_duration() {
    local start_time="$1"
    local end_time="$2"
    
    if [[ "$end_time" == "N/A" ]] || [[ -z "$end_time" ]]; then
        end_time=$(date -Iseconds)
    fi
    
    local start_seconds
    start_seconds=$(date -d "$start_time" +%s 2>/dev/null || echo 0)
    local end_seconds
    end_seconds=$(date -d "$end_time" +%s 2>/dev/null || echo 0)
    
    local duration=$((end_seconds - start_seconds))
    
    if [[ $duration -lt 60 ]]; then
        echo "${duration}s"
    elif [[ $duration -lt 3600 ]]; then
        echo "$((duration / 60))m $((duration % 60))s"
    else
        echo "$((duration / 3600))h $(( (duration % 3600) / 60 ))m"
    fi
}

delete_session() {
    local session_id="$1"
    local session_file="${SESSIONS_DIR}/${session_id}.json"
    
    if [[ ! -f "$session_file" ]]; then
        echo "Session not found: $session_id"
        return 1
    fi
    local archive_dir="${SESSIONS_DIR}/.archived"
    mkdir -p "$archive_dir"
    mv "$session_file" "${archive_dir}/${session_id}.json"
    
    echo "Session archived: $session_id"
}

export_session() {
    local session_id="$1"
    local output_file="${2:-${BASE_DIR}/exports/session_${session_id}.json}"
    local session_file="${SESSIONS_DIR}/${session_id}.json"
    
    if [[ ! -f "$session_file" ]]; then
        echo "Session not found: $session_id"
        return 1
    fi
    
    cp "$session_file" "$output_file"
    echo "Session exported to: $output_file"
}

import_session() {
    local input_file="$1"
    
    if [[ ! -f "$input_file" ]]; then
        echo "File not found: $input_file"
        return 1
    fi
    
    local session_id
    session_id=$(jq -r '.session_id' "$input_file" 2>/dev/null)
    
    if [[ -z "$session_id" ]]; then
        echo "Invalid session file."
        return 1
    fi
    
    local session_file="${SESSIONS_DIR}/${session_id}.json"
    
    if [[ -f "$session_file" ]]; then
        echo "Session already exists: $session_id"
        return 1
    fi
    
    cp "$input_file" "$session_file"
    echo "Session imported: $session_id"
}

cleanup_old_sessions() {
    local days="${1:-30}"
    
    echo "Cleaning up sessions older than $days days..."
    
    local count=0
    for session_file in "${SESSIONS_DIR}"/*.json; do
        if [[ -f "$session_file" ]]; then
            local start_time
            start_time=$(jq -r '.start_time' "$session_file" 2>/dev/null)
            local file_age_days
            file_age_days=$(( ($(date +%s) - $(date -d "$start_time" +%s 2>/dev/null || echo 0)) / 86400 ))
            
            if [[ $file_age_days -gt $days ]]; then
                local session_id
                session_id=$(jq -r '.session_id' "$session_file" 2>/dev/null)
                delete_session "$session_id"
                ((count++))
            fi
        fi
    done
    
    echo "Cleaned up $old sessions."
}

get_active_sessions() {
    local active_sessions=()
    
    for session_file in "${SESSIONS_DIR}"/*.json; do
        if [[ -f "$session_file" ]]; then
            local status
            status=$(jq -r '.status' "$session_file" 2>/dev/null)
            if [[ "$status" == "active" ]]; then
                local session_id
                session_id=$(jq -r '.session_id' "$session_file" 2>/dev/null)
                active_sessions+=("$session_id")
            fi
        fi
    done
    
    echo "${active_sessions[@]}"
}

check_orphaned_sessions() {
    echo "Checking for orphaned sessions..."
    
    local orphaned_count=0
    for session_file in "${SESSIONS_DIR}"/*.json; do
        if [[ -f "$session_file" ]]; then
            local status
            status=$(jq -r '.status' "$session_file" 2>/dev/null)
            local start_time
            start_time=$(jq -r '.start_time' "$session_file" 2>/dev/null)
            local file_age_hours
            file_age_hours=$(( ($(date +%s) - $(date -d "$start_time" +%s 2>/dev/null || echo 0)) / 3600 ))
            if [[ "$status" == "active" ]] && [[ $file_age_hours -gt 24 ]]; then
                local session_id
                session_id=$(jq -r '.session_id' "$session_file" 2>/dev/null)
                echo "  Orphaned session: $session_id (active for ${file_age_hours}h)"
                ((orphaned_count++))
            fi
        fi
    done
    
    if [[ $orphaned_count -eq 0 ]]; then
        echo "  No orphaned sessions found."
    else
        echo "  Found $orphaned_count orphaned session(s)."
    fi
}
