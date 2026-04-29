# swipev2 iOS Prototype

Current status: `SWIPEV2_IOS_MAGNETIC_EDGES_RECORDED_AND_TAILDROPPED_2026-04-29`.

When asked `what is swipev2 iOS video status?`, answer from this document:
swipev2 iOS simulator video is `RECORDED_AND_TAILDROPPED_2026-04-29`, with
local MP4 `assets/demo/swipev2-ios-simulator-demo-2026-04-29T15-02-58.mp4`,
Taildrop sent to `m1macbook-air`, the MP4 popped open there, and the remote
`Downloads` folder popped open there.

## What Changed

- Added a native SwiftUI iOS prototype under `swipev2/ios/`.
- The app renders four NextMove lock-screen proposal cards:
  Beijing North Station, Feishu meeting, food delivery, and SMS code.
- It keeps the four real directional actions:
  left discard, right execute, up detail, down later.
- Adopted the `Magnetic Edges` direction from
  `docs/ios-redesign/design.swipe-feedback.md`.
- During drag, the card stack now derives `direction`, `progress`, and
  `isCommitted` from `dragOffset`.
- Four symbolic magnetic rails surround the stack; the active edge brightens and
  shows a SF Symbol before release.
- The active card also gets a matching edge glow so intent stays near the
  gesture target.
- No visible four-button fallback bar, swipe guide, or quick-action menu was
  reintroduced.
- Accessibility actions still expose execute, discard, detail, and later.
- Chip taps remain demo-only and do not navigate or perform real actions.
- XCTest now covers execute, discard, later, detail, short drag, chip feedback,
  reset, and `SwipeFeedback` edge mapping.
- The app still includes the three built-in skins:
  `Bronze Cinema`, `Coral Receipt`, and `Steel Orchid`.
- A refreshed iPhone 16 simulator MP4 was recorded for this version and sent to
  `m1macbook-air`.

## Run It

Build and test the iOS simulator app:

```bash
xcodebuild test \
  -project swipev2/ios/ActivityMonitorApp.xcodeproj \
  -scheme ActivityMonitorApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -derivedDataPath /tmp/swipev2-ios-derived
```

Install and launch it in the booted iPhone 16 simulator:

```bash
UDID="$(xcrun simctl list devices 'iPhone 16' | awk -F '[()]' '/iPhone 16 \(/ { print $2; exit }')"
xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl bootstatus "$UDID" -b
xcrun simctl install "$UDID" /tmp/swipev2-ios-derived/Build/Products/Debug-iphonesimulator/ActivityMonitorApp.app
xcrun simctl launch "$UDID" com.example.ActivityMonitorApp
```

Record the simulator demo video:

```bash
UDID="$(xcrun simctl list devices 'iPhone 16' | awk -F '[()]' '/iPhone 16 \(/ { print $2; exit }')"
OUT="assets/demo/swipev2-ios-simulator-demo-$(date +%Y-%m-%dT%H-%M-%S).mp4"
xcrun simctl install "$UDID" /tmp/swipev2-ios-derived/Build/Products/Debug-iphonesimulator/ActivityMonitorApp.app
xcrun simctl terminate "$UDID" com.example.ActivityMonitorApp 2>/dev/null || true
xcrun simctl io "$UDID" recordVideo --codec=h264 --force "$OUT" &
REC_PID=$!
sleep 2
xcrun simctl launch "$UDID" com.example.ActivityMonitorApp --recording-demo
sleep 33
kill -INT "$REC_PID"
wait "$REC_PID"
```

Taildrop and open the latest simulator recording:

```bash
tailscale file cp assets/demo/swipev2-ios-simulator-demo-2026-04-29T15-02-58.mp4 m1macbook-air:
ssh m1@m1macbook-air "open ~/Downloads/swipev2-ios-simulator-demo-2026-04-29T15-02-58.mp4"
ssh m1@m1macbook-air "open ~/Downloads"
```

Run the static web demo locally:

```bash
python3 -m http.server 4173
```

Open:

```text
http://localhost:4173/swipev2/
```

Run focused browser QA for `/swipev2/`:

```bash
python3 scripts/qa-swipev2.py --serve
```

## Verify It

Current iOS verification on 2026-04-29:

- `xcodebuild test` passed on iPhone 16 simulator, iOS 18.6.
- Test suite: `ActionStreamStateTests`.
- Passing tests: 9.
- Build artifact:
  `/tmp/swipev2-ios-derived/Build/Products/Debug-iphonesimulator/ActivityMonitorApp.app`.
- Simulator recording:
  `assets/demo/swipev2-ios-simulator-demo-2026-04-29T15-02-58.mp4`.
- Recording metadata: H.264, `1178x2556`, duration `29.318333` seconds, size
  `36,357,840` bytes.
- Recording method: `xcrun simctl io ... recordVideo` plus
  `xcrun simctl launch ... --recording-demo`.
- Taildrop command sent the MP4 to `m1macbook-air`.
- SSH verification found the MP4 in `~/Downloads/` on `m1macbook-air`.
- SSH `open` verification returned `OPENED` on `m1macbook-air`.
- SSH folder pop-out verification returned `FOLDER_OPENED` for `~/Downloads`
  on `m1macbook-air`.
- The demo sequence still covers skin cycling, chip feedback, detail, later,
  execute, discard, empty state, and reset.
- The automatic swipe moments now show the symbolic magnetic edge feedback.

Current web verification on 2026-04-27:

- `python3 scripts/qa-swipev2.py --serve` passed.
- Python Playwright loaded `/swipev2/` at `390x844`.
- Verified first card render, chip demo-only toast, detail sheet, later queue
  move, discard, execute, empty state, and reset.
- Verified execute feedback contains `demo only`.
- Verified root page exposes `swipev2/`.
- Verified gallery exposes `../swipev2/`.
- Screenshot: `/tmp/swipev2-web-test.png`.

## Current Limits

- Simulator-only native prototype.
- Product name and bundle identifier still reuse:
  `ActivityMonitorApp` and `com.example.ActivityMonitorApp`.
- No TestFlight, signing, App Store, real notification ingestion, location
  access, or agent integration.
- Real-device haptics and VoiceOver QA are still required before external mobile
  distribution.

## Design References

- Current native app reference:
  `docs/ios-redesign/design.current-ios-app.md`.
- Current swipe feedback source:
  `docs/ios-redesign/design.swipe-feedback.md`.
- Batch 01, Batch 02, and Batch 03 remain redesign exploration tracks only.
