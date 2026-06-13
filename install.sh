#!/bin/bash

RED="$(printf '\033[31m')"
GREEN="$(printf '\033[32m')"
ORANGE="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"
WHITE="$(printf '\033[37m')"
BOLD="$(printf '\033[1m')"
DIM="$(printf '\033[2m')"
RESET="$(printf '\033[0m')"

INSTALL_DIR="/usr/local/bin"
SCRIPT_DIR=$(realpath "$(dirname "$BASH_SOURCE")")
FISHME_SRC="${SCRIPT_DIR}/fishme"
FISHME_DEST="${INSTALL_DIR}/fishme"

clear
echo -e "${CYAN}"
echo -e " ________  .-./\`)    .-'''-. .---.  .---. ,---.    ,---.    .-''-.   "
echo -e " |        |\ .-.')  / _     \\|   |  |_ _| |    \\  /    |  .'_ _   \\  "
echo -e " |   .----'/ \`-' \\ (\`' )/\`--'|   |  ( ' ) |  ,  \\/  ,  | / ( \` )   '"
echo -e " |  _|____  \`-'\`\"\`(_ o _).   |   '-(_{;}_)|  |\\_   /|  |. (_ o _)  |"
echo -e " |_( )_   | .---.  (_,_). '. |      (_,_) |  _( )_/ |  ||  (_,_)___|"
echo -e " (_ o._)__| |   | .---.  \\  :| _ _--.   | | (_ o _) |  |'  \\   .---."
echo -e " |(_,_)     |   | \\    \`-'  ||( ' ) |   | |  (_,_)  |  | \\  \`-'    /"
echo -e " |   |      |   |  \\       / (_{;}_)|   | |  |      |  |  \\       / "
echo -e " '---'      '---'   \`-..-'  '(_,_) '---' '--'      '--'   \`'-..-'  ${WHITE} Installer${RESET}"
echo -e "${GREEN}  Phishing Awareness & Security Training Platform${RESET}"
echo -e "${ORANGE}  Educational Use Only — University Project${RESET}"
echo

echo -e "${CYAN}─────────────────────────────────────────────────────────────${RESET}"
echo -e "${CYAN}${RESET}                  ${BOLD}FishMe Installer${RESET}                           ${CYAN}│${RESET}"
echo -e "${CYAN}─────────────────────────────────────────────────────────────${RESET}"
echo

echo -e "  ${CYAN}[i]${RESET} Source     : ${WHITE}${FISHME_SRC}${RESET}"
echo -e "  ${CYAN}[i]${RESET} Install to : ${WHITE}${FISHME_DEST}${RESET}"
echo

if [[ ! -f "${FISHME_SRC}" ]]; then
    echo -e "  ${RED}[!]${RESET} Cannot find source file: ${FISHME_SRC}"
    exit 1
fi

if ! command -v php &>/dev/null; then
    echo -e "  ${ORANGE}[!]${RESET} Warning: PHP is not installed. FishMe requires PHP to run."
fi

echo -e "  ${CYAN}[i]${RESET} Checking for cloudflared (Cloudflare Tunnel)..."
if command -v cloudflared &>/dev/null; then
    echo -e "  ${GREEN}[✓]${RESET} cloudflared is already installed: $(cloudflared --version 2>&1 | head -1)"
else
    echo -e "  ${CYAN}[-]${RESET} Downloading cloudflared..."
    mkdir -p ~/Downloads
    wget -q --show-progress \
        https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb \
        -O ~/Downloads/cloudflared-linux-amd64.deb

    echo -e "  ${CYAN}[-]${RESET} Installing cloudflared..."
    if sudo dpkg -i ~/Downloads/cloudflared-linux-amd64.deb 2>/dev/null; then
        sudo apt --fix-broken install -y 2>/dev/null
        echo -e "  ${GREEN}[✓]${RESET} cloudflared installed: $(cloudflared --version 2>&1 | head -1)"
    else
        echo -e "  ${ORANGE}[!]${RESET} cloudflared install failed — trying fix..."
        sudo apt --fix-broken install -y 2>/dev/null
        if command -v cloudflared &>/dev/null; then
            echo -e "  ${GREEN}[✓]${RESET} cloudflared installed after fix."
        else
            echo -e "  ${RED}[!]${RESET} Could not install cloudflared. You can install it manually:"
            echo -e "      ${WHITE}cd ~/Downloads${RESET}"
            echo -e "      ${WHITE}wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb${RESET}"
            echo -e "      ${WHITE}sudo dpkg -i cloudflared-linux-amd64.deb${RESET}"
        fi
    fi
fi

echo -e "  ${CYAN}[-]${RESET} Installing fishme to ${FISHME_DEST}..."

if sudo cp "${FISHME_SRC}" "${FISHME_DEST}" && sudo chmod +x "${FISHME_DEST}"; then
    echo
    echo -e "  ${GREEN}[✓]${RESET} FishMe installed successfully!"
    echo
    echo -e "  ${BOLD}You can now run:${RESET}"
    echo -e "    ${WHITE}fishme start${RESET}       — Launch a phishing demo"
    echo -e "    ${WHITE}fishme list${RESET}        — List templates"
    echo -e "    ${WHITE}fishme capture${RESET}     — View captured data"
    echo -e "    ${WHITE}fishme help${RESET}        — Show help"
    echo -e "    ${WHITE}fishme -v${RESET}          — Show version"
    echo
    echo -e "  ${DIM}Source folder: ${SCRIPT_DIR}${RESET}"
    echo
else
    echo -e "  ${RED}[!]${RESET} Installation failed. Try running with sudo:"
    echo -e "      ${WHITE}sudo bash install.sh${RESET}"
    exit 1
fi
