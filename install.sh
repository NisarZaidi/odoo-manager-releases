#!/bin/bash

##############################################################################
# Odoo Development Manager - Public Installer
#
# Usage (one-liner):
#   bash <(curl -fsSL https://raw.githubusercontent.com/<YOUR_GH_USER>/odoo-manager-releases/main/install.sh)
#
# NOTE: use `bash <(curl ...)`, NOT `curl ... | bash`. This script prompts
# for a license key interactively - piping into bash steals stdin (the
# pipe itself), so the prompt would never be readable. Process
# substitution (<(...)) keeps your terminal's stdin intact.
#
# What this does:
#   1. Downloads the latest release tarball from this repo's GitHub Releases
#   2. Verifies your license key (RSA signature, fully offline)
#   3. Installs the tool to ~/.local/share/odoo-manager
#   4. Adds ~/.local/bin/odoo-manager to your PATH
#   5. Wires up bash/zsh tab-completion
##############################################################################

set -e

# ---------------------------------------------------------------------------
# SELLER: fill these in before publishing this file.
# ---------------------------------------------------------------------------
GITHUB_OWNER="NisarZaidi"
GITHUB_REPO="odoo-manager-releases"
# ---------------------------------------------------------------------------

INSTALL_HOME="$HOME/.local/share/odoo-manager"
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="odoo-manager"
LICENSE_FILE="$HOME/.odoo-manager-license"

##############################################################################
# Colors
##############################################################################

if [ -t 1 ]; then
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[1;33m"
    CYAN="\033[0;36m"
    WHITE="\033[1;37m"
    BOLD="\033[1m"
    DIM="\033[2m"
    NC="\033[0m"
else
    RED=""; GREEN=""; YELLOW=""; CYAN=""; WHITE=""; BOLD=""; DIM=""; NC=""
fi

command_exists() { command -v "$1" >/dev/null 2>&1; }

box_header()
{
    local TITLE="$1"
    local WIDTH=54
    local BORDER
    BORDER=$(printf '═%.0s' $(seq 1 "$WIDTH"))

    local PAD=$(( (WIDTH - ${#TITLE}) / 2 ))
    local RPAD=$(( WIDTH - ${#TITLE} - PAD ))

    echo
    echo -e "${CYAN}╔${BORDER}╗${NC}"
    printf "${CYAN}║${NC}%*s${BOLD}${WHITE}%s${NC}%*s${CYAN}║${NC}\n" "$PAD" "" "$TITLE" "$RPAD" ""
    echo -e "${CYAN}╚${BORDER}╝${NC}"
    echo
}

step()  { echo -e "${CYAN}▸${NC} ${BOLD}$1${NC}"; }
ok()    { echo -e "  ${GREEN}✔${NC} $1"; }
fail()  { echo -e "  ${RED}✘${NC} $1"; }
warn()  { echo -e "  ${YELLOW}!${NC} $1"; }
die()
{
    echo
    echo -e "${RED}${BOLD}Error:${NC} $1"
    echo
    exit 1
}

box_header "Odoo Development Manager Installer"

##############################################################################
# Basic tooling check (needed before we can even download/verify anything)
##############################################################################

step "Checking installer requirements"
echo

for CMD in curl tar openssl; do
    if command_exists "$CMD"; then
        ok "$CMD"
    else
        fail "$CMD"
        die "'$CMD' is required to run this installer. Install it and try again."
    fi
done

echo

##############################################################################
# Download latest release tarball
##############################################################################

step "Downloading latest release"
echo

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

RELEASE_URL="https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}/releases/latest/download/odoo-manager.tar.gz"

if ! curl -fsSL "$RELEASE_URL" -o "$TMP_DIR/odoo-manager.tar.gz"; then
    die "Failed to download release from:
$RELEASE_URL

Check your internet connection, or that a release has been published at:
https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}/releases"
fi

ok "Downloaded release archive"

mkdir -p "$TMP_DIR/extracted"
tar -xzf "$TMP_DIR/odoo-manager.tar.gz" -C "$TMP_DIR/extracted"

[ -d "$TMP_DIR/extracted/bin" ] || die "Release archive is missing bin/ - it may be corrupt or built incorrectly."
[ -d "$TMP_DIR/extracted/lib" ] || die "Release archive is missing lib/ - it may be corrupt or built incorrectly."
[ -f "$TMP_DIR/extracted/lib/license.sh" ] || die "Release archive is missing lib/license.sh - license verification unavailable."

ok "Archive extracted and verified"
echo

##############################################################################
# License Activation (RSA-signed keys, fully offline)
##############################################################################

# shellcheck source=/dev/null
source "$TMP_DIR/extracted/lib/license.sh"

activate_license()
{

    box_header "License Activation"

    if [ -f "$LICENSE_FILE" ]; then

        local SAVED_KEY
        SAVED_KEY=$(cat "$LICENSE_FILE" 2>/dev/null)

        if validate_license_key "$SAVED_KEY" >/dev/null; then
            ok "Valid license found. Skipping activation."
            echo
            return 0
        fi

    fi

    echo -e "  ${WHITE}This is licensed software.${NC}"
    echo -e "  ${DIM}Enter the lifetime license key you received from the seller.${NC}"
    echo -e "  ${DIM}(Sent to you directly by email or WhatsApp - not a file.)${NC}"
    echo

    local ATTEMPTS=0

    while :
    do

        read -r -p "  License Key: " ENTERED_KEY

        if validate_license_key "$ENTERED_KEY" >/dev/null; then

            echo "$ENTERED_KEY" > "$LICENSE_FILE"
            chmod 600 "$LICENSE_FILE" 2>/dev/null

            echo
            ok "License activated successfully."
            echo
            return 0

        fi

        ATTEMPTS=$((ATTEMPTS+1))

        echo
        fail "Invalid license key."

        if [ "$ATTEMPTS" -ge 3 ]; then
            die "Too many invalid attempts. Please contact the seller for a valid license key."
        fi

        echo -e "  ${DIM}Try again.${NC}"
        echo

    done

}

activate_license

##############################################################################
# System Requirements (auto-installed if missing)
##############################################################################

step "Checking system requirements"
echo

REQUIRED_PACKAGES=()

if command_exists git; then ok "git"; else fail "git"; REQUIRED_PACKAGES+=("git"); fi
if command_exists python3; then ok "python3"; else fail "python3"; REQUIRED_PACKAGES+=("python3"); fi

if python3 -m venv --help >/dev/null 2>&1; then
    ok "python3-venv"
else
    fail "python3-venv"
    REQUIRED_PACKAGES+=("python3-venv")
fi

if command_exists pip3; then ok "pip3"; else fail "pip3"; REQUIRED_PACKAGES+=("python3-pip"); fi
if command_exists psql; then ok "postgresql"; else fail "postgresql"; REQUIRED_PACKAGES+=("postgresql" "postgresql-contrib"); fi

if dpkg -s libpq-dev >/dev/null 2>&1; then
    ok "libpq-dev"
else
    fail "libpq-dev"
    REQUIRED_PACKAGES+=("libpq-dev")
fi

if command_exists gcc; then ok "build-essential"; else fail "build-essential"; REQUIRED_PACKAGES+=("build-essential"); fi

echo

if [ ${#REQUIRED_PACKAGES[@]} -gt 0 ]; then

    warn "Missing packages will be installed:"
    echo
    printf "     ${DIM}- %s${NC}\n" "${REQUIRED_PACKAGES[@]}"
    echo
    echo -e "  ${DIM}Administrator access is required for this step.${NC}"
    echo

    if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y "${REQUIRED_PACKAGES[@]}"
        echo
        ok "System packages installed."
        echo
    else
        die "Automatic package installation is only supported on Debian/Ubuntu systems (apt-get not found).
Please install these manually and re-run this script:
$(printf '  - %s\n' "${REQUIRED_PACKAGES[@]}")"
    fi

else
    ok "All system requirements are already satisfied."
    echo
fi

##############################################################################
# Install files
##############################################################################

step "Installing Odoo Development Manager"
echo

rm -rf "$INSTALL_HOME"
mkdir -p "$INSTALL_HOME"

cp -r "$TMP_DIR/extracted/bin" "$INSTALL_HOME/bin"
cp -r "$TMP_DIR/extracted/lib" "$INSTALL_HOME/lib"

[ -d "$TMP_DIR/extracted/completion" ] && cp -r "$TMP_DIR/extracted/completion" "$INSTALL_HOME/completion"

chmod +x "$INSTALL_HOME/bin/odoo-manager"
find "$INSTALL_HOME/lib" -type f -name "*.sh" -exec chmod +x {} \;

ok "Installed to $INSTALL_HOME"
echo

##############################################################################
# Launcher
##############################################################################

step "Installing launcher"

mkdir -p "$INSTALL_DIR"

cat > "$INSTALL_DIR/$BINARY_NAME" <<EOF
#!/bin/bash
export ODOO_MANAGER_HOME="$INSTALL_HOME"
exec "$INSTALL_HOME/bin/odoo-manager" "\$@"
EOF

chmod +x "$INSTALL_DIR/$BINARY_NAME"

ok "$INSTALL_DIR/$BINARY_NAME"
echo

##############################################################################
# PATH
##############################################################################

step "Configuring PATH"

PATH_UPDATED=0

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then

    if [ -f "$HOME/.bashrc" ] && ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
        {
            echo
            echo '# Odoo Development Manager'
            echo 'export PATH="$HOME/.local/bin:$PATH"'
        } >> "$HOME/.bashrc"
        PATH_UPDATED=1
    fi

    if [ -f "$HOME/.zshrc" ] && ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"; then
        {
            echo
            echo '# Odoo Development Manager'
            echo 'export PATH="$HOME/.local/bin:$PATH"'
        } >> "$HOME/.zshrc"
        PATH_UPDATED=1
    fi

    if [ "$PATH_UPDATED" -eq 1 ]; then
        ok "Added $HOME/.local/bin to PATH"
    else
        warn "$HOME/.local/bin not in PATH, and no shell rc file found to update it automatically"
    fi

else
    ok "$HOME/.local/bin already in PATH"
fi

echo

##############################################################################
# Shell Tab-Completion (bash / zsh)
##############################################################################

step "Setting up shell tab-completion"

COMPLETION_UPDATED=0

if [ -f "$INSTALL_HOME/completion/completion.bash" ] && [ -f "$HOME/.bashrc" ] \
    && ! grep -q 'odoo-manager/completion/completion.bash' "$HOME/.bashrc"; then

    {
        echo
        echo '# Odoo Development Manager - bash tab-completion'
        echo "[ -f \"$INSTALL_HOME/completion/completion.bash\" ] && source \"$INSTALL_HOME/completion/completion.bash\""
    } >> "$HOME/.bashrc"

    COMPLETION_UPDATED=1

fi

if [ -f "$INSTALL_HOME/completion/completion.zsh" ] && [ -f "$HOME/.zshrc" ] \
    && ! grep -q 'odoo-manager/completion' "$HOME/.zshrc"; then

    {
        echo
        echo '# Odoo Development Manager - zsh tab-completion'
        echo "fpath+=(\"$INSTALL_HOME/completion\")"
        echo 'autoload -Uz compinit && compinit'
    } >> "$HOME/.zshrc"

    COMPLETION_UPDATED=1

fi

if [ "$COMPLETION_UPDATED" -eq 1 ]; then
    ok "Tab-completion configured"
else
    warn "No bash/zsh rc file found, or completion already configured - skipped"
fi

echo

##############################################################################
# Save an uninstall helper alongside the install (used by README's
# uninstall instructions)
##############################################################################

cat > "$INSTALL_HOME/uninstall.sh" <<'EOF'
#!/bin/bash
set -e
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="odoo-manager"
INSTALL_HOME="$HOME/.local/share/odoo-manager"

rm -f "$INSTALL_DIR/$BINARY_NAME"

for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -f "$RC" ] || continue
    sed -i '/# Odoo Development Manager/d' "$RC"
    sed -i '/export PATH="\$HOME\/.local\/bin:\$PATH"/d' "$RC"
    sed -i '/odoo-manager\/completion/d' "$RC"
    sed -i '/autoload -Uz compinit && compinit/d' "$RC"
done

rm -rf "$INSTALL_HOME"

echo "odoo-manager has been removed."
echo "Your workspaces, projects, databases, and saved license key were NOT touched."
EOF

chmod +x "$INSTALL_HOME/uninstall.sh"

##############################################################################
# Done
##############################################################################

box_header "Installation Completed Successfully"

echo -e "  ${WHITE}Installed Command${NC} : ${GREEN}${BOLD}odoo-manager${NC}"
echo -e "  ${WHITE}Location${NC}          : ${DIM}$INSTALL_HOME${NC}"
echo -e "  ${WHITE}Uninstall${NC}         : ${DIM}$INSTALL_HOME/uninstall.sh${NC}"
echo

if [ -t 0 ] && [ -t 1 ]; then

    echo -e "${CYAN}▸${NC} Reloading your shell so ${BOLD}odoo-manager${NC} works right away..."
    echo

    export PATH="$HOME/.local/bin:$PATH"
    exec "${SHELL:-/bin/bash}" -l

else

    echo -e "  ${WHITE}Run${NC}:"
    echo
    echo -e "      ${CYAN}source ~/.bashrc${NC}"
    echo
    echo -e "  ${DIM}or restart the terminal.${NC}"
    echo

fi
