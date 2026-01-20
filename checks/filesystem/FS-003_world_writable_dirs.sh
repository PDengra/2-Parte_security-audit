#!/usr/bin/env bash
# ==========================================================
# FS-003 - World writable directories
# ==========================================================

CHECK_ID="FS-003"
CHECK_NAME="No unsafe world-writable directories"
CHECK_CATEGORY="Filesystem"
CHECK_SEVERITY="HIGH"
CHECK_PROFILES=("server" "hardened")

EXCLUDE_DIRS=("/proc" "/sys" "/dev" "/run")

run_check() {
    local dirs

    dirs=$(find / -xdev -type d -perm -0002 2>/dev/null | grep -Ev "$(join_by '|' "${EXCLUDE_DIRS[@]}")")

    if [[ -z "$dirs" ]]; then
        check_pass "No unsafe world-writable directories found"
    else
        check_fail \
            "World-writable dirs: $(echo "$dirs" | tr '\n' ' ')" \
            "Review and remove world-writable permissions where not required"
    fi
}

