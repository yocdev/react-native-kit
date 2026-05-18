#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="ReactNativeKit"
MACOS_DIR="$ROOT_DIR/apps/reactkit-native-macos"
BACKEND_DIR="$ROOT_DIR/apps/reactkit-native-backend"
REACTOTRON_DIR="$ROOT_DIR/packages/reactotron"
BUILD_DIR="$ROOT_DIR/dist/macos"
APP_DIR="$BUILD_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_BUNDLE_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

require_path() {
  local path="$1"
  local label="$2"
  if [[ ! -e "$path" ]]; then
    echo "Missing $label: $path" >&2
    exit 1
  fi
}

BUN_PATH="${BUN_PATH:-$(command -v bun || true)}"
if [[ -z "$BUN_PATH" ]]; then
  echo "Bun is required to package $APP_NAME. Install Bun or set BUN_PATH." >&2
  exit 1
fi

require_path "$BACKEND_DIR/src/index.js" "backend entry"
require_path "$REACTOTRON_DIR/lib/reactotron-core-server/dist/commonjs/index.js" "reactotron-core-server build"
require_path "$REACTOTRON_DIR/lib/reactotron-mcp/dist/index.js" "reactotron-mcp build"
require_path "$REACTOTRON_DIR/node_modules/ws" "ws dependency"
require_path "$REACTOTRON_DIR/node_modules/ramda" "ramda dependency"
require_path "$REACTOTRON_DIR/node_modules/mitt" "mitt dependency"
require_path "$REACTOTRON_DIR/node_modules/zod" "zod dependency"
require_path "$REACTOTRON_DIR/node_modules/@modelcontextprotocol/sdk" "MCP SDK dependency"

swift build \
  --package-path "$MACOS_DIR" \
  -c release \
  --product "$APP_NAME"

BIN_DIR="$(swift build --package-path "$MACOS_DIR" -c release --show-bin-path)"
require_path "$BIN_DIR/$APP_NAME" "macOS executable"

rm -rf "$APP_DIR"
mkdir -p "$MACOS_BUNDLE_DIR" "$RESOURCES_DIR"

cp "$BIN_DIR/$APP_NAME" "$MACOS_BUNDLE_DIR/$APP_NAME"
cp "$BUN_PATH" "$MACOS_BUNDLE_DIR/bun"
cp "$MACOS_DIR/packaging/Info.plist" "$CONTENTS_DIR/Info.plist"
cp "$MACOS_DIR/ReactKit.icns" "$RESOURCES_DIR/ReactKit.icns"

mkdir -p "$RESOURCES_DIR/apps/reactkit-native-backend/src"
cp "$BACKEND_DIR/src/index.js" "$RESOURCES_DIR/apps/reactkit-native-backend/src/index.js"
cp "$BACKEND_DIR/package.json" "$RESOURCES_DIR/apps/reactkit-native-backend/package.json"

mkdir -p "$RESOURCES_DIR/packages/reactotron/lib/reactotron-core-server"
cp "$REACTOTRON_DIR/lib/reactotron-core-server/package.json" \
  "$RESOURCES_DIR/packages/reactotron/lib/reactotron-core-server/package.json"
cp -R "$REACTOTRON_DIR/lib/reactotron-core-server/dist" \
  "$RESOURCES_DIR/packages/reactotron/lib/reactotron-core-server/dist"

mkdir -p "$RESOURCES_DIR/packages/reactotron/lib/reactotron-mcp"
cp "$REACTOTRON_DIR/lib/reactotron-mcp/package.json" \
  "$RESOURCES_DIR/packages/reactotron/lib/reactotron-mcp/package.json"
cp -R "$REACTOTRON_DIR/lib/reactotron-mcp/dist" \
  "$RESOURCES_DIR/packages/reactotron/lib/reactotron-mcp/dist"

mkdir -p "$RESOURCES_DIR/packages/reactotron/node_modules"
cp -R "$REACTOTRON_DIR/node_modules/ws" "$RESOURCES_DIR/packages/reactotron/node_modules/ws"
cp -R "$REACTOTRON_DIR/node_modules/ramda" "$RESOURCES_DIR/packages/reactotron/node_modules/ramda"
cp -R "$REACTOTRON_DIR/node_modules/mitt" "$RESOURCES_DIR/packages/reactotron/node_modules/mitt"
cp -R "$REACTOTRON_DIR/node_modules/zod" "$RESOURCES_DIR/packages/reactotron/node_modules/zod"

mkdir -p "$RESOURCES_DIR/packages/reactotron/node_modules/@modelcontextprotocol"
cp -R "$REACTOTRON_DIR/node_modules/@modelcontextprotocol/sdk" \
  "$RESOURCES_DIR/packages/reactotron/node_modules/@modelcontextprotocol/sdk"

chmod +x "$MACOS_BUNDLE_DIR/$APP_NAME" "$MACOS_BUNDLE_DIR/bun"

echo "$APP_DIR"
