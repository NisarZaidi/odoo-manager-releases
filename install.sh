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
##############################################################################

set -e

# ---------------------------------------------------------------------------
# SELLER: fill these in before publishing this file.
# ---------------------------------------------------------------------------
GITHUB_OWNER="NisarZaidi"
GITHUB_REPO="odoo-manager-releases"
PRODUCT_NAME="Odoo Development Manager"
PRODUCT_VERSION="2.1"
SUPPORT_CONTACT="nisarzaidi75@gmail.com / +92-301-2122387"
FREE_LIMIT=100
# ---------------------------------------------------------------------------

INSTALL_HOME="$HOME/.local/share/odoo-manager"
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="odoo-manager"
LICENSE_FILE="$HOME/.odoo-manager-license"

##############################################################################
# Colors & Symbols
##############################################################################

if [ -t 1 ]; then
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[1;33m"
    BLUE="\033[0;34m"
    MAGENTA="\033[0;35m"
    CYAN="\033[0;36m"
    WHITE="\033[1;37m"
    BOLD="\033[1m"
    DIM="\033[2m"
    NC="\033[0m"
else
    RED=""; GREEN=""; YELLOW=""; BLUE=""; MAGENTA=""; CYAN=""; WHITE=""; BOLD=""; DIM=""; NC=""
fi

CHECK="✔"
CROSS="✘"
ARROW="▸"
BULLET="•"
DOT="●"

command_exists() { command -v "$1" >/dev/null 2>&1; }

hash_file_sha256()
{
    local FILE="$1"

    if command_exists sha256sum; then
        sha256sum "$FILE" | awk '{print $1}'
    elif command_exists shasum; then
        shasum -a 256 "$FILE" | awk '{print $1}'
    else
        return 1
    fi
}

verify_download_checksum()
{
    local FILE="$1"
    local CHECKSUM_FILE="$2"

    [ -f "$FILE" ] || return 1
    [ -f "$CHECKSUM_FILE" ] || return 1

    local EXPECTED
    EXPECTED=$(awk '{print $1}' "$CHECKSUM_FILE" | head -n1 | tr -d '[:space:]')

    [ -n "$EXPECTED" ] || return 1

    local ACTUAL
    ACTUAL=$(hash_file_sha256 "$FILE") || return 2

    [ "$EXPECTED" = "$ACTUAL" ]
}

##############################################################################
# UI Primitives
##############################################################################

term_width()
{
    local W
    if command_exists tput; then
        W=$(tput cols 2>/dev/null)
    fi
    echo "${W:-64}"
}

hr()
{
    local WIDTH
    WIDTH=$(term_width)
    [ "$WIDTH" -gt 78 ] && WIDTH=78
    printf "${DIM}"
    printf '─%.0s' $(seq 1 "$WIDTH")
    printf "${NC}\n"
}

center_text()
{
    local TEXT="$1"
    local WIDTH="$2"
    local LEN=${#TEXT}
    [ "$LEN" -ge "$WIDTH" ] && { echo "$TEXT"; return; }
    local TOTAL_PAD=$((WIDTH - LEN))
    local LEFT=$((TOTAL_PAD / 2))
    local RIGHT=$((TOTAL_PAD - LEFT))
    printf "%*s%s%*s" "$LEFT" "" "$TEXT" "$RIGHT" ""
}

box_header()
{
    local TITLE="$1"
    local SUBTITLE="$2"
    local WIDTH=58
    local BORDER
    BORDER=$(printf '═%.0s' $(seq 1 "$WIDTH"))

    echo
    echo -e "${CYAN}╔${BORDER}╗${NC}"
    echo -e "${CYAN}║${NC}$(center_text "$TITLE" "$WIDTH")${CYAN}║${NC}"
    if [ -n "$SUBTITLE" ]; then
        echo -e "${CYAN}║${NC}${DIM}$(center_text "$SUBTITLE" "$WIDTH")${NC}${CYAN}║${NC}"
    fi
    echo -e "${CYAN}╚${BORDER}╝${NC}"
    echo
}

section()
{
    local N="$1"
    local TOTAL="$2"
    local TITLE="$3"
    echo
    echo -e "${BOLD}${WHITE}[${N}/${TOTAL}]${NC} ${BOLD}${TITLE}${NC}"
    hr
}

ok()      { echo -e "  ${GREEN}${CHECK}${NC} $1"; }
fail()    { echo -e "  ${RED}${CROSS}${NC} $1"; }
warn()    { echo -e "  ${YELLOW}!${NC} $1"; }
info()    { echo -e "  ${CYAN}${ARROW}${NC} $1"; }
kv()      { printf "  ${WHITE}%-16s${NC} : %s\n" "$1" "$2"; }

die()
{
    echo
    echo -e "${RED}${BOLD}✘ Installation Failed${NC}"
    echo
    echo -e "  $1"
    echo
    echo -e "  ${DIM}Need help? Contact: ${SUPPORT_CONTACT}${NC}"
    echo
    exit 1
}

TOTAL_STEPS=7

##############################################################################
# Welcome Screen
##############################################################################

clear 2>/dev/null || true

box_header "${PRODUCT_NAME}" "Version ${PRODUCT_VERSION}  •  Installer"

echo -e "  ${DIM}This installer will:${NC}"
echo -e "    ${BULLET} Activate your license (free tier available for first ${FREE_LIMIT} developers)"
echo -e "    ${BULLET} Check and install required system packages"
echo -e "    ${BULLET} Download and install ${PRODUCT_NAME}"
echo -e "    ${BULLET} Configure your shell (PATH + tab-completion)"
echo
hr

##############################################################################
# STEP 1 - Installer requirements
##############################################################################

section 1 "$TOTAL_STEPS" "Checking Installer Requirements"

MISSING_TOOLS=()
for CMD in curl tar openssl jq; do
    if command_exists "$CMD"; then
        ok "$CMD"
    else
        fail "$CMD not found"
        MISSING_TOOLS+=("$CMD")
    fi
done

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    die "Missing required tools: ${MISSING_TOOLS[*]}
  Install them and re-run this installer."
fi

##############################################################################
# STEP 2 - Download release
##############################################################################

section 2 "$TOTAL_STEPS" "Downloading ${PRODUCT_NAME}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

RELEASE_URL="https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}/releases/latest/download/odoo-manager.tar.gz"
RELEASE_SHA256_URL="${RELEASE_URL}.sha256"

info "Fetching latest release..."

if ! curl -fsSL "$RELEASE_URL" -o "$TMP_DIR/odoo-manager.tar.gz"; then
    die "Failed to download release from:
  ${RELEASE_URL}

  Check your internet connection, or that a release has been published at:
  https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}/releases"
fi

ok "Release downloaded"

if curl -fsSL "$RELEASE_SHA256_URL" -o "$TMP_DIR/odoo-manager.tar.gz.sha256"; then

    if verify_download_checksum "$TMP_DIR/odoo-manager.tar.gz" "$TMP_DIR/odoo-manager.tar.gz.sha256"; then
        ok "Checksum verified"
    else
        CHECKSUM_STATUS=$?

        if [ "$CHECKSUM_STATUS" -eq 2 ]; then
            warn "Checksum file was found, but no SHA-256 tool is installed to verify it."
        else
            die "Checksum verification failed for the downloaded release.

  Expected checksum file:
  ${RELEASE_SHA256_URL}

  The download may be corrupted or tampered with. Please try again."
        fi
    fi

else
    warn "No checksum file published for the latest release - skipping checksum verification."
fi

mkdir -p "$TMP_DIR/extracted"
tar -xzf "$TMP_DIR/odoo-manager.tar.gz" -C "$TMP_DIR/extracted"

[ -d "$TMP_DIR/extracted/bin" ]              || die "Release archive is missing bin/ - it may be corrupt."
[ -d "$TMP_DIR/extracted/lib" ]              || die "Release archive is missing lib/ - it may be corrupt."
[ -f "$TMP_DIR/extracted/lib/license.sh" ]   || die "Release archive is missing lib/license.sh - license verification unavailable."

ok "Archive verified"

##############################################################################
# STEP 3 - License Activation
##############################################################################

# shellcheck source=/dev/null
source "$TMP_DIR/extracted/lib/license.sh"

activate_license()
{

    section 3 "$TOTAL_STEPS" "License Activation"

    # Check for existing license
    if [ -f "$LICENSE_FILE" ]; then

        local SAVED_KEY
        SAVED_KEY=$(cat "$LICENSE_FILE" 2>/dev/null)
        local SAVED_TIER

        if SAVED_TIER=$(validate_license_key "$SAVED_KEY"); then
            local TIER_DISPLAY="${SAVED_TIER%%:*}"
            ok "Existing license verified"
            kv "License Key" "$SAVED_KEY"
            kv "Tier" "$TIER_DISPLAY"
            echo
            return 0
        fi

    fi

    # Check for jq (needed for Supabase API)
    if ! command_exists jq; then
        warn "jq is required for license verification. Attempting to install..."
        if command_exists apt-get; then
            sudo apt-get install -y jq >/dev/null 2>&1 || true
        fi
        if ! command_exists jq; then
            die "jq is required but could not be installed.
  Install it manually: sudo apt-get install jq
  Then re-run this installer."
        fi
        ok "jq installed"
    fi

    echo
    echo -e "  ${WHITE}${PRODUCT_NAME} — License Options${NC}"
    echo
    echo -e "  ${WHITE}1${NC}) Free Tier (first ${FREE_LIMIT} developers — lifetime access)"
    echo -e "  ${WHITE}2${NC}) Enter Paid License Key"
    echo

    local CHOICE
    read -r -p "  Select (1/2): " CHOICE
    echo

    case "$CHOICE" in

        1)
            # Free tier self-service registration
            if register_free_tier; then
                return 0
            else
                die "Free registration failed.
  Please contact ${SUPPORT_CONTACT} for assistance."
            fi
            ;;

        2)
            # Manual key entry
            echo -e "  ${DIM}Paste the license key you received from the seller.${NC}"
            echo

            local ATTEMPTS=0
            local MAX_ATTEMPTS=3

            while :
            do
                read -r -p "  License Key: " ENTERED_KEY
                echo

                # Validate key format (ODM-PRO-XXXX-XXXX or ODM-ENT-XXXX-XXXX)
                if ! echo "$ENTERED_KEY" | grep -qE '^ODM-'; then
                    fail "Invalid key format. Key should start with ODM-"
                    ATTEMPTS=$((ATTEMPTS+1))
                    if [ "$ATTEMPTS" -ge "$MAX_ATTEMPTS" ]; then
                        die "Too many invalid attempts. Contact: ${SUPPORT_CONTACT}"
                    fi
                    echo -e "  ${DIM}Please try again.${NC}"
                    echo
                    continue
                fi

                local TIER_RESULT
                if TIER_RESULT=$(validate_license_key "$ENTERED_KEY"); then
                    local TIER_DISPLAY="${TIER_RESULT%%:*}"

                    echo "$ENTERED_KEY" > "$LICENSE_FILE"
                    chmod 600 "$LICENSE_FILE" 2>/dev/null

                    ok "License verified successfully"
                    kv "License Key" "$ENTERED_KEY"
                    kv "Tier" "$TIER_DISPLAY"
                    echo
                    return 0
                fi

                ATTEMPTS=$((ATTEMPTS+1))
                fail "Invalid or inactive license key ($ATTEMPTS/$MAX_ATTEMPTS attempts)"

                if [ "$ATTEMPTS" -ge "$MAX_ATTEMPTS" ]; then
                    die "Too many invalid attempts.
  Please contact the seller for support: ${SUPPORT_CONTACT}"
                fi

                echo -e "  ${DIM}Please try again.${NC}"
                echo
            done
            ;;

        *)
            die "Invalid selection. Please re-run the installer and choose 1 or 2."
            ;;

    esac

}

activate_license

##############################################################################
# STEP 4 - System requirements
##############################################################################

section 4 "$TOTAL_STEPS" "Checking System Requirements"

REQUIRED_PACKAGES=()

check_req()
{
    local LABEL="$1"
    local CHECK_CMD="$2"
    shift 2
    if eval "$CHECK_CMD" >/dev/null 2>&1; then
        ok "$LABEL"
    else
        fail "$LABEL not found"
        REQUIRED_PACKAGES+=("$@")
    fi
}

check_req "git"              "command_exists git"                    "git"
check_req "python3"          "command_exists python3"                "python3"
check_req "python3-venv"     "python3 -m venv --help"                "python3-venv"
check_req "pip3"             "command_exists pip3"                   "python3-pip"
check_req "postgresql"       "command_exists psql"                   "postgresql" "postgresql-contrib"
check_req "libpq-dev"        "dpkg -s libpq-dev"                      "libpq-dev"
check_req "build-essential"  "command_exists gcc"                     "build-essential"

echo

if [ ${#REQUIRED_PACKAGES[@]} -gt 0 ]; then

    mapfile -t REQUIRED_PACKAGES < <(printf '%s\n' "${REQUIRED_PACKAGES[@]}" | awk '!seen[$0]++')

    warn "The following packages will be installed:"
    echo
    printf "     ${DIM}${BULLET} %s${NC}\n" "${REQUIRED_PACKAGES[@]}"
    echo
    info "Administrator access is required for this step."
    echo

    if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y "${REQUIRED_PACKAGES[@]}"
        echo
        ok "System packages installed"
    else
        die "Automatic package installation is only supported on Debian/Ubuntu (apt-get not found).
  Please install these manually and re-run this script:
$(printf '    - %s\n' "${REQUIRED_PACKAGES[@]}")"
    fi

else
    ok "All system requirements already satisfied"
fi

##############################################################################
# STEP 5 - Install files
##############################################################################

section 5 "$TOTAL_STEPS" "Installing ${PRODUCT_NAME}"

rm -rf "$INSTALL_HOME"
mkdir -p "$INSTALL_HOME"

cp -r "$TMP_DIR/extracted/bin" "$INSTALL_HOME/bin"
cp -r "$TMP_DIR/extracted/lib" "$INSTALL_HOME/lib"

[ -d "$TMP_DIR/extracted/completion" ] && cp -r "$TMP_DIR/extracted/completion" "$INSTALL_HOME/completion"

chmod +x "$INSTALL_HOME/bin/odoo-manager"
find "$INSTALL_HOME/lib" -type f -name "*.sh" -exec chmod +x {} \;

ok "Program files installed"
kv "Location" "$INSTALL_HOME"

mkdir -p "$INSTALL_DIR"

cat > "$INSTALL_DIR/$BINARY_NAME" <<EOF
#!/bin/bash
export ODOO_MANAGER_HOME="$INSTALL_HOME"
exec "$INSTALL_HOME/bin/odoo-manager" "\$@"
EOF

chmod +x "$INSTALL_DIR/$BINARY_NAME"

ok "Launcher installed"
kv "Command" "$INSTALL_DIR/$BINARY_NAME"

##############################################################################
# STEP 6 - Shell configuration (PATH + completion)
##############################################################################

section 6 "$TOTAL_STEPS" "Configuring Your Shell"

PATH_UPDATED=0

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then

    if [ -f "$HOME/.bashrc" ] && ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
        { echo; echo "# ${PRODUCT_NAME}"; echo 'export PATH="$HOME/.local/bin:$PATH"'; } >> "$HOME/.bashrc"
        PATH_UPDATED=1
    fi

    if [ -f "$HOME/.zshrc" ] && ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"; then
        { echo; echo "# ${PRODUCT_NAME}"; echo 'export PATH="$HOME/.local/bin:$PATH"'; } >> "$HOME/.zshrc"
        PATH_UPDATED=1
    fi

    if [ "$PATH_UPDATED" -eq 1 ]; then
        ok "Added ~/.local/bin to PATH"
    else
        warn "~/.local/bin not in PATH, and no shell rc file found to update automatically"
    fi

else
    ok "~/.local/bin already in PATH"
fi

COMPLETION_UPDATED=0

if [ -f "$INSTALL_HOME/completion/completion.bash" ] && [ -f "$HOME/.bashrc" ] \
    && ! grep -q 'odoo-manager/completion/completion.bash' "$HOME/.bashrc"; then
    { echo; echo "# ${PRODUCT_NAME} - bash tab-completion"; echo "[ -f \"$INSTALL_HOME/completion/completion.bash\" ] && source \"$INSTALL_HOME/completion/completion.bash\""; } >> "$HOME/.bashrc"
    COMPLETION_UPDATED=1
fi

if [ -f "$INSTALL_HOME/completion/completion.zsh" ] && [ -f "$HOME/.zshrc" ] \
    && ! grep -q 'odoo-manager/completion' "$HOME/.zshrc"; then
    { echo; echo "# ${PRODUCT_NAME} - zsh tab-completion"; echo "fpath+=(\"$INSTALL_HOME/completion\")"; echo 'autoload -Uz compinit && compinit'; } >> "$HOME/.zshrc"
    COMPLETION_UPDATED=1
fi

if [ "$COMPLETION_UPDATED" -eq 1 ]; then
    ok "Tab-completion configured (bash + zsh)"
else
    warn "No shell rc file found, or completion already configured"
fi

cat > "$INSTALL_HOME/uninstall.sh" <<'UNINSTALL_EOF'
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
UNINSTALL_EOF

chmod +x "$INSTALL_HOME/uninstall.sh"

ok "Uninstaller saved"

##############################################################################
# STEP 7 - Done
##############################################################################

section 7 "$TOTAL_STEPS" "Finishing Up"
ok "Installation complete"

echo
box_header "Installation Successful" "${PRODUCT_NAME} v${PRODUCT_VERSION}"

echo -e "  ${WHITE}${BOLD}Summary${NC}"
hr
kv "Command"     "odoo-manager"
kv "Installed to" "$INSTALL_HOME"
kv "Uninstall"    "$INSTALL_HOME/uninstall.sh"
kv "Support"      "$SUPPORT_CONTACT"
echo
hr
echo
echo -e "  ${WHITE}${BOLD}Next Steps${NC}"
echo -e "    ${BULLET} Restart your terminal (or it will reload automatically below)"
echo -e "    ${BULLET} Run ${CYAN}odoo-manager${NC} to start the setup wizard"
echo -e "    ${BULLET} Run ${CYAN}odoo-manager --help${NC} for CLI / scripting usage"
echo
hr
echo
echo -e "  ${GREEN}${BOLD}Thank you for choosing ${PRODUCT_NAME}!${NC}"
echo

if [ -t 0 ] && [ -t 1 ]; then

    echo -e "  ${CYAN}${ARROW}${NC} Reloading your shell so ${BOLD}odoo-manager${NC} works right away..."
    echo

    export PATH="$HOME/.local/bin:$PATH"
    exec "${SHELL:-/bin/bash}" -l

else

    echo -e "  ${WHITE}Run:${NC}"
    echo
    echo -e "      ${CYAN}source ~/.bashrc${NC}"
    echo
    echo -e "  ${DIM}or restart the terminal.${NC}"
    echo

fi
