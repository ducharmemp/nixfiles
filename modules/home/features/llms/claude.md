# Claude Code Specifics

These instructions extend the global AGENTS.md for Claude Code sessions only. The review checkpoints are defined there; this file holds the Claude Code procedure for checkpoint 2's code/docs review.

**Don't use plan mode**: Work in normal mode throughout. Treat planning as a conversation phase — research, draft the plan, run the review loop, discuss — then proceed to implementation without switching modes.

**Code review / docs review procedure**: Full (8-persona) or lightweight (3-persona) — the orchestrator selects the mode based on change scope and reports the choice when presenting results. There is no fixed threshold; it's a judgment call on the scope, risk, and blast radius of the change, so state the reasoning for the mode you picked. Matt can request full mode if lightweight was used and he wants deeper coverage. The implementer receives the synthesized findings and triages them per the fix/park rules in AGENTS.md.

- **Full mode**: After fixing, the review runs again. Personas run with fresh context (no knowledge of prior findings). The synthesis step receives the full review history so it can verify fixes were addressed, not re-flag parked items, and detect convergence failures — when the same area keeps producing findings across rounds, the synthesizer escalates a structural question (always parked). Loop until clean — meaning no findings remain except parked items.
- **Lightweight mode**: No re-review loop. Fix the findings and proceed. If finding density is unexpectedly high, the orchestrator presents this to the human — the change may warrant full mode.
