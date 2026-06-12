# FishMe - Phishing Awareness Training Tool

**Version:** 1.0.0  
**Purpose:** Educational cybersecurity awareness demonstration  
**License:** For academic/training use only

## Overview

FishMe is a professional phishing awareness training platform built for educational purposes. It demonstrates how phishing attacks work by simulating a fake login page, then immediately educating the user about the indicators they missed.

## Technology Stack

- **Backend:** PHP 7.4+ with MVC architecture
- **Storage:** JSON file (zero database setup, database-agnostic)
- **Frontend:** HTML5, CSS3, vanilla JavaScript
- **Routing:** Custom PSR-7 compliant router
- **CLI Tool:** Built-in command-line interface for management
- **Dependency Management:** Composer with PSR-4 autoloading
- **Configuration:** Environment-based (.env files)
- **Logging:** Structured logging with Monolog

## Installation

### Prerequisites
- PHP 7.4 or higher
- Composer (for dependency management)

### Setup Steps

1. Clone or download the FishMe directory:
   ```bash
   cd /path/to/webroot
   ```

2. Install dependencies:
   ```bash
   composer install
   ```

3. Configure environment:
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

4. Set permissions:
   ```bash
   chmod 755 storage/data
   chmod 755 storage/logs
   ```

5. Start the server:
   ```bash
   ./fishme server start
   # Or using PHP directly
   php -S localhost:8080 -t public
   ```

6. Access `http://localhost:8080/` in your browser.

## Usage

### CLI Tool

FishMe includes a powerful CLI tool for management:

```bash
# List all templates
./fishme template list

# Create a new template
./fishme template create linkedin LinkedIn https://linkedin.com

# Delete a template
./fishme template delete linkedin

# Show template information
./fishme template info facebook

# Start the development server
./fishme server start 127.0.0.1 8080

# Export captured data
./fishme export json captures.json
./fishme export csv captures.csv

# Show statistics
./fishme stats
```

### Admin Dashboard

1. Access the **Admin Dashboard** at `/admin/login`.
2. Login with default credentials:
   - Username: `admin`
   - Password: `admin123`
3. Share any template URL (e.g. `/t/instagram`) with students/participants.
4. Review the dashboard to see who "fell for" the simulation.

### For Participants/Students

1. You will receive a link to what looks like a real login page.
2. If you enter any credentials, you will be redirected to an educational page explaining that this was a phishing simulation.
3. Read the lessons to learn how to identify phishing attempts in the future.

## Project Structure

```
FishMe/
├── app/                    # Application code
│   ├── Controllers/       # MVC Controllers
│   │   ├── AdminController.php
│   │   ├── TemplateController.php
│   │   └── CaptureController.php
│   ├── Models/            # Data Models
│   │   ├── Database.php
│   │   ├── Template.php
│   │   ├── Capture.php
│   │   └── User.php
│   ├── Views/             # View templates
│   │   ├── admin/
│   │   ├── templates/
│   │   └── layouts/
│   ├── Middleware/        # Middleware classes
│   ├── Services/          # Business logic
│   └── Helpers/           # Utility classes
│       ├── Router.php
│       ├── Request.php
│       ├── Response.php
│       ├── Validator.php
│       ├── Logger.php
│       └── Env.php
├── config/                # Configuration files
│   ├── app.php
│   ├── database.php
│   └── routes.php
├── public/                # Public web root
│   ├── index.php          # Application entry point
│   └── assets/            # CSS, JS, images
├── templates/             # Phishing templates
│   ├── instagram/
│   │   ├── config.json
│   │   ├── login.html
│   │   ├── style.css
│   │   └── script.js
│   ├── facebook/
│   ├── github/
│   └── google/
├── storage/               # Storage directory
│   ├── data/              # JSON data files
│   └── logs/              # Application logs
├── tests/                 # Test files
├── vendor/                # Composer dependencies
├── .env                   # Environment configuration
├── .env.example           # Environment template
├── composer.json          # Composer configuration
├── fishme                 # CLI tool
└── README.md              # This file
```

## API Endpoints

### Admin API
- `GET /api/admin/stats` - Get statistics
- `GET /api/admin/captures` - Get all captures
- `GET /api/admin/templates` - Get all templates

### Template API
- `GET /api/templates` - List all templates
- `GET /api/templates/{name}` - Get template details
- `POST /api/templates` - Create new template
- `POST /api/templates/{name}` - Update template
- `DELETE /api/templates/{name}` - Delete template
- `GET /t/{name}` - Serve template page

### Capture API
- `POST /api/captures` - Create new capture
- `GET /api/captures` - Get all captures
- `GET /api/captures/{id}` - Get specific capture
- `GET /api/captures/stats` - Get statistics
- `GET /api/captures/export/{format}` - Export data (json/csv)

## Security Notes

- Change the default admin password in `.env` before use.
- This tool is designed for **controlled training environments only**.
- Always inform participants that they are in a phishing awareness exercise.
- The captured data is stored locally in JSON for training analysis only.
- Security headers are automatically applied (X-Frame-Options, CSP, etc.)
- Input validation and sanitization is applied to all user inputs.

## Architecture Improvements (v2.0)

### MVC Architecture
- Separation of concerns with Controllers, Models, and Views
- Clean code organization following PSR-4 autoloading standards
- Reusable components and services

### Database Abstraction
- Repository pattern for data access
- Database-agnostic design (JSON adapter, ready for MySQL/SQLite)
- Easy migration to real database if needed

### Routing System
- Centralized routing in `config/routes.php`
- RESTful API support
- Template-based routing for phishing sites

### Configuration Management
- Environment-based configuration via .env files
- Separate configs for dev/staging/production
- Secure credential management

### CLI Tool
- Template management (add, list, remove, update)
- Server management (start, stop, status)
- Data export (CSV, JSON)
- System diagnostics

### Logging
- Structured logging with Monolog
- Multiple log levels (DEBUG, INFO, WARNING, ERROR)
- Log rotation and archival

### Testing Ready
- PHPUnit integration
- Test directory structure
- CI/CD ready

## Performance Optimizations

- Zero external dependencies or CDNs
- Plain PHP without heavy frameworks
- PSR-4 autoloading for efficient class loading
- JSON for lightweight, file-based storage
- Minimal file reads/writes
- Optimized routing with regex patterns

## Migration from v1.0

If you're upgrading from v1.0:

1. Install Composer dependencies: `composer install`
2. Copy your old `data/` directory to `storage/data/`
3. Migrate templates from `sites/` to `templates/` with config.json files
4. Update your `.env` file with old settings from `config.php`
5. Update any hardcoded paths to use the new structure

## Disclaimer

This tool is for **educational and authorized security training only**. The authors are not responsible for misuse. Always obtain proper authorization before conducting phishing simulations.
