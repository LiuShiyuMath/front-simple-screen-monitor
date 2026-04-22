#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common_app_env.sh"

TARGET_DIR="${HOME}/Applications"

case "${1:-}" in
  --system)
    TARGET_DIR="/Applications"
    ;;
  --user|"")
    ;;
  *)
    echo "usage: $0 [--user|--system]" >&2
    exit 2
    ;;
esac

"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/package_app.sh" >/dev/null

mkdir -p "$TARGET_DIR"
rm -rf "$TARGET_DIR/$APP_BUNDLE_NAME"
cp -R "$APP_BUNDLE" "$TARGET_DIR/$APP_BUNDLE_NAME"

echo "INSTALLED_APP=$TARGET_DIR/$APP_BUNDLE_NAME"
