#!/bin/bash
set -uo pipefail

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=lib/common.sh
. "$ROOT_DIR/lib/common.sh"

failures=0

pass() { printf 'PASS  %s\n' "$*"; }
fail() { printf 'FAIL  %s\n' "$*"; failures=$((failures + 1)); }
skip() { printf 'SKIP  %s\n' "$*"; }

if dpkg-query -W -f='${db:Status-Abbrev}' parrot-tools-drone 2>/dev/null | grep -q '^ii '; then
    version=$(dpkg-query -W -f='${Version}' parrot-tools-drone)
    pass "parrot-tools-drone $version"
else
    fail "parrot-tools-drone is not installed"
fi

if python3 -c 'import pymavlink' >/dev/null 2>&1; then
    version=$(python3 -c 'import pymavlink; print(pymavlink.__version__)' 2>/dev/null || printf unknown)
    pass "pymavlink $version"
else
    fail "pymavlink does not import"
fi

directory_count=0
for source in "$ROOT_DIR"/menu/desktop-directories/*.directory; do
    target="/usr/share/desktop-directories/$(basename "$source")"
    if [ -f "$target" ]; then directory_count=$((directory_count + 1)); fi
done
[ "$directory_count" -eq 7 ] && pass "7 menu categories" ||
    fail "$directory_count of 7 menu categories installed"

launcher_count=0
mirror_count=0
for source in "$ROOT_DIR"/menu/desktop-files/*.desktop; do
    name=$(basename "$source")
    [ -f "/usr/share/applications/$name" ] && launcher_count=$((launcher_count + 1))
    [ -f "/usr/share/parrot-menu/applications/$name" ] && mirror_count=$((mirror_count + 1))
done
[ "$launcher_count" -eq 23 ] && pass "23 application launchers" ||
    fail "$launcher_count of 23 application launchers installed"
[ "$mirror_count" -eq 23 ] && pass "23 launchers protected from update-launchers" ||
    fail "$mirror_count of 23 launchers staged for parrot-menu"

if [ -f "$MENU_FILE" ] && [ "$(grep -Fc "$MENU_MARKER" "$MENU_FILE")" -eq 1 ]; then
    pass "Drone & UAV menu registered once"
else
    fail "Drone & UAV menu registration"
fi

command -v dvd-parrot >/dev/null && skip "Damn Vulnerable Drone is separately installed" ||
    skip "Damn Vulnerable Drone is optional"

if [ "$failures" -eq 0 ]; then
    printf '\nVerification passed.\n'
    exit 0
fi

printf '\nVerification failed: %d check(s).\n' "$failures" >&2
exit 1
