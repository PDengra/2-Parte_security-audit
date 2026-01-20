#!/usr/bin/env bash
# ==========================================================
# FS-002 - /etc/passwd permissions
# ==========================================================

CHECK_ID="FS-002"
CHECK_NAME="/etc/passwd permissions properly configured"
CHECK_CATEGORY="Filesystem"
CHECK_SEVERITY="HIGH"
CHECK_PROFILES=("server" "workstation" "hardened")

run_check() {
    local perms owner

    perms=$(stat -c "%a" /etc/passwd)
    owner=$(stat -c "%U" /etc/passwd)

    if [[ "$perms" -le 644 && "$owner" == "root" ]]; then
        check_pass "/etc/passwd permissions are secure (${owner} ${perms})"
    else
        check_fail \
            "Permissions: ${owner} ${perms}" \
            "Set owner to root and permissions to 644 or stricter"
    fi
}
