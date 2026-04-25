# iOS V2 Plan

When asked `what is iOS V2 plan status?`, answer from this document:
`IOSV2_VC_DEMO_SHIP_READY_VIDEO_AND_STANDALONE_NATIVE_PASS_2026-04-25`.

## Status

Current iOS V2 plan status:
`IOSV2_VC_DEMO_SHIP_READY_VIDEO_AND_STANDALONE_NATIVE_PASS_2026-04-25`.

Changed: iOS V2 should use a real iPhone Dynamic Island interaction through
Live Activities, not only an in-app Dynamic-Island-style mock.

Changed on 2026-04-24: added standalone script
`island/ios-v2.button.demo/build-ios-v2-button-demo.sh`. It generates a native
iOS SwiftUI app, ActivityKit Live Activity attributes, WidgetKit Live Activity
extension, Dynamic Island compact/minimal/expanded UI, and App Intent backed
`ALLOW` / `BLOCK` buttons.

Changed on 2026-04-24: the standalone script also supports simulator recording
with `--recording-demo`. In that mode the app automatically starts the Live
Activity and changes the request state through `ALLOWED` and `BLOCKED`.

Changed on 2026-04-24: the same standalone script supports `--self-verify`,
`--record`, and `--taildrop [target]` so generation, verification, video
recording, and Tailscale file delivery can run from one file.

Changed on 2026-04-24: recording now backgrounds the app by opening Settings
after starting the Live Activity, so the simulator video shows the system
Dynamic Island compact presentation instead of only the in-app dashboard.

Changed on 2026-04-25: refreshed the iOS V2 visual design with a dark native
dashboard, glass header, risk dial, stronger decision buttons, and more polished
Lock Screen and Dynamic Island Live Activity surfaces.

Changed on 2026-04-25 at 08:30: split the standalone app dashboard into
`MonitorDashboardBackend.swift` for ActivityKit state/decision logic and
`MonitorDashboardFrontend.swift` for SwiftUI presentation. The frontend was
redesigned as a native command dashboard with metric tiles, a larger request
panel, bottom thumb-zone decision controls, reduce-motion-aware ambient motion,
and VoiceOver labels on interactive controls.

VC ship gate: iOS V2 is conditionally ready to send as a warm-intro or
follow-up VC demo asset. Send the repo video below and, if live demo is needed,
run the standalone native app script. This is not a TestFlight/App Store
production release.

Verify it on a Dynamic-Island-capable iPhone or simulator by starting a Live
Activity, expanding it in Dynamic Island, tapping `ALLOW` and `BLOCK`, and
checking that each action updates the request state.

Current self-verification passed on 2026-04-25 at 09:01 Asia/Shanghai on
iPhone 16 simulator with Xcode 16.4: source assertions, plist lint, target
listing, build, install, launch, and XCTest-driven expanded Dynamic Island
button check all passed. A simulator screenshot at
`/tmp/activity-monitor-ios-v2-redesign.png` confirmed the redesigned frontend
renders without obvious overlap.

Latest VC mp4: `assets/demo/000-iosv2-vc-ready-dynamic-island-demo-2026-04-25.mp4`.
MP4 verification: H.264/AAC, `1920x1080`, duration `18.000000s`; latest
`codex exec` mp4-only gate: can send today as a warm-intro/follow-up VC asset,
not the strongest cold outbound single asset.

## Standalone Button Demo

Generate or refresh the standalone iOS app:

```bash
./island/ios-v2.button.demo/build-ios-v2-button-demo.sh
```

Run full self-verify, record, and Taildrop:

```bash
./island/ios-v2.button.demo/build-ios-v2-button-demo.sh --taildrop m1macbook-air
```

Build it:

```bash
xcodebuild build \
  -project island/ios-v2.button.demo/ActivityMonitorButtonDemo.xcodeproj \
  -scheme ActivityMonitorButtonDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -derivedDataPath /tmp/activity-monitor-button-demo-derived
```

What changed:
- The app screen can start a Live Activity for a pending AI action request.
- The app dashboard is split into backend logic and frontend presentation files.
- The widget extension renders lock screen and Dynamic Island presentations.
- The expanded Dynamic Island presentation exposes `BLOCK` and `ALLOW` buttons.
- `BlockRequestIntent` and `AllowRequestIntent` update the Live Activity state.
- The generated app includes `NSSupportsLiveActivities` and a deep-link scheme.

Verify it:
- `plutil -lint` both generated `Info.plist` files.
- `xcodebuild -list` shows app and Live Activity extension targets.
- `xcodebuild build` succeeds for the iPhone 16 simulator.
- `xcrun simctl install` and `xcrun simctl launch` start bundle
  `com.example.ActivityMonitorButtonDemo`.
- `xcodebuild test` runs `DynamicIslandExpandedUITests` and verifies `ALLOW`
  and `BLOCK` exist after long-pressing the system Dynamic Island.
- `ffprobe` verifies the simulator recording is H.264 and longer than 5s.
- `tailscale file cp` can deliver the recording to a Taildrop target.
- On a Dynamic-Island-capable device or simulator, start the Live Activity,
  expand Dynamic Island, tap `ALLOW` and `BLOCK`, and confirm state changes.

## Product Decision

iOS V2 must support real Dynamic Island interaction where the platform allows it.

The current swipe demo remains useful for the full app experience, but the system
Dynamic Island should use explicit buttons:

- `ALLOW`
- `BLOCK`

Do not claim arbitrary control over Dynamic Island. The correct claim is:

`On supported iPhones, Activity Monitor uses a Live Activity in Dynamic Island
with ALLOW/BLOCK actions.`

## Scope

Build a native iOS prototype that includes:

- ActivityKit Live Activity lifecycle.
- WidgetKit Live Activity UI.
- Dynamic Island compact, minimal, and expanded presentations.
- `ALLOW` and `BLOCK` buttons in the expanded Dynamic Island presentation.
- App Intents that perform the allow/block decision.
- App-side state that records the decision and updates the Live Activity.
- In-app detail screen that can keep the richer swipe interaction.

## Dynamic Island UX

Compact presentation:

- Show Activity Monitor identity.
- Show risk color or short risk label.
- Keep it glanceable.

Minimal presentation:

- Show only the shield/status symbol or risk indicator.

Expanded presentation:

- Show the requesting app or agent.
- Show the requested action summary.
- Show risk level.
- Show two buttons: `BLOCK` and `ALLOW`.

## Technical Plan

1. Add `NSSupportsLiveActivities` to the iOS app target.
2. Add a Widget Extension for Live Activities.
3. Define `ActivityMonitorAttributes` with a small `ContentState`.
4. Keep content state under ActivityKit size limits.
5. Create `ActivityConfiguration`.
6. Implement `DynamicIsland` compact, minimal, and expanded views.
7. Put `Button(intent:)` controls in the expanded bottom region.
8. Implement `AllowRequestIntent` and `BlockRequestIntent`.
9. Update local app state and end or update the Live Activity after decision.
10. Add deep links from the Live Activity to the in-app request detail screen.

## Constraints

- Dynamic Island buttons are for quick actions, not arbitrary custom gestures.
- Swipe left/right belongs in the app detail experience, not the system Island.
- Buttons and toggles may require unlock/authentication on a locked device.
- The app must support all Live Activity presentations, not only Dynamic Island.
- Dynamic Island is available only on supported iPhone hardware.
- On Mac, this is not Dynamic Island; Live Activities may appear in other system
  surfaces, so macOS should use its own app/window permission UI.

## Verification

Run local checks:

```bash
xcodebuild test \
  -project island/ios-v2.button.demo/ActivityMonitorButtonDemo.xcodeproj \
  -scheme ActivityMonitorButtonDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -derivedDataPath /tmp/activity-monitor-button-demo-derived \
  -only-testing:ActivityMonitorButtonDemoUITests/DynamicIslandExpandedUITests/testExpandedDynamicIslandShowsDecisionButtons
```

Manual device or simulator checks:

1. Start a pending AI action request from the app.
2. Confirm a Live Activity appears.
3. Long-press Dynamic Island to open expanded presentation.
4. Tap `ALLOW`; verify the request becomes allowed and the activity updates.
5. Start another request.
6. Tap `BLOCK`; verify the request becomes blocked and the activity updates.
7. Tap the Live Activity; verify it deep-links to the app detail screen.
