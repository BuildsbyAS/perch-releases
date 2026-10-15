#!/bin/sh
# Installs or updates Perch: https://github.com/BuildsbyAS/perch-releases
#
#   curl -fsSL https://raw.githubusercontent.com/BuildsbyAS/perch-releases/main/install.sh | sh
#
# Downloads the latest build named in Perch's update feed, checks it's signed
# with Perch's certificate, puts it in /Applications and opens it. Later
# updates arrive inside the app.
set -eu

FEED="https://github.com/BuildsbyAS/perch-releases/releases/latest/download/appcast.xml"
# The certificate every Perch build is signed with. An app signed by anyone
# else is refused.
CERT_SHA1="9ae3a2d2b18dedff5c11c1d0d974c6390a5b01f4"
DEST="${PERCH_INSTALL_DIR:-/Applications}"

say() { printf '%s\n' "$*"; }
fail() { printf 'Perch: %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || fail "Perch is a Mac app."
[ "$(uname -m)" = "arm64" ] || fail "Perch needs an Apple Silicon Mac."
major=$(sw_vers -productVersion | cut -d. -f1)
[ "$major" -ge 14 ] || fail "Perch needs macOS 14 or later."

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

say "Finding the latest Perch…"
curl -fsSL "$FEED" -o "$TMP/appcast.xml" || fail "couldn't reach the update feed."
url=$(sed -n 's/.*<enclosure url="\([^"]*\)".*/\1/p' "$TMP/appcast.xml" | head -n 1)
version=$(sed -n 's/.*<sparkle:shortVersionString>\([^<]*\)<.*/\1/p' "$TMP/appcast.xml" | head -n 1)
case "$url" in
    https://github.com/BuildsbyAS/perch-releases/releases/download/*) ;;
    *) fail "the update feed points somewhere unexpected." ;;
esac

say "Downloading Perch ${version}…"
curl -fL# "$url" -o "$TMP/Perch.zip" || fail "download failed."
ditto -x -k "$TMP/Perch.zip" "$TMP/unzipped" || fail "couldn't unpack the download."
APP="$TMP/unzipped/Perch.app"
[ -d "$APP" ] || fail "the download doesn't contain Perch.app."

codesign --verify --deep --strict "$APP" 2>/dev/null || fail "the app's signature is broken; not installing."
codesign -d -r- "$APP" 2>&1 | grep -qi "certificate root = H\"$CERT_SHA1\"" \
    || fail "the app isn't signed with Perch's certificate; not installing."

if pgrep -x Perch >/dev/null 2>&1 && [ -z "${PERCH_INSTALL_DIR:-}" ]; then
    say "Quitting the running Perch…"
    osascript -e 'tell application id "dev.perch.app" to quit' >/dev/null 2>&1 || pkill -x Perch || true
    sleep 1
fi

mkdir -p "$DEST"
if [ -w "$DEST" ]; then
    rm -rf "$DEST/Perch.app"
    ditto "$APP" "$DEST/Perch.app"
else
    say "Installing to $DEST needs your password."
    sudo rm -rf "$DEST/Perch.app"
    sudo ditto "$APP" "$DEST/Perch.app"
fi
xattr -dr com.apple.quarantine "$DEST/Perch.app" 2>/dev/null || true

say "Perch $version is in $DEST."
if [ -z "${PERCH_NO_OPEN:-}" ]; then
    open "$DEST/Perch.app"
    say "It lives in your notch: hover it, or press Control-Option-Space."
fi
