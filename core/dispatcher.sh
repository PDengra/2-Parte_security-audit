#!/usr/bin/env bash
# ==========================================================
# Dispatcher: load and execute checks
# ==========================================================

declare -a RESULTS=()

dispatch_checks() {
    log_info "Loading checks"

    local check_file
    while IFS= read -r -d '' check_file; do
        execute_check "$check_file"
    done < <(find "${CHECKS_DIR}" -type f -name "*.sh" -print0 | sort -z)

    log_info "Executed ${#RESULTS[@]} checks"
}

execute_check() {
    local file="$1"

    # shellcheck disable=SC1090
    source "$file"

    # Validación mínima del contrato
    validate_check || return 0

    # Filtro por perfil
    check_profile_allowed || return 0

    # Filtro por categoría
    check_category_allowed || return 0

    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY-RUN: ${CHECK_ID} - ${CHECK_NAME}"
        return 0
    fi

    log_info "Running ${CHECK_ID} - ${CHECK_NAME}"
    run_check
}

validate_check() {
    local missing=false

    for var in CHECK_ID CHECK_NAME CHECK_CATEGORY CHECK_SEVERITY; do
        if [[ -z "${!var:-}" ]]; then
            log_warn "Invalid check (missing ${var})"
            missing=true
        fi
    done

    [[ "$missing" == true ]] && return 1
    return 0
}

check_profile_allowed() {
    [[ "${#CHECK_PROFILES[@]}" -eq 0 ]] && return 0
    [[ " ${CHECK_PROFILES[*]} " =~ " ${PROFILE} " ]]
}

check_category_allowed() {
    if [[ "${#ONLY_CATEGORIES[@]}" -gt 0 ]]; then
        [[ " ${ONLY_CATEGORIES[*]} " =~ " ${CHECK_CATEGORY} " ]] || return 1
    fi

    if [[ "${#EXCLUDE_CATEGORIES[@]}" -gt 0 ]]; then
        [[ " ${EXCLUDE_CATEGORIES[*]} " =~ " ${CHECK_CATEGORY} " ]] && return 1
    fi

    return 0
}

