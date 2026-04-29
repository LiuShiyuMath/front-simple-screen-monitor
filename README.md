# swipeV2 · Action Stream Design Middleware

swipeV2 is a lock-screen action-stream prototype. It explores how notifications
become next actions, then shows the design process step by step on GitHub Pages.

## Start Here

Open the step-by-step design middleware:

https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/

## 中文读者入口

如果你想按中文说明阅读 swipeV2 的设计过程，从这里开始：

https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/

建议阅读顺序：

1. 当前原生 iOS 基线:
   https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/design.current-ios-app.html
2. Swipe Feedback Lab:
   https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/design.swipe-feedback.html
3. Swipe Feedback 16 个方向探索:
   https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/design.swipe-feedback-16.html
4. 当前 swipeV2 iOS 实现状态:
   https://liushiyumath.github.io/front-simple-screen-monitor/docs/swipev2-ios.md
5. 可交互行动流 demo:
   https://liushiyumath.github.io/front-simple-screen-monitor/swipev2/

## What To Look At

- `design.current-ios-app.html` shows the current native iOS baseline.
- `design.swipe-feedback.html` shows the selected Magnetic Edges feedback path.
- `design.swipe-feedback-16.html` records broader four-way swipe explorations.
- `docs/swipev2-ios.md` records what is implemented, how to run it, and how it
  was verified.
- `/swipev2/` is the interactive browser demo.

## Native iOS App

The current native iOS app lives at:

`swipev2/ios/ActivityMonitorApp.xcodeproj`

Run the simulator test suite:

```bash
xcodebuild test \
  -project swipev2/ios/ActivityMonitorApp.xcodeproj \
  -scheme ActivityMonitorApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -derivedDataPath /tmp/swipev2-ios-derived
```

## Hosting

This repo is static HTML and docs. GitHub Pages serves the design middleware and
the interactive swipeV2 demo from the repository root.
