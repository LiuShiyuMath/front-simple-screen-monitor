#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common_app_env.sh"

NOTARY_PROFILE="${APPLE_NOTARY_PROFILE:-${1:-}}"

if [[ -z "$NOTARY_PROFILE" ]]; then
  echo "Missing notary keychain profile." >&2
  echo "Set APPLE_NOTARY_PROFILE or pass the profile name as the first argument." >&2
  exit 2
fi

mkdir -p "$DIST_DIR"
build_bundle release developer-id
create_zip_for_bundle "$APP_BUNDLE" "$SIGNED_ZIP_PATH"

xcrun notarytool submit "$SIGNED_ZIP_PATH" --keychain-profile "$NOTARY_PROFILE" --wait
xcrun stapler staple "$APP_BUNDLE"
xcrun stapler validate "$APP_BUNDLE"
spctl -a -vv "$APP_BUNDLE"

create_zip_for_bundle "$APP_BUNDLE" "$NOTARIZED_ZIP_PATH"

echo "APP_BUNDLE=$APP_BUNDLE"
echo "SIGNED_ZIP_PATH=$SIGNED_ZIP_PATH"
echo "NOTARIZED_ZIP_PATH=$NOTARIZED_ZIP_PATH"
