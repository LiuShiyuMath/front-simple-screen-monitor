#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common_app_env.sh"

ZIP_PATH="$DIST_DIR/${APP_DISPLAY_NAME// /-}-macOS.zip"

mkdir -p "$DIST_DIR"
build_bundle release
rm -f "$ZIP_PATH"
ditto -c -k --sequesterRsrc --keepParent "$APP_BUNDLE" "$ZIP_PATH"

echo "APP_BUNDLE=$APP_BUNDLE"
echo "ZIP_PATH=$ZIP_PATH"
