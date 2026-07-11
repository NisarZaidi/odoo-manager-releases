#!/bin/bash

##############################################################################
# license.sh
# RSA license verification. SAFE to ship publicly - contains only the
# PUBLIC key, which can verify signatures but cannot create new ones.
##############################################################################

# Paste the contents of keys/public.pem here (replace the placeholder
# below) before shipping install.sh to the public releases repo.
# Run: cat keys/public.pem
read -r -d '' LICENSE_PUBLIC_KEY <<'PUBKEY' || true
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnFcbP/44/w0Xey+6Yt54
UDO9HhPlFPwxyxrTKtSWh0DlwJZD9iuys0XIdDxrBw6yWNAeyWTQIZjAZpa5mt1v
hf4LeBGYdWOu7FEjLdfPJUGs2u3WJKPz/isr97KKx3Mq0KeE2nNmsLNK8VaU2F5g
ziSFQrjPPlfedgm2CcrcVC06jZhy7XrsKU/ReY3p/YRlmzqEFCuqZpkTjX9beV8u
KhQkVtm8/+/BRA5iteCpgZoBusAU8dd0VFFixkm8Uhnx/uGtMwhD+XNOOOws7ybQ
NnRcgLWfKyY2+X32Ux/Seu9tN2MTciR3t7NxprcrX3PZq77m/ri4BaPd9Sv2r3RY
awIDAQAB
-----END PUBLIC KEY-----
PUBKEY

b64url_decode()
{
    local INPUT="$1"
    # restore standard base64 alphabet + padding
    INPUT="${INPUT//-/+}"
    INPUT="${INPUT//_/\/}"

    local MOD=$(( ${#INPUT} % 4 ))
    if [ "$MOD" -eq 2 ]; then INPUT="${INPUT}=="
    elif [ "$MOD" -eq 3 ]; then INPUT="${INPUT}="
    fi

    echo -n "$INPUT" | openssl base64 -A -d 2>/dev/null
}

##############################################################################
# validate_license_key <key>
# Returns 0 + prints the decoded customer id, or returns 1 on failure.
##############################################################################

validate_license_key()
{

    local KEY="$1"

    [ -n "$KEY" ] || return 1

    case "$KEY" in
        *.*) : ;;
        *) return 1 ;;
    esac

    local ID_PART="${KEY%%.*}"
    local SIG_PART="${KEY#*.}"

    [ -n "$ID_PART" ] && [ -n "$SIG_PART" ] || return 1

    local CUSTOMER_ID
    CUSTOMER_ID=$(b64url_decode "$ID_PART")

    [ -n "$CUSTOMER_ID" ] || return 1

    local TMP_SIG
    TMP_SIG=$(mktemp)
    local TMP_PUB
    TMP_PUB=$(mktemp)

    b64url_decode "$SIG_PART" > "$TMP_SIG"
    printf '%s' "$LICENSE_PUBLIC_KEY" > "$TMP_PUB"

    local RESULT=1

    if printf '%s' "$CUSTOMER_ID" \
        | openssl dgst -sha256 -verify "$TMP_PUB" -signature "$TMP_SIG" >/dev/null 2>&1
    then
        RESULT=0
        echo "$CUSTOMER_ID"
    fi

    rm -f "$TMP_SIG" "$TMP_PUB"

    return "$RESULT"

}
