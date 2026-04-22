#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common_app_env.sh"

TARGET_PATH="${1:-$APP_BUNDLE}"

echo "== codesign details =="
codesign -dv --verbose=4 "$TARGET_PATH" 2>&1

echo
echo "== codesign verify =="
codesign --verify --deep --strict --verbose=2 "$TARGET_PATH"

echo
echo "== gatekeeper =="
spctl -a -vv "$TARGET_PATH"

echo
echo "== stapler validate =="
xcrun stapler validate "$TARGET_PATH"
