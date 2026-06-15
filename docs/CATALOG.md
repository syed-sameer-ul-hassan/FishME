# Template Catalog

This catalog provides an overview of all available phishing  templates in FishMe.

## Available Templates

### Social Media Templates

#### Facebook
- **Slug**: `facebook`
- **Brand**: Facebook
- **Domain**: facebook.com
- **Category**: Social
- **Entry Page**: `login.html`
- **Features**:
  - Classic Facebook login page design
  - AJAX form submission
  - Redirects to legitimate Facebook login
  - Anti-debugging measures

#### Instagram
- **Slug**: `instagram`
- **Brand**: Instagram
- **Domain**: instagram.com
- **Category**: Social
- **Entry Page**: `login.html`
- **Features**:
  - Instagram-style login interface
  - AJAX form submission
  - Redirects to legitimate Instagram login
  - Mobile-responsive design

#### Discord
- **Slug**: `discord`
- **Brand**: Discord
- **Domain**: discord.com
- **Category**: Social
- **Entry Page**: `login.php`
- **Features**:
  - Discord login page with QR code
  - QR code generation and display
  - Anti-debugging JavaScript
  - Redirects to Discord 404 page

### Email Templates

#### Gmail (Google)
- **Slug**: `google`
- **Brand**: Google
- **Domain**: google.com
- **Category**: Email
- **Entry Page**: `login.html`
- **Features**:
  - Google-style login interface
  - Clean, minimalist design
  - Redirects to custom Google domain
  - Username sanitization

### Developer Platforms

#### GitHub
- **Slug**: `github`
- **Brand**: GitHub
- **Domain**: github.com
- **Category**: Developer
- **Entry Page**: `login.html`
- **Features**:
  - GitHub login page design
  - Redirects to custom GitHub domain
  - Username sanitization
  - Developer-focused layout

#### GitLab
- **Slug**: `gitlab`
- **Brand**: GitLab
- **Domain**: gitlab.com
- **Category**: Developer
- **Entry Page**: `login.html`
- **Features**:
  - GitLab-style login interface
  - Nested POST field handling
  - Redirects to capture page
  - Shows captured data to user

### Cloud Storage

#### Dropbox
- **Slug**: `dropbox`
- **Brand**: Dropbox
- **Domain**: dropbox.com
- **Category**: Cloud Storage
- **Entry Page**: `login.html`
- **Features**:
  - Dropbox login page design
  - Redirects to custom Dropbox domain
  - Username sanitization
  - Clean cloud storage interface

#### Adobe
- **Slug**: `adobe`
- **Brand**: Adobe
- **Domain**: adobe.com
- **Category**: Cloud Storage
- **Entry Page**: `login.html`
- **Features**:
  - Adobe Creative Cloud login
  - Redirects to legitimate Adobe login
  - Username sanitization
  - Professional design

### E-commerce

#### eBay
- **Slug**: `ebay`
- **Brand**: eBay
- **Domain**: ebay.com
- **Category**: Shopping
- **Entry Page**: `login.html`
- **Features**:
  - eBay login page design
  - Redirects to custom eBay domain
  - Username sanitization
  - E-commerce focused

#### Badoo
- **Slug**: `badoo`
- **Brand**: Badoo
- **Domain**: badoo.com
- **Category**: Social/Dating
- **Entry Page**: `login.html`
- **Features**:
  - Badoo-style login interface
  - Redirects to custom Badoo domain
  - Username sanitization
  - Dating platform design

### Creative Platforms

#### DeviantArt
- **Slug**: `deviantart`
- **Brand**: DeviantArt
- **Domain**: deviantart.com
- **Category**: Creative
- **Entry Page**: `login.html`
- **Features**:
  - DeviantArt login page design
  - Redirects to custom DeviantArt domain
  - Username sanitization
  - Artist community focused

## Template Structure

Each template follows a standard structure:

```
templates/<template_name>/
├── site.json          # Template metadata
├── index.php          # Entry point (redirects)
├── login.html         # Login page (HTML)
├── login.php          # Login handler (PHP)
├── script.js          # JavaScript (optional)
├── style.css          # Stylesheet (optional)
└── assets/            # Images and resources (optional)
```

## Template Metadata

Each template includes a `site.json` file with the following metadata:

```json
{
  "name": "Template Display Name",
  "slug": "template-slug",
  "brand": "Brand Name",
  "domain": "example.com",
  "category": "Category",
  "description": "Template description",
  "entry": "login.html",
  "allocated_url": "unique-url.page.dev"
}
```

## Creating Custom Templates

### Using the Template Generator

```bash
fishme generate
```

This interactive wizard will guide you through creating a custom template with:
- Template name and display name
- Brand and domain information
- Category selection
- Style selection (modern, corporate, dark)
- Custom color scheme
- Logo URL (optional)
- Redirect URL

### Manual Template Creation

1. Create a new directory in `templates/`
2. Create `site.json` with template metadata
3. Create `index.php` as entry point
4. Create `login.html` for the login page
5. Create `login.php` to handle form submissions
6. Add any additional assets (CSS, JS, images)

### Template Validation

Validate your template structure:

```bash
fishme template validate <template_name>
```

## Template Categories

- **Social**: Social media platforms (Facebook, Instagram, Discord)
- **Email**: Email services (Gmail, Outlook)
- **Developer**: Developer platforms (GitHub, GitLab)
- **Cloud Storage**: Cloud storage services (Dropbox, Adobe)
- **Shopping**: E-commerce platforms (eBay, Amazon)
- **Creative**: Creative platforms (DeviantArt, Behance)
- **Other**: Other categories

## Template Features

### Common Features

All templates include:
- Credential capture (username, password)
- IP address logging
- User agent logging
- Timestamp recording
- Redirect to legitimate site

### Advanced Features

Some templates include:
- AJAX form submission
- QR code generation
- Anti-debugging measures
- Mobile-responsive design
- Custom JavaScript functionality

## Template Security

### Input Sanitization

All templates use input sanitization via `config.php`:
- Username sanitization
- Password handling
- IP address validation
- User agent logging

### Redirect Behavior

Templates redirect to legitimate sites after capture:
- Phishing purpose
- User 
- Phishing campaigns

## Template Backup and Restore

### Backup a Template

```bash
fishme template backup <template_name>
```

### Restore a Template

```bash
fishme template restore <backup_name>
```

### List Backups

Backups are stored in `.backups/templates/` with timestamps.

## Template Export and Import

### Export a Template

```bash
fishme template export <template_name> [output_dir]
```

### Import a Template

```bash
fishme template import <archive_path>
```

## Template Statistics

View template performance statistics:

```bash
fishme stats chart template
```

This shows:
- Capture count per template
- Success rate per template
- Most effective templates

## Template Updates

### Check for Updates

```bash
fishme update
```

### Auto-update Configuration

Configure automatic template updates in `config/fishme.conf`:

```ini
[templates]
auto_update_templates=false
template_cache_dir=.cache/templates
```

## Contributing Templates

To contribute a new template:

1. Create the template following the structure
2. Validate the template
3. Test the template thoroughly
4. Submit a pull request with:
   - Template files
   - Description of the template
   - Screenshot (optional)
   - Testing notes

## Template Guidelines

### Design Guidelines

- Use realistic designs
- Include proper HTML structure
- Ensure mobile responsiveness
- Follow brand guidelines
- Include proper error handling

### Code Guidelines

- Use input sanitization
- Follow PHP best practices
- Include proper error messages
- Document custom features
- Test thoroughly

### Ethical Guidelines

- Only use for  phishing
- Obtain proper authorization
- Respect user privacy
- Follow legal requirements
- Document phishing value

## Template Support

For template-related issues:

- Check template validation: `fishme template validate <name>`
- Review template structure
- Check logs: `fishme log recent`
- Report issues on GitHub

---

**Last Updated**: 2026-06-13  
**Total Templates**: 11  
**Categories**: 7
