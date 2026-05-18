# ReactNativeKit macOS

SwiftUI shell for the lightweight native ReactNativeKit debugger.

Run from this package:

```bash
swift run ReactNativeKit
```

The app starts `apps/reactkit-native-backend/src/index.js` automatically. Override paths and ports with:

- `REACTKIT_ROOT`
- `REACTOTRON_NATIVE_API_PORT`
- `REACTOTRON_SERVER_PORT`
- `REACTOTRON_MCP_PORT`

Build a local `.app` bundle from the repository root:

```bash
npm run package:macos
```
