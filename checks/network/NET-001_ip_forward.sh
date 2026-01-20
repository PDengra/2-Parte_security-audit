#!/usr/bin/env bash
# ==========================================================
# NET-001 - IP forwarding disabled
# ==========================================================

CHECK_ID="NET-001"
CHECK_NAME="IP forwarding disabled"
CHECK_CATEGORY="Network"
CHECK_SEVERITY="HIGH"
CHECK_PROFILES=("server" "hardened")

run_check() {
    local value
    value=$(sysctl -n net.ipv4.ip_forward 2>/dev/null || echo "unknown")

    if [[ "$value" == "0" ]]; then
        check_pass "IP forwarding is disabled"
    else
        check_fail \
            "net.ipv4.ip_forward=${value}" \
            "Set net.ipv4.ip_forward=0 in /etc/sysctl.conf"
    fi
}

