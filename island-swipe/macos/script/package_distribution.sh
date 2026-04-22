#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common_app_env.sh"

mkdir -p "$DIST_DIR"
build_bundle release developer-id
create_zip_for_bundle "$APP_BUNDLE" "$SIGNED_ZIP_PATH"

echo "APP_BUNDLE=$APP_BUNDLE"
echo "ZIP_PATH=$SIGNED_ZIP_PATH"
