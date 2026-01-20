#!/usr/bin/env bash
# ==========================================================
# SSH-001 - Secure SSH configuration
# ==========================================================

CHECK_ID="SSH-001"
CHECK_NAME="SSH hardened configuration"
CHECK_CATEGORY="SSH"
CHECK_SEVERITY="HIGH"
CHECK_PROFILES=("server" "hardened")

SSHD_CONFIG="/etc/ssh/sshd_config"

run_check() {
    [[ ! -f "$SSHD_CONFIG" ]] && {
        check_warn "sshd_config not found" "Verify SSH installation"
        return
    }

    local issues=()

    grep -Eq '^PermitRootLogin\s+no' "$SSHD_CONFIG" || issues+=("PermitRootLogin not disabled")
    grep -Eq '^PasswordAuthentication\s+no' "$SSHD_CONFIG" || issues+=("PasswordAuthentication enabled")

    if [[ "${#issues[@]}" -eq 0 ]]; then
        check_pass "SSH configuration hardened"
    else
        check_fail \
            "$(join_by '; ' "${issues[@]}")" \
            "Disable root login and password authentication in sshd_config"
    fi
}

