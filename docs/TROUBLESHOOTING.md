# Troubleshooting Guide

This guide helps you resolve common issues with FishMe.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Startup Issues](#startup-issues)
- [Template Issues](#template-issues)
- [Tunneling Issues](#tunneling-issues)
- [Capture Issues](#capture-issues)
- [Export/Import Issues](#exportimport-issues)
- [Configuration Issues](#configuration-issues)
- [Plugin Issues](#plugin-issues)
- [Performance Issues](#performance-issues)
- [Getting Help](#getting-help)

## Installation Issues

### Permission Denied

**Problem**: `bash: ./fishme: Permission denied`

**Solution**:
```bash
chmod +x fishme
```

### Command Not Found

**Problem**: `fishme: command not found`

**Solutions**:

1. Check if fishme is in PATH:
```bash
which fishme
```

2. Add to PATH temporarily:
```bash
export PATH="$PATH:/path/to/FishME"
```

3. Add to PATH permanently (add to ~/.bashrc):
```bash
echo 'export PATH="$PATH:/path/to/FishME"' >> ~/.bashrc
source ~/.bashrc
```

4. Create symlink:
```bash
sudo ln -s /path/to/FishME/fishme /usr/local/bin/fishme
```

### PHP Not Found

**Problem**: `php: command not found`

**Solution**:

Ubuntu/Debian:
```bash
sudo apt update
sudo apt install php php-cli php-curl php-json
```

CentOS/RHEL:
```bash
sudo yum install php php-cli php-curl
```

macOS:
```bash
brew install php
```

### jq Not Found

**Problem**: `jq: command not found`

**Solution**:

Ubuntu/Debian:
```bash
sudo apt install jq
```

CentOS/RHEL:
```bash
sudo yum install jq
```

macOS:
```bash
brew install jq
```

### Library Files Not Loading

**Problem**: Library functions not found

**Solution**:

1. Check lib directory:
```bash
ls -la lib/
```

2. Verify file permissions:
```bash
chmod +x lib/*.sh
```

3. Reinstall:
```bash
./install.sh
```

## Startup Issues

### Port Already in Use

**Problem**: `Port 8080 is already in use`

**Solutions**:

1. Find what's using the port:
```bash
lsof -i :8080
# or
netstat -tulpn | grep :8080
```

2. Kill the process:
```bash
kill -9 <PID>
```

3. Use a different port:
```bash
fishme config set server.default_port 8081
```

### Template Not Found

**Problem**: `Template not found: facebook`

**Solutions**:

1. List available templates:
```bash
fishme list
```

2. Check template directory:
```bash
ls -la templates/
```

3. Validate template:
```bash
fishme template validate facebook
```

### PHP Server Won't Start

**Problem**: PHP server fails to start

**Solutions**:

1. Check PHP version:
```bash
php -v
```

2. Check PHP configuration:
```bash
php -i | grep error_log
```

3. Try manual PHP server:
```bash
php -S 127.0.0.1:8080
```

4. Check logs:
```bash
fishme log recent 50
```

## Template Issues

### Template Validation Failed

**Problem**: Template validation fails

**Solutions**:

1. Check template structure:
```bash
ls -la templates/facebook/
```

2. Verify site.json:
```bash
cat templates/facebook/site.json
```

3. Check required files:
```bash
ls templates/facebook/index.php
ls templates/facebook/login.html
ls templates/facebook/login.php
```

4. Re-create template:
```bash
fishme template delete facebook
fishme template create facebook "Facebook" "Facebook" "facebook.com"
```

### Template Not Loading

**Problem**: Template page shows blank or error

**Solutions**:

1. Check PHP errors:
```bash
tail -f logs/fishme.log
```

2. Verify router.php:
```bash
cat router.php
```

3. Check config.php:
```bash
cat config.php
```

4. Test PHP directly:
```bash
php -r "echo 'PHP is working';"
```

### Template Backup Failed

**Problem**: Cannot backup template

**Solutions**:

1. Check backup directory:
```bash
ls -la .backups/templates/
```

2. Create backup directory:
```bash
mkdir -p .backups/templates
```

3. Check permissions:
```bash
chmod -R 755 .backups/
```

## Tunneling Issues

### Cloudflare Tunnel Failed

**Problem**: Cloudflare tunnel not working

**Solutions**:

1. Check cloudflared installation:
```bash
which cloudflared
cloudflared --version
```

2. Install cloudflared:
```bash
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
```

3. Check API token:
```bash
cat .cf_token
```

4. Re-login:
```bash
rm .cf_token
# During server start, select Cloudflare with account and login again
```

### Cloudflare Authentication Failed

**Problem**: `Authentication failed. Invalid token`

**Solutions**:

1. Verify token permissions:
- Zone - Zone - Read
- Account - Account Settings - Read

2. Get new token from: https://dash.cloudflare.com/profile/api-tokens

3. Re-login:
```bash
rm .cf_token
# During server start, select Cloudflare with account and login again
```

### LocalXpose Not Working

**Problem**: LocalXpose tunnel fails

**Solutions**:

1. Check loclx installation:
```bash
which loclx
```

2. Install loclx:
```bash
curl -s https://loclx.io/loclx.sh | bash
```

3. Check loclx token:
```bash
cat .loclx_token
```

4. Login to LocalXpose:
```bash
loclx login
```

### Tunnel URL Not Showing

**Problem**: Tunnel URL not displayed

**Solutions**:

1. Wait longer for tunnel to establish (up to 30 seconds)

2. Check tunnel logs:
```bash
fishme log recent 100
```

3. Try manual cloudflared:
```bash
cloudflared tunnel --url http://127.0.0.1:8080
```

## Capture Issues

### Captures Not Saving

**Problem**: Captures not being saved

**Solutions**:

1. Check capture directory:
```bash
ls -la capture/
```

2. Create capture directory:
```bash
mkdir -p capture
chmod 755 capture
```

3. Check PHP write permissions:
```bash
ls -ld capture/
```

4. Test capture manually:
```bash
echo '{"test":"data"}' > capture/test.json
```

### Capture File Corrupted

**Problem**: Capture file is corrupted

**Solutions**:

1. Validate JSON:
```bash
jq empty capture/facebook.json
```

2. Backup corrupted file:
```bash
cp capture/facebook.json capture/facebook.json.backup
```

3. Try to fix JSON:
```bash
jq . capture/facebook.json.backup > capture/facebook.json
```

### No Captures Showing

**Problem**: No captures in viewer

**Solutions**:

1. Check if captures exist:
```bash
ls capture/*.json
```

2. Check viewer.php:
```bash
cat viewer.php
```

3. Open viewer directly:
```bash
php -S 127.0.0.1:8080
# Open http://127.0.0.1:8080/viewer.php
```

## Export/Import Issues

### Export Failed

**Problem**: Export command fails

**Solutions**:

1. Check exports directory:
```bash
ls -la exports/
```

2. Create exports directory:
```bash
mkdir -p exports
chmod 755 exports
```

3. Check jq installation:
```bash
jq --version
```

4. Try manual export:
```bash
jq '.' capture/facebook.json > exports/test.json
```

### Import Failed

**Problem**: Import command fails

**Solutions**:

1. Check file exists:
```bash
ls -la exports/test.json
```

2. Validate JSON:
```bash
jq empty exports/test.json
```

3. Check file permissions:
```bash
chmod 644 exports/test.json
```

4. Check capture directory:
```bash
ls -la capture/
```

### CSV Export Empty

**Problem**: CSV export is empty

**Solutions**:

1. Check if captures exist:
```bash
ls capture/*.json
```

2. Check jq CSV conversion:
```bash
jq -r '.[] | [.username, .password, .timestamp] | @csv' capture/*.json
```

3. Verify capture format:
```bash
jq '.' capture/facebook.json
```

## Configuration Issues

### Config File Not Found

**Problem**: Config file not found

**Solutions**:

1. Check config directory:
```bash
ls -la config/
```

2. Create config directory:
```bash
mkdir -p config
```

3. Create default config:
```bash
cat > config/fishme.conf << 'EOF'
[server]
default_host=127.0.0.1
default_port=8080

[tunnel]
default_tunnel=cloudflare
EOF
```

### Config Not Loading

**Problem**: Configuration values not loading

**Solutions**:

1. Check config file:
```bash
cat config/fishme.conf
```

2. Validate config format:
```bash
# Check for proper INI format
```

3. Reinitialize config:
```bash
rm config/fishme.conf
# FishMe will recreate it
```

### Config Value Not Setting

**Problem**: Cannot set config value

**Solutions**:

1. Check config file permissions:
```bash
ls -la config/fishme.conf
```

2. Fix permissions:
```bash
chmod 644 config/fishme.conf
```

3. Try manual edit:
```bash
nano config/fishme.conf
```

## Plugin Issues

### Plugin Not Loading

**Problem**: Plugin not loading

**Solutions**:

1. Check plugin directory:
```bash
ls -la plugins/
```

2. Check plugin files:
```bash
ls -la plugins/my_plugin/
```

3. Validate plugin:
```bash
fishme plugin validate my_plugin
```

4. Enable plugin:
```bash
fishme plugin enable my_plugin
```

### Plugin Hook Not Called

**Problem**: Plugin hook not being called

**Solutions**:

1. Check plugin code:
```bash
cat plugins/my_plugin/plugin.sh
```

2. Verify hook function name:
```bash
grep "on_capture" plugins/my_plugin/plugin.sh
```

3. Check plugin is enabled:
```bash
fishme plugin list
```

### Plugin Creation Failed

**Problem**: Cannot create plugin

**Solutions**:

1. Check plugins directory:
```bash
ls -la plugins/
```

2. Create plugins directory:
```bash
mkdir -p plugins
chmod 755 plugins
```

3. Check jq installation:
```bash
jq --version
```

## Performance Issues

### Slow Server Response

**Problem**: Server responding slowly

**Solutions**:

1. Check system resources:
```bash
top
# or
htop
```

2. Check PHP processes:
```bash
ps aux | grep php
```

3. Clear cache:
```bash
rm -rf .cache/*
```

4. Check log file size:
```bash
ls -lh logs/fishme.log
```

### High Memory Usage

**Problem**: High memory consumption

**Solutions**:

1. Check memory usage:
```bash
free -h
```

2. Clean up old sessions:
```bash
fishme session cleanup 30
```

3. Clean up old logs:
```bash
find logs/ -name "*.log" -mtime +7 -delete
```

4. Reduce log retention:
```bash
fishme config set logging.log_retention_days 3
```

### Disk Space Full

**Problem**: No disk space left

**Solutions**:

1. Check disk space:
```bash
df -h
```

2. Clean up exports:
```bash
rm exports/*
```

3. Clean up reports:
```bash
rm reports/*
```

4. Clean up backups:
```bash
rm .backups/templates/*
```

5. Clean up logs:
```bash
rm logs/*.log
```

## Getting Help

### Check Logs First

Always check logs before asking for help:

```bash
# Recent logs
fishme log recent 100

# Search logs
fishme log search "error"

# Log statistics
fishme log stats
```

### Gather System Information

Collect system information when reporting issues:

```bash
# System info
uname -a

# FishMe version
fishme -v

# PHP version
php -v

# Bash version
bash --version

# jq version
jq --version

# Git version
git --version
```

### Report Issues

When reporting issues, include:

1. **Description**: What you were trying to do
2. **Steps**: Steps to reproduce the issue
3. **Expected**: What you expected to happen
4. **Actual**: What actually happened
5. **Logs**: Relevant log output
6. **Environment**: System information

### Where to Get Help

- **GitHub Issues**: https://github.com/syed-sameer-ul-hassan/FishME/issues
- **Documentation**: 
  - [README.md](../README.md)
  - [INSTALLATION.md](INSTALLATION.md)
  - [ARCHITECTURE.md](ARCHITECTURE.md)
- **Email**: support@example.com (placeholder)

### Common Solutions Summary

| Issue | Solution |
|-------|----------|
| Permission denied | `chmod +x fishme` |
| Command not found | Add to PATH or create symlink |
| PHP not found | Install PHP |
| Port in use | Use different port or kill process |
| Template not found | Check templates directory |
| Tunnel failed | Install cloudflared/loclx |
| Captures not saving | Check capture directory permissions |
| Export failed | Check exports directory and jq |
| Config not loading | Recreate config file |
| Plugin not loading | Validate and enable plugin |

---

**Last Updated**: 2026-06-13
