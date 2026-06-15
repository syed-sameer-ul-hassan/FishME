#!/bin/bash

LOG_DIR="${BASE_DIR}/logs"
LOG_FILE="${LOG_DIR}/fishme.log"
MAX_LOG_SIZE="10M"
LOG_RETENTION_DAYS=7

LOG_LEVEL_DEBUG=0
LOG_LEVEL_INFO=1
LOG_LEVEL_WARN=2
LOG_LEVEL_ERROR=3
LOG_LEVEL_FATAL=4

CURRENT_LOG_LEVEL=${CURRENT_LOG_LEVEL:-$LOG_LEVEL_INFO}

init_logging() {
    mkdir -p "$LOG_DIR"
    rotate_logs
    if [[ ! -f "$LOG_FILE" ]]; then
        touch "$LOG_FILE"
    fi
}

rotate_logs() {
    if [[ -f "$LOG_FILE" ]]; then
        local file_size
        file_size=$(du -b "$LOG_FILE" | cut -f1)
        local max_size_bytes
        max_size_bytes=$(echo "$MAX_LOG_SIZE" | sed 's/M/*1024*1024/;s/K/*1024/;s/G/*1024*1024*1024/' | bc)
        
        if [[ $file_size -gt $max_size_bytes ]]; then
            local timestamp
            timestamp=$(date +%Y%m%d_%H%M%S)
            mv "$LOG_FILE" "${LOG_FILE}.${timestamp}"
            touch "$LOG_FILE"
        fi
    fi
    find "$LOG_DIR" -name "fishme.log.*" -type f -mtime +${LOG_RETENTION_DAYS} -delete 2>/dev/null
}

_log() {
    local level="$1"
    shift
    local message="$@"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local level_name
    case "$level" in
        $LOG_LEVEL_DEBUG) level_name="DEBUG" ;;
        $LOG_LEVEL_INFO) level_name="INFO" ;;
        $LOG_LEVEL_WARN) level_name="WARN" ;;
        $LOG_LEVEL_ERROR) level_name="ERROR" ;;
        $LOG_LEVEL_FATAL) level_name="FATAL" ;;
        *) level_name="UNKNOWN" ;;
    esac
    echo "[${timestamp}] [${level_name}] ${message}" >> "$LOG_FILE"
}

log_debug() {
    if [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_DEBUG ]]; then
        _log $LOG_LEVEL_DEBUG "$@"
    fi
}

log_info() {
    if [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_INFO ]]; then
        _log $LOG_LEVEL_INFO "$@"
    fi
}

log_warn() {
    if [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_WARN ]]; then
        _log $LOG_LEVEL_WARN "$@"
    fi
}

log_error() {
    if [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_ERROR ]]; then
        _log $LOG_LEVEL_ERROR "$@"
    fi
}

log_fatal() {
    if [[ $CURRENT_LOG_LEVEL -le $LOG_LEVEL_FATAL ]]; then
        _log $LOG_LEVEL_FATAL "$@"
    fi
}

log_command() {
    local cmd="$@"
    log_info "Executing command: ${cmd}"
}

log_session_start() {
    local session_id="$1"
    local template="$2"
    log_info "Session started: ID=${session_id}, Template=${template}"
}

log_session_end() {
    local session_id="$1"
    local duration="$2"
    local captures="$3"
    log_info "Session ended: ID=${session_id}, Duration=${duration}s, Captures=${captures}"
}

log_capture() {
    local session_id="$1"
    local ip="$2"
    local user_agent="$3"
    log_info "Capture received: Session=${session_id}, IP=${ip}, UA=${user_agent}"
}

log_error_context() {
    local error="$1"
    local context="$2"
    log_error "Error: ${error}"
    log_error "Context: ${context}"
}

get_recent_logs() {
    local lines="${1:-50}"
    tail -n "$lines" "$LOG_FILE" 2>/dev/null
}

search_logs() {
    local pattern="$1"
    grep -i "$pattern" "$LOG_FILE" 2>/dev/null
}

get_log_stats() {
    echo "Log Statistics for FishMe"
    echo "========================="
    echo "Log file: $LOG_FILE"
    echo "File size: $(du -h "$LOG_FILE" 2>/dev/null | cut -f1)"
    echo "Total entries: $(wc -l < "$LOG_FILE" 2>/dev/null)"
    echo ""
    echo "Log entries by level:"
    echo "  DEBUG: $(grep -c "DEBUG" "$LOG_FILE" 2>/dev/null || echo 0)"
    echo "  INFO: $(grep -c "INFO" "$LOG_FILE" 2>/dev/null || echo 0)"
    echo "  WARN: $(grep -c "WARN" "$LOG_FILE" 2>/dev/null || echo 0)"
    echo "  ERROR: $(grep -c "ERROR" "$LOG_FILE" 2>/dev/null || echo 0)"
    echo "  FATAL: $(grep -c "FATAL" "$LOG_FILE" 2>/dev/null || echo 0)"
}
