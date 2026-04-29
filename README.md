# swipeV2

swipeV2 is a lock-screen action stream for turning notifications into the next
thing a person can do.

The best place to understand the project is the design walkthrough:

**https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/**

## 中文阅读

swipeV2 的核心不是“通知摘要”，而是：

**把通知变成下一步行动。**

推荐按这个顺序看：

1. 先看设计 walkthrough:
   https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/

2. 再看当前 iOS 原型长什么样:
   https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/design.current-ios-app.html

3. 然后看四向滑动反馈如何设计:
   https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/design.swipe-feedback.html

4. 最后玩可交互 demo:
   https://liushiyumath.github.io/front-simple-screen-monitor/swipev2/

## English Path

Read it in this order:

1. Design walkthrough:
   https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/

2. Current iOS baseline:
   https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/design.current-ios-app.html

3. Swipe feedback design:
   https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/design.swipe-feedback.html

4. Interactive demo:
   https://liushiyumath.github.io/front-simple-screen-monitor/swipev2/

## Current iOS App

Native project:

`swipev2/ios/ActivityMonitorApp.xcodeproj`

Run tests:

```bash
xcodebuild test \
  -project swipev2/ios/ActivityMonitorApp.xcodeproj \
  -scheme ActivityMonitorApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -derivedDataPath /tmp/swipev2-ios-derived
```

Implementation status:

`docs/swipev2-ios.md`
