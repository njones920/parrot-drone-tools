#!/bin/bash

PROJECT_NAME="Parrot Drone Tools"
MENU_FILE="/etc/xdg/menus/applications-merged/parrot-applications.menu"
MENU_BACKUP="${MENU_FILE}.pre-parrot-drone-tools"
MENU_MARKER='<Name>Drone &amp; UAV</Name>'

die() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

info() {
    printf '==> %s\n' "$*"
}

require_root() {
    [ "$(id -u)" -eq 0 ] || die "run this command with sudo"
}

require_parrot_7() {
    [ -r /etc/os-release ] || die "cannot identify the operating system"
    # shellcheck disable=SC1091
    . /etc/os-release
    [ "${ID:-}" = "parrot" ] || die "this installer supports Parrot OS only"
    case "${VERSION_ID:-}" in
        7|7.*) ;;
        *) die "unsupported Parrot release: ${VERSION_ID:-unknown} (expected 7.x)" ;;
    esac
}

require_amd64() {
    [ "$(dpkg --print-architecture)" = "amd64" ] ||
        die "this release supports amd64 only; no changes were made"
}
