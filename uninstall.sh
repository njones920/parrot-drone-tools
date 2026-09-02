#!/bin/bash
set -Eeuo pipefail

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=lib/common.sh
. "$ROOT_DIR/lib/common.sh"

require_root
require_parrot_7

info "Removing Drone & UAV launchers"
for source in "$ROOT_DIR"/menu/desktop-files/*.desktop; do
    name=$(basename "$source")
    rm -f "/usr/share/applications/$name"
    rm -f "/usr/share/parrot-menu/applications/$name"
done
for source in "$ROOT_DIR"/menu/desktop-directories/*.directory; do
    rm -f "/usr/share/desktop-directories/$(basename "$source")"
done

if grep -Fq "$MENU_MARKER" "$MENU_FILE"; then
    patch --dry-run --reverse --forward "$MENU_FILE" \
        "$ROOT_DIR/menu/parrot-applications.menu.patch" >/dev/null ||
        die "the menu changed after installation; refusing to overwrite it"
    patch --reverse --forward "$MENU_FILE" \
        "$ROOT_DIR/menu/parrot-applications.menu.patch" ||
        die "could not remove the menu entry safely"
fi
rm -f "$MENU_BACKUP"

if command -v update-desktop-database >/dev/null; then
    update-desktop-database /usr/share/applications
fi

if dpkg-query -W -f='${db:Status-Abbrev}' parrot-tools-drone 2>/dev/null | grep -q '^ii '; then
    apt-get remove -y parrot-tools-drone
fi

info "Menu integration and metapackage removed; installed tools were retained"
