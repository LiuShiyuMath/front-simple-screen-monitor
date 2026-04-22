codex exec 'Read island-swipe/DESIGN.md and implement a complete native iPhone app in SwiftUI.

Project requirements:
- Native iOS app, not web
- SwiftUI app structure
- Clean project organization
- Ready to open and run in Xcode
- Target modern iPhone devices
- Provide a polished interactive prototype experience on first launch

Product interpretation:
- Implement the Dynamic Island concept as an in-app SwiftUI component at the top of the app
- This should visually evoke Dynamic Island while remaining a normal app UI component
- Do not claim direct control over the system Dynamic Island

Use DESIGN.md as source of truth for:
- concept
- visual direction
- color palette
- typography feel
- layout
- interactions
- metadata
- metaphor constraints

Must implement:
- Full-screen app experience
- Top Dynamic-Island-style pill
- Notification/activity card inside the pill
- Stats panel below
- Swipe left to BLOCK
- Swipe right to ALLOW
- 90pt threshold
- Auto-expand after 1.2s
- Haptic on successful swipe
- Live counters for ALLOWED / BLOCKED / TOTAL
- Clean animation states for idle / expanded / dragging / accepted / denied / reset

Technical quality bar:
- Reusable SwiftUI views
- Proper state management
- Smooth gesture handling
- Good layout across iPhone sizes
- Maintainable code
- Thoughtful naming
- No unnecessary dependencies

Polish requirements:
- Terminal Noir feeling
- Strong but restrained glow/accent usage
- Crisp borders
- Excellent spacing
- Precise hierarchy
- No cheesy visual language

Implementation guidance:
- Build this as a polished app prototype, not a static mock
- Use sample activity items so the experience is interactive immediately on first launch
- Prefer a small, disciplined file structure with clear separation between app shell, UI components, models, gesture logic, and haptics
- Use native system typography and monospaced styles where appropriate if custom fonts would add unnecessary setup
- Support dark appearance as the intended default

Before finalizing:
- run a self-check against DESIGN.md
- verify interaction flow end to end
- tighten any weak visual details
- summarize implementation and file structure

Finally, report:
- what you implemented
- file structure
- any small compromises made
- how the app maps back to DESIGN.md'
