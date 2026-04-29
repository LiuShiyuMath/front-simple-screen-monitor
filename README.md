# 屏察御史 · Screen Monitor UX Lab

Backend snaps screen every 5s, guesses user intent, frontend asks for royal consent. Same consent prompt rendered in **three** distinct interaction paradigms.

## Live

https://liushiyumath.github.io/front-simple-screen-monitor/

## swipeV2 design middleware

Start here for the step-by-step swipeV2 design story:

https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/

Key checkpoints:

- Current native iOS baseline:
  https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/design.current-ios-app.html
- Swipe feedback lab:
  https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/design.swipe-feedback.html
- Swipe feedback 16-way exploration:
  https://liushiyumath.github.io/front-simple-screen-monitor/docs/ios-redesign/design.swipe-feedback-16.html
- Current iOS implementation status:
  https://liushiyumath.github.io/front-simple-screen-monitor/docs/swipev2-ios.md
- Interactive action-stream demo:
  https://liushiyumath.github.io/front-simple-screen-monitor/swipev2/

## Demo in 60 seconds

AI can see your screen, so Activity Monitor asks before it acts. Swipe right to
ALLOW, swipe left to BLOCK, and every decision updates the trust log.

- Watch: https://liushiyumath.github.io/front-simple-screen-monitor/assets/demo/activity-monitor-canonical-demo-2026-04-24T05-01-34.mp4
- Try: https://liushiyumath.github.io/front-simple-screen-monitor/island-swipe/
- Try action stream: https://liushiyumath.github.io/front-simple-screen-monitor/swipev2/
- Current proof status: canonical proof clip is checked in for GitHub Pages static hosting.

## Four chambers

| Path | 中文 | English | UI pattern |
|------|------|---------|------------|
| [`/`](./index.html) | 殿前 | Landing | Directory + hover previews |
| [`/swipe/`](./swipe/) | 御前羊皮卷 | Royal Parchment | Full-screen 3-column, scroll unfurls, swipe + vibrate on mobile |
| [`/popout/`](./popout/) | 密函天降 | Popout Envelope | Corner bell toast, tap opens letter modal, fly-away on verdict |
| [`/island/`](./island/) | 灵动岛御批 | Dynamic Island | Apple-style morphing pill, iOS buttons, device frame on desktop |
| [`/island-swipe/`](./island-swipe/) | 灵动岛滑驱 | Swipe Island | Terminal Noir pill, swipe left=BLOCK, swipe right=ALLOW, no buttons |
| [`/swipev2/`](./swipev2/) | 行动流 | Action Stream | Lock-screen notification intent cards, four-way swipe, demo-only actions |

Island variants share:

- Same mock `REQUEST_POOL` (Chrome / Terminal / Mail / VS Code / Slack / Twitter scenarios)
- Swipe or key: `←/A` deny · `→/D` approve
- `navigator.vibrate(40)` on approve, `[80, 40, 80]` on deny
- `SPACE` summon · `ESC` collapse (where relevant)

## Hosting

Static HTML, no build step. Google Fonts CDN with cross-platform Chinese fallback. GitHub Pages serves the repo root.
