# Design · Swipe Feedback Lab

Version name: `swipe-feedback`
Status: `MAGNETIC_EDGES_NATIVE_IOS_ADOPTED_2026-04-29`

## Core

- Goal: compare 6 interactive non-text ways to show four-way swipe feedback.
- Mood: lock-screen control surface, visual result cues, no visible fallback
  buttons.
- Scope: design-shotgun fallback board for the next native SwiftUI pass.

## Behavior

- The page now shows 6 interactive mock variants, not one static screenshot.
- Tap an arrow control, press an arrow key, or drag any mock card to switch the
  shared direction state.
- Every mock contains four-direction feedback without a result text table.
- The six directions are `Glyph Deck`, `Magnetic Edges`, `Orbit Ring`,
  `Paper Routes`, `Queue Physics`, and `Signal Field`.
- The shared rule is that direction and likely outcome must be visible through
  edges, tracks, rings, sheets, slots, or fields before the user releases.
- Accessibility labels may name outcomes, but visible UI should stay primarily
  symbolic.

## Current Direction

- Selected direction: `Magnetic Edges`.
- Reason: the four screen edges behave like magnetic rails that pull the card,
  so the edge starts communicating intent before the user releases.
- Product fit: this keeps the feedback close to the gesture target and avoids a
  separate explanation layer.
- Next native pass should prototype `Magnetic Edges` first, then compare it
  against `Glyph Deck` only if the edge language feels too subtle.

## Native Mapping

- Derive `direction`, `progress`, and `isCommitted` from `dragOffset`.
- Map direction to tint, symbol, edge treatment, accessibility value, and optional
  haptic prewarm.
- Keep the real four actions unchanged: discard, execute, detail, later.
- Do not reintroduce visible fallback buttons; keep fallback access through
  accessibility actions.
- Do not add a bottom four-button legend; it reads as fallback UI.

## Native Implementation

- `swipev2/ios/ActivityMonitorApp/ActivityMonitorApp/ActivityMonitorApp.swift`
  now implements the selected `Magnetic Edges` direction in the live SwiftUI
  prototype.
- `SwipeFeedback` maps drag translation to action, progress, and committed state.
- `MagneticEdgesFeedbackView` renders four symbolic stack-edge rails and the
  active edge symbol while the user drags.
- `MagneticCardEdgeOverlay` keeps the active feedback attached to the card edge.
- The real actions remain unchanged: discard, execute, detail, and later.
- Visible fallback buttons remain absent; accessibility actions still provide
  the non-gesture path.

## Run It

```bash
python3 -m http.server 4173
```

Open:

```text
http://127.0.0.1:4173/docs/ios-redesign/design.swipe-feedback.html
```

## Verify It

- Confirm there are 6 visually different mock cards.
- Confirm each mock includes four-direction cues.
- Confirm arrow controls, keyboard arrows, and card dragging update all mocks.
- Confirm the direction cues are primarily symbolic or spatial, not result prose.
- Confirm no mock uses a bottom four-button fallback bar.
- Confirm there are no bottom four fallback buttons.
- Run the native iOS tests and confirm `ActionStreamStateTests` passes,
  including `SwipeFeedback` mapping coverage.

## Current Status

- Design-shotgun fallback board is ready for review with `Magnetic Edges`
  selected as the first native direction to try.
- Bottom four-button legend was removed.
- `design.swipe-feedback-16.html` adds 16 no-bottom-button directions.
- Native SwiftUI implementation now adopts `Magnetic Edges` in the swipev2 iOS
  prototype, recorded in `docs/swipev2-ios.md`.
