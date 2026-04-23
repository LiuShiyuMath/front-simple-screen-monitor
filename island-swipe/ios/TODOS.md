# iOS App · Deferred TODOs

Recorded during `/plan-eng-review` on 2026-04-23.

## TODO-1: Distribution pipeline (TestFlight + signing)

**What:** Set up Apple code signing, provisioning profiles, TestFlight upload,
fastlane lane or GitHub Actions workflow for `.ipa` builds.

**Why:** Prototype currently runs only on Simulator. No distribution channel = no
real-device validation, no external demo share.

**Pros:**
- Enables real-device haptic / gesture validation (simulator haptics are stubs).
- Unlocks external demo / stakeholder review.
- Forces clean signing config before it's urgent.

**Cons:**
- Apple Developer Program fee ($99/yr).
- Certificate + provisioning upkeep.
- Fastlane / GitHub Actions config surface area.

**Context:**
- `project.yml` and `ActivityMonitorApp.xcodeproj` currently lack team/bundle-id.
- No CI. No release automation.
- Plan explicitly scoped prototype-only (see Scope decision, eng review 2026-04-23).

**Depends on / blocked by:** Apple Developer Program enrollment.

---

## TODO-2: State persistence across launches

**What:** Persist `MonitorSessionState.history`, `allowedCount`, `blockedCount`
across app launches via `UserDefaults` JSON (or lightweight Core Data).

**Why:** Current state is in-memory. Demo users may expect their decisions to
persist across a cold-start. Also required as data foundation for any future
analytics / streak / trend feature.

**Pros:**
- Session continuity UX.
- Foundation for later stats / trend features.
- Forces `Codable` completeness on the domain model.

**Cons:**
- New dependency surface (`UserDefaults` or Core Data).
- Schema migration becomes a concern once shipped.
- Testing surface expands.

**Context:**
- `MonitorDecision`, `RiskLevel`, `SceneKind` already `Codable`.
- `MonitorActivity` + `MonitorHistoryEntry` need `Codable` conformance.
- Natural insertion point: `MonitorViewModel.bootstrap()` reads; each
  `commitDecision` writes.

**Depends on / blocked by:** None.

---

## TODO-3: Accessibility pass (VoiceOver + Dynamic Type + swipe alternative)

**What:** Add `accessibilityLabel` / `accessibilityHint` / `accessibilityValue`
to all interactive elements. Replace hardcoded font sizes with scaled typography.
Add a non-swipe alternative (long-press menu or accessibility action) for
ALLOW / BLOCK decisions.

**Why:** Current UI is entirely swipe-gesture-driven with no alternative path,
all font sizes are hardcoded, no VoiceOver labels exist. App Store review and
any public distribution will require accessibility compliance.

**Pros:**
- Reaches users with motor / visual impairments.
- Reduces App Store rejection risk.
- Dynamic Type support also helps users who simply prefer larger text.

**Cons:**
- Swipe-only interaction needs a re-think (long-press? rotor action?).
- Monospaced-at-fixed-size aesthetic conflicts with Dynamic Type scaling.
- Design + engineering lift, not trivial.

**Context:**
- `DynamicIslandMonitorView.swift:130-137` drag gesture has no alternative.
- All typography uses `.system(size: 9-18, ..., design: .monospaced)` — fixed size.
- No `accessibilityLabel` anywhere in the codebase (grep confirms).

**Depends on / blocked by:** None. Best done before public distribution
(see TODO-1).
