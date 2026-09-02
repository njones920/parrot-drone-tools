#!/bin/bash
set -Eeuo pipefail

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=lib/common.sh
. "$ROOT_DIR/lib/common.sh"

require_root
require_parrot_7
require_amd64

command -v apt-get >/dev/null || die "apt-get is unavailable"
command -v patch >/dev/null || die "patch is unavailable"
[ -f "$MENU_FILE" ] || die "Parrot application menu not found: $MENU_FILE"

if ! grep -Fq "$MENU_MARKER" "$MENU_FILE"; then
    patch --dry-run --forward "$MENU_FILE" \
        "$ROOT_DIR/menu/parrot-applications.menu.patch" >/dev/null ||
        die "the installed Parrot menu is not compatible; no changes were made"
fi

shopt -s nullglob
metapackages=("$ROOT_DIR"/packages/parrot-tools-drone_*.deb)
pymavlink_packages=("$ROOT_DIR"/packages/python3-pymavlink_*_amd64.deb)
shopt -u nullglob

[ "${#metapackages[@]}" -eq 1 ] ||
    die "expected exactly one parrot-tools-drone package in packages/"
[ "${#pymavlink_packages[@]}" -eq 1 ] ||
    die "expected exactly one amd64 pymavlink compatibility package in packages/"

info "Verifying bundled packages"
(cd "$ROOT_DIR/packages" && sha256sum --check --strict SHA256SUMS) ||
    die "bundled package verification failed; no changes were made"

info "Refreshing Parrot package metadata"
apt-get update

info "Installing the pymavlink compatibility package and drone metapackage"
apt-get install -y "${pymavlink_packages[0]}" "${metapackages[0]}"

info "Installing Drone & UAV menu files"
install -d -m 0755 /usr/share/desktop-directories
install -d -m 0755 /usr/share/parrot-menu/applications
install -d -m 0755 /usr/share/applications
install -m 0644 "$ROOT_DIR"/menu/desktop-directories/*.directory \
    /usr/share/desktop-directories/
install -m 0644 "$ROOT_DIR"/menu/desktop-files/*.desktop \
    /usr/share/parrot-menu/applications/
install -m 0644 "$ROOT_DIR"/menu/desktop-files/*.desktop \
    /usr/share/applications/

if grep -Fq "$MENU_MARKER" "$MENU_FILE"; then
    info "Drone & UAV menu is already present"
else
    [ -e "$MENU_BACKUP" ] || cp -a "$MENU_FILE" "$MENU_BACKUP"
    patch --forward "$MENU_FILE" \
        "$ROOT_DIR/menu/parrot-applications.menu.patch" ||
        die "the installed Parrot menu is not compatible; original menu was preserved"
fi

if command -v update-desktop-database >/dev/null; then
    update-desktop-database /usr/share/applications
fi

info "Installation complete"
"$ROOT_DIR/verify.sh"
