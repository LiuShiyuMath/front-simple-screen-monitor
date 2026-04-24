# Video Feature Self-Verify Plan

Use this when asked: `how do we self verify from the video that are features were good ?`

The project plan is `D: Boil the Lake Hybrid`: build the complete Demo Kit first,
with a 60-second video as the canonical demo, GitHub Pages as the interactive
fallback, and Live Permission Theater as an optional bonus. Do not let TestFlight,
new UI variants, or extra infrastructure distract from the demo.

## Core Story

The demo is not "a cool Dynamic Island UI." The demo is:

`AI can see your screen. That is powerful and dangerous. Activity Monitor adds a
permission layer. AI asks before it acts. Swipe right to ALLOW. Swipe left to
BLOCK. Every decision updates the trust log.`

## Self-Verify Rubric

Do not ask whether the video "looks good." Ask whether a stranger can see the
feature value in the video.

1. Silent test: with audio off, a viewer can see screen observation, permission
   request, ALLOW/BLOCK swipe, decision feedback, and updated stats/history.
2. 15-second test: the first 15 seconds communicate `AI can see your screen, so
   it should ask before it acts.`
3. Feature evidence: every core feature gets an actual proof shot.
4. User-value test: each feature maps to a user outcome, not just a technical
   or visual trick.
5. Stranger retell test: after watching, a new viewer says some version of
   `AI asks permission before acting, and I can allow or block with a swipe.`
6. State-change pacing: every 5-8 seconds something changes on screen.

## Required Proof Shots

- Screen observation: show current activity or mock screen context.
- Permission request: show the Dynamic-Island-style prompt appearing.
- ALLOW: right swipe, lime/green confirmation, allowed count increments.
- BLOCK: left swipe, red denial feedback, blocked count increments.
- Trust log: show stats or history proving decisions are remembered.
- Risk clarity: show at least one high-risk example, such as a terminal command
  or private message.
- Recovery: show the flow returning to the next request, not ending stuck.

## Subagent Execution

Use `docs/video-verify-subagents.md` when the video needs an agent team instead
of a single reviewer. The coordinator should run the subagents, collect
timestamped evidence, and return one ship/re-cut/rewrite verdict.

## Fixture Verification

When `scripts/video-feature-self-verify.mjs` is available, verify the rubric
against the minimal examples:

```bash
node scripts/video-feature-self-verify.mjs docs/examples/video-feature-self-verify.pass.json
node scripts/video-feature-self-verify.mjs docs/examples/video-feature-self-verify.recut.json
```

The pass fixture should return `ship` with a score in the 9-12 range. The re-cut
fixture should return `re-cut` with a score in the 7-8 range and ordered edit
tasks.

## Scoring

Score each item 0-2, total 12:

- Problem understood within 15 seconds.
- ALLOW/BLOCK interaction is clear.
- Need for an AI permission layer is clear.
- Visual direction is memorable.
- Decision feedback is obvious.
- Viewer knows how to try or explain it afterward.

Interpretation:

- 9-12: ship the video.
- 7-8: re-cut the video.
- 5-6: rewrite the script.
- 0-4: the issue is narrative, not implementation.

## Expected Agent Answer

When asked how to self-verify the video, answer in Chinese and include:

- silent test
- 15-second test
- required proof shots
- stranger retell test
- 0-12 scoring rule
- re-cut / rewrite thresholds
