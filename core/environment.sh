#!/usr/bin/env bash
# ==========================================================
# Environment detection
# ==========================================================

OS_NAME="unknown"
OS_VERSION="unknown"
KERNEL_VERSION="unknown"
VIRTUALIZED=false
HOSTNAME="$(hostname)"

detect_environment() {
    detect_os
    detect_kernel
    detect_virtualization

    log_info "Detected OS: ${OS_NAME} ${OS_VERSION}"
    log_info "Kernel: ${KERNEL_VERSION}"
    log_info "Virtualized: ${VIRTUALIZED}"
}

detect_os() {
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        OS_NAME="${NAME}"
        OS_VERSION="${VERSION_ID}"
    fi
}

detect_kernel() {
    KERNEL_VERSION="$(uname -r)"
}

detect_virtualization() {
    if command_exists systemd-detect-virt; then
        if systemd-detect-virt --quiet; then
            VIRTUALIZED=true
        fi
    else
        # fallback heurístico
        grep -qi hypervisor /proc/cpuinfo && VIRTUALIZED=true
    fi
}

export OS_NAME OS_VERSION KERNEL_VERSION VIRTUALIZED HOSTNAME

