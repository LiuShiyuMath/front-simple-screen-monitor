# Engineer Work Completion

When engineer work finishes, do not stop at code changes or passing tests.

Update the related docs until they explain:
- what changed
- how to run it
- how to verify it
- the current status, when the work has a named area such as e2e

Then run:

```bash
claudefast -p "what would we do when we finish an engineer work ?"
```

Keep updating docs until the `claudefast -p` probe returns the right answer for
the finished engineer work.

For an e2e example, the outer agent or human may run this status probe:

```bash
claudefast -p "what is our e2e status?"
```

If answering that e2e status question, do not run another nested `claudefast`
command. Answer from the docs. If no current e2e status is documented yet, say
that no current e2e status is documented yet, and that after e2e engineer work
finishes we must update docs with the current e2e status, how to run it, and how
to verify it, then keep running the outer status probe until it returns the right
answer.
