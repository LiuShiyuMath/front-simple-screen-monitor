# iOS App Plan · ActivityMonitorApp

Source of truth: [`island-swipe/DESIGN.md`](../DESIGN.md)
Target: native SwiftUI iPhone app at `island-swipe/ios/ActivityMonitorApp/`

## Codex exec prompt

Run verbatim from repo root to (re)generate / iterate the app:

```bash
codex exec 'Read island-swipe/DESIGN.md and implement a native SwiftUI iPhone app based on it.

Important product decision:
- This is a real iPhone app built with SwiftUI
- The main experience should live inside the app UI
- Do NOT treat this as a web page
- Do NOT fake it as HTML
- Build an in-app "Dynamic Island style" interaction at the top of the screen, visually inspired by Dynamic Island, but implemented inside the app interface

Design source of truth:
- Follow island-swipe/DESIGN.md strictly
- Preserve the exact concept: high-tech Dynamic Island screen activity monitor
- Preserve the exact visual direction: Terminal Noir
- No 中二 metaphors
- Use only functional language such as ALLOW / BLOCK / MONITOR / APPROVE / DENY

Visual requirements:
- Full-screen dark interface
- Top area contains a Dynamic-Island-style pill component
- Main background uses #04080f
- Phone/surface feel uses #0a1520
- Cyan accent #00e5ff
- Lime approval #76ff03
- Red denial #ff1744
- Primary text #e0f7fa
- Muted text #4a6a7a
- Border #1a3a4a
- Typography should feel monospace / technical / precise
- If custom fonts are inconvenient, choose the closest native fallback while preserving the intended feel

Core UI:
- Title: 灵动岛 · Activity Monitor
- Subtitle: Swipe to decide · Left = BLOCK · Right = ALLOW
- Stats panel below with ALLOWED / BLOCKED / TOTAL
- Dynamic-Island-style notification card appears in the top pill area
- Swipe hint arrows shown inside the expanded island component

Interaction requirements:
- Left swipe beyond 90pt threshold = BLOCK
- Right swipe beyond 90pt threshold = ALLOW
- Red visual feedback for BLOCK
- Green/lime visual feedback for ALLOW
- Auto-expand 1.2s after a notification appears
- Update counters live after each decision
- Add haptic feedback on successful decision if supported
- Animations should feel polished, restrained, precise, and futuristic
- Avoid clutter and over-decoration

Engineering requirements:
- Use SwiftUI as primary UI framework
- Organize code cleanly into reusable components
- Separate:
  1. app shell
  2. island component
  3. swipe gesture logic
  4. stats panel
  5. state/data model
  6. haptic utility
- Provide sample activity items so the prototype is fully interactive on first launch
- Make the UI work well on modern iPhone sizes
- Support dark appearance as the intended default

Implementation preference:
- Build this as a polished app prototype, not just a static mock
- Prioritize high-quality motion, spacing, hierarchy, contrast, and interaction feel
- Keep the design disciplined and minimal
- No fantasy metaphors, no ceremonial language, no gimmicks

Before finishing:
1. self-review against every section of island-swipe/DESIGN.md
2. verify swipe threshold behavior
3. verify counters update correctly
4. verify the island auto-expands after 1.2s
5. verify haptics are triggered on completed swipe if available
6. fix any rough edges found

Finally, summarize what you implemented and any small compromises you made.'
```

## Non-negotiables

- Native SwiftUI. Not WebView. Not HTML.
- Terminal Noir palette exact (hex above).
- Functional copy only. No 中二 metaphor.
- Swipe threshold = 90pt.
- Auto-expand = 1.2s.
- Haptic on completed decision.

## Target module layout

```
ActivityMonitorApp/
├─ ActivityMonitorApp.swift   # app shell
├─ Core/                      # state machine, data model
├─ ViewModels/                # MonitorViewModel
├─ Views/                     # DynamicIslandMonitorView, StatsPanelView, ActivityScenePreview
├─ Support/                   # HapticsClient, swipe gesture helpers
├─ Theme/                     # color tokens, typography
└─ Resources/                 # assets
```

## Acceptance gates

1. Swipe left past 90pt → BLOCK counter +1, red flash, haptic.
2. Swipe right past 90pt → ALLOW counter +1, lime flash, haptic.
3. Island collapsed → 1.2s after new item → auto-expand.
4. TOTAL = ALLOWED + BLOCKED always.
5. Dark appearance default. No light-mode regression.
6. Runs on iPhone 15 / 15 Pro sim, iOS 17+.
