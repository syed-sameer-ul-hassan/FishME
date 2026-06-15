# Release Notes

## [1.0.0] - 2026-06-13

### Major Release

This is the first major release of FishMe, featuring a comprehensive phishing  and security   platform.

### New Features

#### Core Features
- **Template Management System**
  - Create, edit, delete, backup, and restore phishing templates
  - Template validation and export/import functionality
  - Template backup and restore capabilities

- **Multi-Site Management**
  - Run multiple phishing sites simultaneously
  - Site configuration management
  - Site monitoring and health checks
  - Start/stop individual or all sites

- **Export/Import System**
  - Export captured data in CSV, JSON, XML, and HTML formats
  - Import data from CSV and JSON formats
  - Export all formats at once

- **Analytics & Statistics**
  - Generate comprehensive statistics reports
  - ASCII chart generation (template, date distributions)
  - Quick summary views
  - Export statistics to JSON

- **Session Management**
  - Track and manage phishing sessions
  - Session lifecycle management
  - Capture association with sessions
  - Session export/import
  - Orphaned session detection
  - Automatic cleanup of old sessions

- **Template Generator**
  - Interactive template creation wizard
  - 3 built-in style presets (modern, corporate, dark)
  - Custom color schemes
  - Logo support
  - Automatic template structure generation

- **Report Generation**
  - Generate HTML reports with statistics and charts
  - Generate PDF reports (requires wkhtmltopdf)
  - Generate Markdown reports
  - Generate JSON reports
  - Generate all formats at once
  - Report management (list, delete)

- **Plugin System**
  - Modular plugin architecture
  - Plugin enable/disable management
  - Plugin creation wizard
  - Plugin export/import
  - Plugin validation
  - Hook system (on_capture, on_session_start, on_session_end, on_template_load)

- **Configuration Management**
  - Centralized configuration file (config/fishme.conf)
  - Get/set configuration values
  - Configuration sections for server, tunnel, paths, logging, templates, capture, UI, and security

- **Comprehensive Logging**
  - Multiple log levels (DEBUG, INFO, WARN, ERROR, FATAL)
  - Log rotation
  - Log retention management
  - Log search functionality
  - Log statistics

#### Tunneling Enhancements
- **Cloudflare Account Integration**
  - Cloudflare API authentication
  - Domain listing and selection
  - Custom domain tunnel creation
  - Proper tunnel token management
  - Enhanced error handling and validation

### Commands Added

#### Template Commands
- `fishme template list` - List all templates
- `fishme template info <name>` - Show template info
- `fishme template create <name> <display> <brand> <domain>` - Create new template
- `fishme template delete <name>` - Delete template
- `fishme template backup <name>` - Backup template
- `fishme template restore <backup>` - Restore from backup
- `fishme template export <name> [dir]` - Export template
- `fishme template import <archive>` - Import template
- `fishme template validate <name>` - Validate template

#### Export/Import Commands
- `fishme export csv [template]` - Export to CSV
- `fishme export json [template]` - Export to JSON
- `fishme export xml [template]` - Export to XML
- `fishme export html [template]` - Export to HTML
- `fishme export all` - Export to all formats
- `fishme export list` - List exports
- `fishme import csv <file>` - Import from CSV
- `fishme import json <file>` - Import from JSON

#### Analytics Commands
- `fishme stats report` - Generate full report
- `fishme stats chart <type>` - Generate chart (template/date)
- `fishme stats quick` - Show quick summary
- `fishme stats export [file]` - Export stats to JSON

#### Session Commands
- `fishme session list` - List all sessions
- `fishme session info <id>` - Show session info
- `fishme session end <id>` - End session
- `fishme session delete <id>` - Delete session
- `fishme session export <id> [file]` - Export session
- `fishme session import <file>` - Import session
- `fishme session cleanup [days]` - Clean up old sessions
- `fishme session check` - Check for orphaned sessions

#### Template Generator Commands
- `fishme generate` - Interactive template creation wizard

#### Report Commands
- `fishme report html [file]` - Generate HTML report
- `fishme report pdf [file]` - Generate PDF report
- `fishme report md [file]` - Generate Markdown report
- `fishme report json [file]` - Generate JSON report
- `fishme report all [base]` - Generate all formats
- `fishme report list` - List reports
- `fishme report delete <name>` - Delete report

#### Multi-Site Commands
- `fishme multi create <id> <template> <port> [tunnel]` - Create site config
- `fishme multi list` - List all sites
- `fishme multi start <id>` - Start site
- `fishme multi stop <id>` - Stop site
- `fishme multi stop-all` - Stop all sites
- `fishme multi status <id>` - Show site status
- `fishme multi delete <id>` - Delete site config
- `fishme multi monitor` - Monitor all sites
- `fishme multi health <id>` - Check site health
- `fishme multi export [file]` - Export site configs
- `fishme multi import <file>` - Import site configs

#### Plugin Commands
- `fishme plugin list` - List all plugins
- `fishme plugin enable <name>` - Enable plugin
- `fishme plugin disable <name>` - Disable plugin
- `fishme plugin create <name> [desc]` - Create new plugin
- `fishme plugin delete <name>` - Delete plugin
- `fishme plugin info <name>` - Show plugin info
- `fishme plugin export <name> [file]` - Export plugin
- `fishme plugin import <archive>` - Import plugin
- `fishme plugin validate <name>` - Validate plugin

#### Configuration Commands
- `fishme config get <key> [default]` - Get config value
- `fishme config set <key> <value>` - Set config value
- `fishme config show` - Show config file

#### Logging Commands
- `fishme log recent [lines]` - Show recent logs
- `fishme log search <pattern>` - Search logs
- `fishme log stats` - Show log statistics

### Improvements

- Enhanced Cloudflare login with better error handling
- Improved token validation and HTTP status code handling
- Better error messages for authentication failures
- Updated help system with new ASCII art banner
- Comprehensive documentation (README, SECURITY, RELEASES, CATALOG)

### Bug Fixes

- Fixed cloudflared command to use tunnel token directly
- Added cleanup of temporary tunnel token files
- Improved URL display logic for local vs tunnel URLs

### Documentation

- Created comprehensive README.md with all features
- Created SECURITY.md with security policies
- Created RELEASES.md with changelog
- Created CATALOG.md with template catalog
- Created CONTRIBUTING.md with guidelines
- Created INSTALLATION.md with detailed guide
- Created TROUBLESHOOTING.md with common issues
- Created ARCHITECTURE.md with system architecture

### Breaking Changes

None in this release.

### Dependencies

- PHP 7.4 or higher
- Bash shell
- curl
- jq (for JSON processing)
- git (for updates)
- cloudflared (optional, for Cloudflare tunneling)
- wkhtmltopdf (optional, for PDF report generation)

### Security

- Added input sanitization by default
- Added URL validation
- Added session timeout configuration
- Added capture limits per session
- Enhanced logging for audit purposes

### Known Issues

- PDF report generation requires wkhtmltopdf to be installed
- Cloudflare tunnel requires proper API token permissions
- Some templates may require additional dependencies

### Upgrade Notes

No special upgrade notes for this initial release.

---

## Future Releases

### Planned Features

- Web-based dashboard for easier management
- Real-time analytics dashboard
- Mobile app for monitoring
- Integration with SIEM systems
- Advanced threat intelligence features
- Machine learning for pattern detection
- Multi-language support
- Docker containerization
- Cloud deployment options

---

**Version**: 1.0.0  
**Release Date**: 2026-06-13  
**Status**: Stable
