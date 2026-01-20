#!/usr/bin/env bash
# ==========================================================
# FS-004 - SUID/SGID binaries
# ==========================================================

CHECK_ID="FS-004"
CHECK_NAME="SUID/SGID binaries review"
CHECK_CATEGORY="Filesystem"
CHECK_SEVERITY="MEDIUM"
CHECK_PROFILES=("server" "hardened")

run_check() {
    local files

    files=$(find / -xdev \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null)

    if [[ -z "$files" ]]; then
        check_pass "No SUID/SGID binaries found"
    else
        check_warn \
            "SUID/SGID files found: $(echo "$files" | wc -l)" \
            "Review SUID/SGID binaries and remove where not strictly necessary"
    fi
}
