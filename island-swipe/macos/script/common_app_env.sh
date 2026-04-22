#!/usr/bin/env bash

APP_EXECUTABLE="ActivityMonitorMac"
APP_DISPLAY_NAME="Activity Monitor"
APP_BUNDLE_NAME="$APP_DISPLAY_NAME.app"
BUNDLE_ID="com.codex.ActivityMonitorMac"
APP_VERSION="1.0.0"
APP_BUILD="1"
MIN_SYSTEM_VERSION="14.0"
APP_CATEGORY="public.app-category.utilities"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_BUNDLE="$DIST_DIR/$APP_BUNDLE_NAME"
APP_CONTENTS="$APP_BUNDLE/Contents"
APP_MACOS="$APP_CONTENTS/MacOS"
APP_RESOURCES="$APP_CONTENTS/Resources"
APP_BINARY="$APP_MACOS/$APP_EXECUTABLE"
INFO_PLIST="$APP_CONTENTS/Info.plist"

build_bundle() {
  local configuration="$1"
  local swift_build_flags=("--package-path" "$ROOT_DIR")

  if [[ "$configuration" == "release" ]]; then
    swift_build_flags+=("--configuration" "release")
  fi

  swift build "${swift_build_flags[@]}"
  local build_bin_path
  build_bin_path="$(swift build "${swift_build_flags[@]}" --show-bin-path)"
  local build_binary="$build_bin_path/$APP_EXECUTABLE"

  rm -rf "$APP_BUNDLE"
  mkdir -p "$APP_MACOS" "$APP_RESOURCES"
  cp "$build_binary" "$APP_BINARY"
  chmod +x "$APP_BINARY"

  cat >"$INFO_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleDisplayName</key>
  <string>$APP_DISPLAY_NAME</string>
  <key>CFBundleExecutable</key>
  <string>$APP_EXECUTABLE</string>
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>$APP_DISPLAY_NAME</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>$APP_VERSION</string>
  <key>CFBundleVersion</key>
  <string>$APP_BUILD</string>
  <key>LSApplicationCategoryType</key>
  <string>$APP_CATEGORY</string>
  <key>LSMinimumSystemVersion</key>
  <string>$MIN_SYSTEM_VERSION</string>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
</dict>
</plist>
PLIST

  # Ad-hoc sign the local bundle so Finder launch/install behaves more like a normal app.
  codesign --force --deep --sign - "$APP_BUNDLE" >/dev/null
}
