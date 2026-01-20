#!/usr/bin/env bash
# ==========================================================
# SRV-001 - Listening network services
# ==========================================================

CHECK_ID="SRV-001"
CHECK_NAME="Review listening network services"
CHECK_CATEGORY="Services"
CHECK_SEVERITY="MEDIUM"
CHECK_PROFILES=("server" "hardened")

run_check() {
    local output

    if command_exists ss; then
        output=$(ss -tulnp 2>/dev/null | tail -n +2)
    elif command_exists netstat; then
        output=$(netstat -tulnp 2>/dev/null | tail -n +3)
    else
        check_warn \
            "No tool available to list listening services" \
            "Install ss or netstat to audit network services"
        return
    fi

    if [[ -z "$output" ]]; then
        check_pass "No listening network services detected"
    else
        check_warn \
            "Listening services detected" \
            "Review exposed services and disable unnecessary ones"
    fi
}
