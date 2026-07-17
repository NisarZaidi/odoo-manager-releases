#!/bin/bash

##############################################################################
# license.sh
#
# Supabase-backed license verification with tier-based feature gating.
#
# License flow:
#   1. User enters license key (format: ODM-FREE-XXXX-XXXX or ODM-PRO-XXXX-XXXX)
#   2. Key is hashed (sha256) locally
#   3. Hash is sent to Supabase via RPC to verify + update stats
#   4. Tier info (free/pro/enterprise) is cached locally
#   5. Feature gating checks cached tier at runtime
#
# Offline: uses last cached tier (grace period).
# New users without internet: cannot register (needs Supabase).
#
# SAFE to ship publicly — contains only anon key (public by design).
# Service role key is in .env.local (git-ignored, seller-only).
##############################################################################

# ---------------------------------------------------------------------------
# Supabase Configuration
# ---------------------------------------------------------------------------
SUPABASE_URL="https://udrcsozqoisomoejnmam.supabase.co"
SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkcmNzb3pxb2lzb21vZWpubWFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQyMDEwMDAsImV4cCI6MjA5OTc3NzAwMH0.2gsTm8rJZa7Pf5UnqJre3IL9NSCCkaRrzYEhRCLgC3s"

# Local paths
LICENSE_DIR="${HOME}/.local/share/odoo-manager"
LICENSE_FILE="${HOME}/.odoo-manager-license"
TIER_CACHE="${LICENSE_DIR}/license_tier"
KEY_CACHE="${LICENSE_DIR}/license_hash"

# ---------------------------------------------------------------------------
# Free tier limits
# ---------------------------------------------------------------------------
FREE_LIMIT=100

# Pro-only features (checked by feature_gate function)
PRO_FEATURES="scaffold deps quality batch migration dbcompare multitest watcher remote"

##############################################################################
# Internal Helpers
##############################################################################

_load_supabase_env()
{
    # Try loading service role key from env or .env.local
    if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
        local ENV_FILE
        for ENV_FILE in \
            "${SUPABASE_ENV_FILE:-}" \
            "${ODOO_MANAGER_HOME:-}/supabase/.env.local" \
            "${HOME}/.config/odoo-manager/.env.local"
        do
            if [ -f "$ENV_FILE" ]; then
                # shellcheck source=/dev/null
                source "$ENV_FILE"
                break
            fi
        done
    fi
}

_ensure_dirs()
{
    mkdir -p "$LICENSE_DIR" 2>/dev/null
}

##############################################################################
# Tier Cache
##############################################################################

save_tier_cache()
{
    local TIER="$1"
    local EMAIL="$2"
    local NAME="$3"

    _ensure_dirs
    echo "$TIER" > "$TIER_CACHE" 2>/dev/null
    echo "${EMAIL}|${NAME}" > "${LICENSE_DIR}/license_info" 2>/dev/null
}

get_cached_tier()
{
    if [ -f "$TIER_CACHE" ]; then
        cat "$TIER_CACHE" 2>/dev/null
        return 0
    fi
    return 1
}

##############################################################################
# Key Hashing
##############################################################################

hash_license_key()
{
    local KEY="$1"
    [ -n "$KEY" ] || return 1
    echo -n "$KEY" | openssl dgst -sha256 -hex 2>/dev/null | awk '{print $NF}'
}

##############################################################################
# Supabase API Calls
##############################################################################

# Verify license key via RPC
supabase_verify()
{
    local KEY_HASH="$1"

    [ -n "$KEY_HASH" ] || return 1
    command_exists curl || return 1

    local BODY="{\"p_key_hash\": \"${KEY_HASH}\"}"

    local RESPONSE
    RESPONSE=$(curl -s --connect-timeout 5 --max-time 10 \
        "${SUPABASE_URL}/rest/v1/rpc/verify_and_update" \
        -H "apikey: ${SUPABASE_ANON_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_ANON_KEY}" \
        -H "Content-Type: application/json" \
        -d "$BODY" 2>/dev/null)

    if [ -z "$RESPONSE" ]; then
        return 1
    fi

    echo "$RESPONSE"
}

# Register a free license via RPC
supabase_register_free()
{
    local EMAIL="$1"
    local NAME="$2"
    local LICENSE_KEY="$3"
    local KEY_HASH="$4"

    command_exists curl || return 1

    local BODY="{\"p_email\": \"${EMAIL}\", \"p_name\": \"${NAME}\", \"p_license_key\": \"${LICENSE_KEY}\", \"p_key_hash\": \"${KEY_HASH}\"}"

    local RESPONSE
    RESPONSE=$(curl -s --connect-timeout 5 --max-time 10 \
        "${SUPABASE_URL}/rest/v1/rpc/register_free_license" \
        -H "apikey: ${SUPABASE_ANON_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_ANON_KEY}" \
        -H "Content-Type: application/json" \
        -d "$BODY" 2>/dev/null)

    if [ -z "$RESPONSE" ]; then
        return 1
    fi

    echo "$RESPONSE"
}

# Check free tier count (admin only)
supabase_get_counts()
{
    _load_supabase_env

    if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
        echo "Error: SUPABASE_SERVICE_ROLE_KEY not set." >&2
        return 1
    fi

    curl -s \
        "${SUPABASE_URL}/rest/v1/rpc/get_tier_counts" \
        -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
        -H "Content-Type: application/json" \
        -d '{}' 2>/dev/null
}

# Admin: issue paid license
supabase_issue_paid()
{
    local EMAIL="$1"
    local NAME="$2"
    local LICENSE_KEY="$3"
    local KEY_HASH="$4"
    local TIER="$5"
    local NOTES="${6:-}"

    _load_supabase_env

    if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
        echo "Error: SUPABASE_SERVICE_ROLE_KEY not set." >&2
        return 1
    fi

    local BODY="{\"p_email\": \"${EMAIL}\", \"p_name\": \"${NAME}\", \"p_license_key\": \"${LICENSE_KEY}\", \"p_key_hash\": \"${KEY_HASH}\", \"p_tier\": \"${TIER}\", \"p_notes\": \"${NOTES}\"}"

    curl -s \
        "${SUPABASE_URL}/rest/v1/rpc/issue_paid_license" \
        -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
        -H "Content-Type: application/json" \
        -d "$BODY" 2>/dev/null
}

# Admin: revoke license
supabase_revoke()
{
    local EMAIL="$1"

    _load_supabase_env

    if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
        echo "Error: SUPABASE_SERVICE_ROLE_KEY not set." >&2
        return 1
    fi

    curl -s \
        "${SUPABASE_URL}/rest/v1/rpc/revoke_license" \
        -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
        -H "Content-Type: application/json" \
        -d "{\"p_email\": \"${EMAIL}\"}" 2>/dev/null
}

# Admin: upgrade tier
supabase_upgrade()
{
    local EMAIL="$1"
    local NEW_TIER="$2"

    _load_supabase_env

    if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
        echo "Error: SUPABASE_SERVICE_ROLE_KEY not set." >&2
        return 1
    fi

    curl -s \
        "${SUPABASE_URL}/rest/v1/rpc/upgrade_tier" \
        -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
        -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
        -H "Content-Type: application/json" \
        -d "{\"p_email\": \"${EMAIL}\", \"p_new_tier\": \"${NEW_TIER}\"}" 2>/dev/null
}

##############################################################################
# PUBLIC FUNCTIONS (used by bin/odoo-manager, install.sh, project.sh)
##############################################################################

# ---------------------------------------------------------------------------
# validate_license_key <key>
#
# Verifies key against Supabase. Prints tier on success, returns 0.
# On failure or offline, tries cached tier, returns 0 if cached.
# ---------------------------------------------------------------------------
validate_license_key()
{
    local KEY="$1"

    [ -n "$KEY" ] || return 1

    local KEY_HASH
    KEY_HASH=$(hash_license_key "$KEY")
    [ -n "$KEY_HASH" ] || return 1

    # Save key hash for future offline use
    _ensure_dirs
    echo "$KEY_HASH" > "$KEY_CACHE" 2>/dev/null

    # Try Supabase verification
    local RESPONSE
    RESPONSE=$(supabase_verify "$KEY_HASH" 2>/dev/null)

    if [ -n "$RESPONSE" ] && command_exists jq; then

        local VALID
        VALID=$(echo "$RESPONSE" | jq -r '.valid // false' 2>/dev/null)

        if [ "$VALID" = "true" ]; then
            local TIER EMAIL NAME
            TIER=$(echo "$RESPONSE" | jq -r '.tier // "free"' 2>/dev/null)
            EMAIL=$(echo "$RESPONSE" | jq -r '.email // "unknown"' 2>/dev/null)
            NAME=$(echo "$RESPONSE" | jq -r '.name // "unknown"' 2>/dev/null)

            save_tier_cache "$TIER" "$EMAIL" "$NAME"
            echo "$TIER"
            return 0
        fi
    fi

    # Supabase unreachable or jq missing — use cached tier
    local CACHED
    CACHED=$(get_cached_tier 2>/dev/null)

    if [ -n "$CACHED" ]; then
        echo "${CACHED}:offline"
        return 0
    fi

    return 1
}

# ---------------------------------------------------------------------------
# get_user_tier
#
# Returns current user's tier: free, pro, enterprise
# ---------------------------------------------------------------------------
get_user_tier()
{
    get_cached_tier 2>/dev/null || echo "none"
}

# ---------------------------------------------------------------------------
# is_pro_feature <feature_name>
#
# Returns 0 if the feature requires pro tier, 1 if it's free.
# ---------------------------------------------------------------------------
is_pro_feature()
{
    local FEATURE="$1"

    case "$FEATURE" in
        scaffold|deps|quality|batch|migration|dbcompare|multitest|watcher|remote)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# ---------------------------------------------------------------------------
# check_feature_access <feature_name>
#
# Returns 0 if user can access this feature, 1 if blocked.
# Prints a message if blocked.
# ---------------------------------------------------------------------------
check_feature_access()
{
    local FEATURE="$1"

    # Free features always accessible
    if ! is_pro_feature "$FEATURE"; then
        return 0
    fi

    # Pro features: check tier
    local TIER
    TIER=$(get_cached_tier 2>/dev/null)

    case "$TIER" in
        pro|enterprise)
            return 0
            ;;
        free)
            echo
            echo -e "  \033[1;33m⚠ This is a Pro feature.\033[0m"
            echo -e "  Your current tier: \033[1mfree\033[0m"
            echo
            echo "  Upgrade to Pro to unlock:"
            echo "    • Advanced Module Scaffold"
            echo "    • Module Dependency Graph"
            echo "    • Module Quality Checker"
            echo "    • Batch Operations"
            echo "    • DB Migration Helper"
            echo "    • DB Snapshot & Compare"
            echo "    • Multi-Database Testing"
            echo "    • Hot Reload"
            echo "    • Remote Server Management"
            echo
            echo -e "  Contact: \033[1mnisarzaidi75@gmail.com\033[0m for upgrade."
            echo
            return 1
            ;;
        *)
            echo
            echo -e "  \033[1;31mNo valid license found.\033[0m"
            echo -e "  Please register or enter a license key first."
            echo
            return 1
            ;;
    esac
}

# ---------------------------------------------------------------------------
# register_free_tier
#
# Interactive free tier registration. Returns 0 on success.
# Used by install.sh during first-run setup.
# ---------------------------------------------------------------------------
register_free_tier()
{
    echo
    echo -e "  \033[1;37mFree Tier Registration\033[0m"
    echo -e "  \033[2mFirst 100 developers get a free lifetime license.\033[0m"
    echo

    local ATTEMPTS=0
    local MAX_ATTEMPTS=3

    while :
    do
        read -r -p "  Your name: " USER_NAME
        read -r -p "  Your email: " USER_EMAIL
        echo

        if [ -z "$USER_NAME" ] || [ -z "$USER_EMAIL" ]; then
            echo -e "  \033[0;31mName and email are required.\033[0m"
            echo
            ATTEMPTS=$((ATTEMPTS + 1))
            [ "$ATTEMPTS" -ge "$MAX_ATTEMPTS" ] && return 1
            continue
        fi

        # Basic email validation
        if ! echo "$USER_EMAIL" | grep -qE '^[^@]+@[^@]+\.[^@]+$'; then
            echo -e "  \033[0;31mInvalid email format. Please try again.\033[0m"
            echo
            ATTEMPTS=$((ATTEMPTS + 1))
            [ "$ATTEMPTS" -ge "$MAX_ATTEMPTS" ] && return 1
            continue
        fi

        # Check internet
        if ! command_exists curl; then
            echo -e "  \033[0;31mcurl is required for registration.\033[0m"
            return 1
        fi

        echo -e "  \033[2mRegistering...\033[0m"

        # Generate a unique license key
        local RANDOM_SUFFIX
        RANDOM_SUFFIX=$(head -c 16 /dev/urandom 2>/dev/null | od -A n -t x1 | head -1 | awk '{print $2$3$4$5$6}' | cut -c1-8)
        [ -z "$RANDOM_SUFFIX" ] && RANDOM_SUFFIX=$(date +%s | tail -c 9)
        local LICENSE_KEY="ODM-FREE-${RANDOM_SUFFIX:0:4}-${RANDOM_SUFFIX:4:4}"

        local KEY_HASH
        KEY_HASH=$(hash_license_key "$LICENSE_KEY")

        # Call Supabase RPC
        local RESPONSE
        RESPONSE=$(supabase_register_free "$USER_EMAIL" "$USER_NAME" "$LICENSE_KEY" "$KEY_HASH" 2>/dev/null)

        if [ -z "$RESPONSE" ]; then
            echo -e "  \033[0;31mCannot reach license server. Check your internet connection.\033[0m"
            echo
            ATTEMPTS=$((ATTEMPTS + 1))
            [ "$ATTEMPTS" -ge "$MAX_ATTEMPTS" ] && return 1
            continue
        fi

        if ! command_exists jq; then
            echo -e "  \033[0;31mjq is required for registration (sudo apt install jq).\033[0m"
            return 1
        fi

        local SUCCESS ERROR
        SUCCESS=$(echo "$RESPONSE" | jq -r '.success // false' 2>/dev/null)
        ERROR=$(echo "$RESPONSE" | jq -r '.error // ""' 2>/dev/null)

        if [ "$SUCCESS" = "true" ]; then
            _ensure_dirs

            # Save license key
            echo "$LICENSE_KEY" > "$LICENSE_FILE"
            chmod 600 "$LICENSE_FILE" 2>/dev/null

            # Save hash
            echo "$KEY_HASH" > "$KEY_CACHE" 2>/dev/null

            # Cache tier
            save_tier_cache "free" "$USER_EMAIL" "$USER_NAME"

            echo
            echo -e "  \033[0;32m✔ Free license activated!\033[0m"
            echo -e "  \033[1mLicense Key:\033[0m  ${LICENSE_KEY}"
            echo -e "  \033[1mTier:\033[0m         Free (lifetime)"
            echo -e "  \033[1mRegistered:\033[0m   ${USER_NAME} (${USER_EMAIL})"
            echo
            echo -e "  \033[2mSave your license key: ${LICENSE_KEY}\033[0m"
            echo -e "  \033[2mFree tier includes workspace management, git, database, and basic tools.\033[0m"
            echo -e "  \033[2mUpgrade to Pro for advanced scaffold, quality checker, and more.\033[0m"
            echo
            return 0
        fi

        case "$ERROR" in
            free_limit_reached)
                echo
                echo -e "  \033[1;33m⚠ Free tier limit reached (100 users).\033[0m"
                echo -e "  Contact nisarzaidi75@gmail.com for a paid license."
                echo
                return 1
                ;;
            email_exists)
                echo
                echo -e "  \033[1;33m⚠ This email already has a license.\033[0m"
                echo -e "  Check your email for the license key, or use a different email."
                echo
                return 1
                ;;
            *)
                echo -e "  \033[0;31mRegistration failed. Please try again.\033[0m"
                echo
                ATTEMPTS=$((ATTEMPTS + 1))
                [ "$ATTEMPTS" -ge "$MAX_ATTEMPTS" ] && return 1
                ;;
        esac
    done
}

# ---------------------------------------------------------------------------
# show_license_status
#
# Display current license info (used by menu option 4 in dev menu).
# ---------------------------------------------------------------------------
show_license_status()
{
    local TIER EMAIL_NAME

    TIER=$(get_cached_tier 2>/dev/null)
    EMAIL_NAME=$(cat "${LICENSE_DIR}/license_info" 2>/dev/null || echo "")

    echo

    if [ -n "$TIER" ] && [ "$TIER" != "none" ]; then
        local TIER_DISPLAY="${TIER%%:*}"  # Remove :offline suffix
        local EMAIL="${EMAIL_NAME%%|*}"
        local NAME="${EMAIL_NAME##*|}"

        case "$TIER_DISPLAY" in
            free)      echo -e "  \033[1;36mLicense Tier:  FREE\033[0m" ;;
            pro)       echo -e "  \033[1;32mLicense Tier:  PRO\033[0m" ;;
            enterprise) echo -e "  \033[1;33mLicense Tier:  ENTERPRISE\033[0m" ;;
            *)         echo -e "  \033[1mLicense Tier:  ${TIER_DISPLAY}\033[0m" ;;
        esac

        [ -n "$NAME" ] && [ "$NAME" != "unknown" ] && echo "  Registered:  $NAME"
        [ -n "$EMAIL" ] && [ "$EMAIL" != "unknown" ] && echo "  Email:       $EMAIL"

        if [ -f "$LICENSE_FILE" ]; then
            echo "  License Key: $(cat "$LICENSE_FILE" 2>/dev/null)"
        fi

        if echo "$TIER" | grep -q ":offline"; then
            echo
            echo -e "  \033[1;33m⚠ Last verified offline (cached tier). Reconnect to refresh.\033[0m"
        fi
    else
        echo -e "  \033[1;31mNo license found.\033[0m"
        echo "  Run the installer or use 'odoo-manager register' to get a free license."
    fi

    echo
}
