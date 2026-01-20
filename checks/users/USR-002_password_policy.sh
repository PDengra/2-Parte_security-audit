#!/usr/bin/env bash
# ==========================================================
# USR-002 - Password policy defined
# ==========================================================

CHECK_ID="USR-002"
CHECK_NAME="Password policy is defined"
CHECK_CATEGORY="Users"
CHECK_SEVERITY="HIGH"
CHECK_PROFILES=("server" "workstation" "hardened")

run_check() {
    if grep -Eq 'pam_pwquality|pam_cracklib' /etc/pam.d/common-password 2>/dev/null; then
        check_pass "Password quality module configured"
    else
        check_fail \
            "No password quality module found in PAM configuration" \
            "Configure pam_pwquality to enforce strong passwords"
    fi
}

