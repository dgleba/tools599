







this stupid gpt junk doesnt work.











#!/bin/bash
set -euo pipefail

# --- Configuration ---
RULE_SPEC="-p tcp --dport 22 -j REJECT"
TTL_SECONDS=100
IPT_LEGACY="/usr/sbin/iptables-legacy"
IPT="/usr/sbin/iptables"
AT="/usr/bin/at"
ATQ="/usr/bin/atq"

FP_HASH="$(echo "$RULE_SPEC" | sha256sum | awk '{print $1}')"
FINGERPRINT="/run/tmpfw-${FP_HASH}.rule"

log() {
    printf '%s %s\n' "$(date -Is)" "$*" >&2
}

# --- Refuse to run if nftables backend is active ---
ensure_legacy_backend() {
    if [[ ! -x "$IPT_LEGACY" ]]; then
        log "ERROR: iptables-legacy not found."
        exit 1
    fi

    # iptables must resolve to iptables-legacy
    if [[ "$(readlink -f "$IPT")" != "$(readlink -f "$IPT_LEGACY")" ]]; then
        log "ERROR: nftables backend detected (iptables != iptables-legacy). Refusing to run."
        exit 1
    fi
}

# --- Add rule if missing ---
add_rule() {
    if "$IPT_LEGACY" -C INPUT $RULE_SPEC 2>/dev/null; then
        log "Rule already exists; not adding again."
    else
        log "Adding temporary firewall rule: $RULE_SPEC"
        "$IPT_LEGACY" -A INPUT $RULE_SPEC
    fi
}

# --- Create fingerprint file ---
create_fingerprint() {
    if [[ ! -f "$FINGERPRINT" ]]; then
        log "Creating fingerprint file: $FINGERPRINT"
        printf '%s\n' "$RULE_SPEC" > "$FINGERPRINT"
    else
        log "Fingerprint already exists."
    fi
}

# --- Schedule removal using at(1) ---
schedule_removal() {
    # Check if a job already exists
    if $ATQ | grep -q "$FINGERPRINT"; then
        log "Removal already scheduled; not adding duplicate at job."
        return
    fi

    TTL_MINUTES=$((TTL_SECONDS / 60))
    log "Scheduling removal in $TTL_MINUTES minutes."

    $AT now + $TTL_MINUTES minutes <<EOF
#!/bin/bash
set -euo pipefail

RULE_SPEC="\$(cat "$FINGERPRINT")"
IPT_LEGACY="/usr/sbin/iptables-legacy"

if \$IPT_LEGACY -C INPUT \$RULE_SPEC 2>/dev/null; then
    echo "\$(date -Is) Removing temporary firewall rule: \$RULE_SPEC" >&2
    \$IPT_LEGACY -D INPUT \$RULE_SPEC
else
    echo "\$(date -Is) Rule already absent; nothing to remove." >&2
fi

rm -f "$FINGERPRINT"
EOF
}

# --- Main ---
ensure_legacy_backend
add_rule
create_fingerprint
schedule_removal

