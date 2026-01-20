#!/usr/bin/env bash
# ==========================================================
# SRV-002 - Firewall enabled
# ==========================================================

CHECK_ID="SRV-002"
CHECK_NAME="Firewall is enabled"
CHECK_CATEGORY="Services"
CHECK_SEVERITY="HIGH"
CHECK_PROFILES=("server" "hardened")

run_check() {
    if command_exists nft; then
        if nft list ruleset 2>/dev/null | grep -q 'chain'; then
            check_pass "nftables firewall is active"
            return
        fi
    fi

    if command_exists iptables; then
        if iptables -L -n 2>/dev/null | grep -q 'Chain'; then
            check_pass "iptables firewall is active"
            return
        fi
    fi

    if command_exists ufw; then
        if ufw status 2>/dev/null | grep -q "Status: active"; then
            check_pass "UFW firewall is active"
            return
        fi
    fi

    check_fail \
        "No active firewall detected" \
        "Enable and configure a firewall (nftables, iptables or ufw)"
}
