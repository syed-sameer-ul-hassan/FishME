# Installation Guide

This guide provides detailed instructions for installing FishMe on various platforms.

## Table of Contents

- [System Requirements](#system-requirements)
- [Installation Methods](#installation-methods)
- [Platform-Specific Instructions](#platform-specific-instructions)
- [Post-Installation](#post-installation)
- [Uninstallation](#uninstallation)
- [Troubleshooting](#troubleshooting)

## System Requirements

### Minimum Requirements

- **Operating System**: Linux, macOS, or Windows (with WSL)
- **Shell**: Bash (version 4.0 or higher)
- **PHP**: 7.4 or higher
- **Disk Space**: 100 MB minimum
- **RAM**: 512 MB minimum

### Recommended Requirements

- **Operating System**: Linux (Ubuntu 20.04+, Debian 10+, CentOS 8+)
- **Shell**: Bash (version 5.0 or higher)
- **PHP**: 8.0 or higher
- **Disk Space**: 500 MB
- **RAM**: 1 GB

### Optional Dependencies

- **jq**: For JSON processing (required for some features)
- **git**: For updates (required for update command)
- **cloudflared**: For Cloudflare tunneling
- **loclx**: For LocalXpose tunneling
- **wkhtmltopdf**: For PDF report generation

## Installation Methods

### Method 1: Automated Installation (Recommended)

#### Linux/macOS

```bash
# Clone the repository
git clone https://github.com/syed-sameer-ul-hassan/FishME.git
cd FishME

# Run the installation script
chmod +x install.sh
./install.sh
```

The installation script will:
1. Check for required dependencies
2. Install cloudflared if needed
3. Install loclx if needed
4. Create a symlink to /usr/local/bin/fishme
5. Set proper permissions

### Method 2: Manual Installation

#### Linux/macOS

```bash
# Clone the repository
git clone https://github.com/syed-sameer-ul-hassan/FishME.git
cd FishME

# Make the fishme script executable
chmod +x fishme

# Test the installation
./fishme -v

# Add to PATH (optional)
sudo ln -s $(pwd)/fishme /usr/local/bin/fishme
```

#### Windows (WSL)

```bash
# Clone the repository
git clone https://github.com/syed-sameer-ul-hassan/FishME.git
cd FishME

# Make the fishme script executable
chmod +x fishme

# Test the installation
./fishme -v

# Add to PATH (add to ~/.bashrc)
echo 'export PATH="$PATH:/mnt/c/path/to/FishME"' >> ~/.bashrc
source ~/.bashrc
```

### Method 3: Docker Installation

#### Using Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'
services:
  fishme:
    image: fishme:latest
    container_name: fishme
    volumes:
      - ./FishME:/app
      - ./data:/app/capture
      - ./logs:/app/logs
    ports:
      - "8080:8080"
    environment:
      - PHP_VERSION=8.0
    command: ./fishme start
```

Run with:

```bash
docker-compose up -d
```

## Platform-Specific Instructions

### Ubuntu/Debian

```bash
# Update package list
sudo apt update

# Install required packages
sudo apt install -y php php-cli php-curl php-json jq git curl

# Install cloudflared
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Clone and install FishMe
git clone https://github.com/syed-sameer-ul-hassan/FishME.git
cd FishME
chmod +x fishme install.sh
./install.sh
```

### CentOS/RHEL

```bash
# Install EPEL repository
sudo yum install -y epel-release

# Install required packages
sudo yum install -y php php-cli php-json jq git curl

# Install cloudflared
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm
sudo rpm -i cloudflared-linux-x86_64.rpm

# Clone and install FishMe
git clone https://github.com/syed-sameer-ul-hassan/FishME.git
cd FishME
chmod +x fishme install.sh
./install.sh
```

### macOS

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required packages
brew install php jq git curl

# Install cloudflared
brew install cloudflared

# Clone and install FishMe
git clone https://github.com/syed-sameer-ul-hassan/FishME.git
cd FishME
chmod +x fishme install.sh
./install.sh
```

### Arch Linux

```bash
# Install required packages
sudo pacman -S php php-curl jq git curl

# Install cloudflared
sudo pacman -S cloudflared

# Clone and install FishMe
git clone https://github.com/syed-sameer-ul-hassan/FishME.git
cd FishME
chmod +x fishme install.sh
./install.sh
```

### Windows (WSL2)

```bash
# Update WSL
wsl --update

# Install Ubuntu from Microsoft Store
# Open Ubuntu terminal

# Install required packages
sudo apt update
sudo apt install -y php php-cli php-curl php-json jq git curl

# Install cloudflared
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Clone and install FishMe
git clone https://github.com/syed-sameer-ul-hassan/FishME.git
cd FishME
chmod +x fishme install.sh
./install.sh
```

## Post-Installation

### Verify Installation

```bash
# Check version
fishme -v

# Show help
fishme -h

# List templates
fishme list
```

### Configure FishMe

```bash
# Show configuration
fishme config show

# Set custom port
fishme config set server.default_port 8081

# Set default template
fishme config set templates.default_template facebook
```

### Initialize Directories

FishMe automatically creates required directories on first run:

- `config/` - Configuration files
- `logs/` - Log files
- `sessions/` - Session data
- `exports/` - Exported data
- `reports/` - Generated reports
- `plugins/` - Custom plugins
- `.cache/` - Cache directory
- `.backups/` - Template backups
- `.multi_site/` - Multi-site configurations

### Test Installation

```bash
# Start a test server
fishme start

# Select a template (e.g., facebook)
# Use default port (8080)
# Skip tunnel for testing

# Open browser to http://127.0.0.1:8080
# Verify the page loads correctly

# Stop with Ctrl+C
```

## Uninstallation

### Automated Uninstallation

```bash
# Run the uninstall command
fishme uninstall
```

This will:
1. Remove the symlink from /usr/local/bin
2. Preserve the source directory
3. Ask for confirmation before removing

### Manual Uninstallation

```bash
# Remove symlink
sudo rm /usr/local/bin/fishme

# Or remove from PATH in ~/.bashrc
# Edit ~/.bashrc and remove the fishme line

# Optionally remove source directory
rm -rf /path/to/FishME
```

### Clean Uninstallation

To remove all FishMe data:

```bash
# Remove FishMe directory
rm -rf /path/to/FishME

# Remove configuration
rm -rf ~/.config/fishme

# Remove logs (if in different location)
rm -rf /var/log/fishme

# Remove cloudflared (optional)
sudo apt remove cloudflared  # Ubuntu/Debian
sudo yum remove cloudflared  # CentOS/RHEL
brew uninstall cloudflared    # macOS
```

## Troubleshooting

### Permission Denied

**Problem**: `bash: ./fishme: Permission denied`

**Solution**:
```bash
chmod +x fishme
```

### Command Not Found

**Problem**: `fishme: command not found`

**Solution**:
```bash
# Check if fishme is in PATH
which fishme

# If not, add to PATH
export PATH="$PATH:/path/to/FishME"

# Or create symlink
sudo ln -s /path/to/FishME/fishme /usr/local/bin/fishme
```

### PHP Not Found

**Problem**: `php: command not found`

**Solution**:
```bash
# Ubuntu/Debian
sudo apt install php php-cli

# CentOS/RHEL
sudo yum install php php-cli

# macOS
brew install php
```

### jq Not Found

**Problem**: `jq: command not found`

**Solution**:
```bash
# Ubuntu/Debian
sudo apt install jq

# CentOS/RHEL
sudo yum install jq

# macOS
brew install jq
```

### Cloudflared Issues

**Problem**: Cloudflare tunnel not working

**Solution**:
```bash
# Check if cloudflared is installed
which cloudflared

# Install cloudflared
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Verify installation
cloudflared --version
```

### Port Already in Use

**Problem**: Port 8080 already in use

**Solution**:
```bash
# Find what's using the port
lsof -i :8080

# Kill the process
kill -9 <PID>

# Or use a different port
fishme config set server.default_port 8081
```

### Permission Issues with Directories

**Problem**: Cannot write to directories

**Solution**:
```bash
# Fix permissions
sudo chown -R $USER:$USER /path/to/FishME
chmod -R 755 /path/to/FishME
```

### Library Files Not Found

**Problem**: Library files not loading

**Solution**:
```bash
# Check if lib directory exists
ls -la lib/

# Reinstall FishMe
cd /path/to/FishME
./install.sh
```

## Upgrading

### Using Update Command

```bash
# Update from GitHub
fishme update
```

### Manual Upgrade

```bash
# Backup current installation
cp -r FishME FishME.backup

# Pull latest changes
cd FishME
git pull origin main

# Reinstall if needed
./install.sh
```

## Verification

### Complete Installation Check

```bash
# Check version
fishme -v

# Check help
fishme -h

# Check templates
fishme list

# Check configuration
fishme config show

# Check logs
fishme log recent 10
```

### System Requirements Check

```bash
# Check PHP version
php -v

# Check Bash version
bash --version

# Check jq
jq --version

# Check git
git --version

# Check cloudflared
cloudflared --version
```

## Additional Resources

- [README.md](../README.md) - Main documentation
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Troubleshooting guide
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture
- [SECURITY.md](SECURITY.md) - Security information

## Support

For installation issues:
- GitHub Issues: https://github.com/syed-sameer-ul-hassan/FishME/issues
- Email: support@example.com (placeholder)

---

**Last Updated**: 2026-06-13
