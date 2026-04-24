# Video Verify Subagents

Use these subagents to implement `docs/video-feature-self-verify.md`.
They evaluate the canonical 60-second demo video, not the product roadmap.

## Inputs

- Demo video file or link.
- Product URL or local preview, if available.
- `docs/video-feature-self-verify.md`.
- Optional script, storyboard, or shot list.
- Optional fixture JSON from `docs/examples/`.

## Coordinator Rules

1. Keep the scope fixed to `D: Boil the Lake Hybrid`.
2. Run the evidence-gathering agents in parallel when possible.
3. Require timestamped evidence for every pass or fail.
4. Do not accept "looks good" as a verdict.
5. Merge outputs into one score and one re-cut plan.

## Subagents

### Silent Story Agent

Question: can a stranger understand the demo with audio off?

Checks:
- screen observation is visible
- permission request appears
- ALLOW/BLOCK choices are legible
- decision feedback is visible
- stats or history update is visible

Output:
- `pass`, `partial`, or `fail`
- 3-5 timestamped evidence notes
- the single most confusing moment

### First 15 Seconds Agent

Question: do the first 15 seconds communicate the problem?

Required message:
`AI can see your screen, so it should ask before it acts.`

Output:
- one-sentence viewer takeaway
- timestamp where the problem becomes clear
- missing setup shot, if any

### Proof Shot Agent

Question: does every required proof shot exist on screen?

Required proof shots:
- screen observation
- permission request
- ALLOW right swipe and green confirmation
- BLOCK left swipe and red denial
- trust log or stats/history
- high-risk example
- recovery to the next request

Output:
- table with `shot`, `timestamp`, `verdict`, `fix`
- list of pickup shots needed before re-cutting

### Interaction Clarity Agent

Question: can viewers tell what the user did and what changed?

Checks:
- right means ALLOW
- left means BLOCK
- counts increment after decisions
- every 5-8 seconds has a visible state change
- no final stuck state

Output:
- timeline of state changes
- unclear interaction moments
- recommended edit order

### Pacing and Value Agent

Question: does each shot prove user value instead of only showing UI polish?

Checks:
- every 5-8 seconds has a visible state change
- each core shot maps to a user outcome
- the video stays focused on the permission layer
- visual style does not replace the product story

Output:
- timestamped pacing map
- shot-to-user-value table
- moments that feel like UI demo without product proof

### Stranger Retell Agent

Question: can a new viewer retell the core value?

Target retell:
`AI asks permission before acting, and I can allow or block with a swipe.`

Output:
- predicted retell in one sentence
- missing nouns or verbs
- whether the video explains what to try next

### Scorekeeper Agent

Question: should we ship, re-cut, or rewrite?

Score 0-2 each:
- problem understood within 15 seconds
- ALLOW/BLOCK interaction is clear
- need for an AI permission layer is clear
- visual direction is memorable
- decision feedback is obvious
- viewer knows how to try or explain it afterward

Output:
- total score out of 12
- per-item scores with timestamp evidence
- final verdict:
  - `9-12`: ship the video
  - `7-8`: re-cut the video
  - `5-6`: rewrite the script
  - `0-4`: fix the narrative before implementation

## Final Merge Format

The coordinator returns:

1. Ship/re-cut/rewrite verdict.
2. 0-12 score.
3. Timestamped evidence table.
4. Missing proof shots.
5. Shot-to-user-value map.
6. Ordered re-cut or rewrite tasks.
7. One-line stranger retell.

## Fixture JSON Contract

Use the example fixtures to test the self-verify script without needing real
video analysis:

```bash
node scripts/video-feature-self-verify.mjs docs/examples/video-feature-self-verify.pass.json
node scripts/video-feature-self-verify.mjs docs/examples/video-feature-self-verify.recut.json
```

Required top-level fields:
- `schemaVersion`
- `video`
- `expected`
- `scores`
- `evidence`
- `proofShots`
- `stateChanges`
- `strangerRetell`
- `tasks`

The script should derive the verdict from `scores.total`: `9-12` ships, `7-8`
re-cuts, `5-6` rewrites, and `0-4` means the narrative must be fixed before
implementation.

## Ready Prompt

```text
You are the Video Verify Coordinator for front-simple-screen-monitor.
Use docs/video-feature-self-verify.md and docs/video-verify-subagents.md.
Evaluate this demo video with the subagent rubric. Return the final merge
format only. Every pass/fail must cite a timestamp.
```
