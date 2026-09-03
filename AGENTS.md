# AGENTS.md

This repository keeps repo-wide agent policy in
`.github/copilot-instructions.md`.

If you are an AI agent or automation tool starting from the repository root:

- Read `.github/copilot-instructions.md` first.
- Apply any scoped instruction files in `.github/instructions/` that match the
  files or workflow you are changing.
- Check `.github/skills/` for an invokable runbook matching the user's request
  (for example, opening a PR, addressing review feedback, or managing issues)
  and follow it — this applies regardless of whether your tooling has a
  native "skill" discovery mechanism, since `.github/skills/` is not tied to
  any one tool's convention.
- Check `.github/agents/` for contextual/advisory guidance (not unconditional
  gates) matching the work at hand — for example diagram authoring or
  documentation-artifact triggers — and apply it when relevant.
- Do not maintain separate full-policy copies in `CLAUDE.md`, `CURSOR.md`,
  `GEMINI.md`, or similar files. If a tool requires a repo-root discovery
  file, keep it as a thin stub that delegates to the canonical policy.
- Claude Code auto-discovers skills under `.claude/skills/<name>/SKILL.md`.
  Those files are thin stubs that delegate to the canonical, tool-neutral
  content in `.github/skills/<name>/SKILL.md`; do not fork full skill
  content into `.claude/skills/`.
- Claude Code auto-discovers agents under `.claude/agents/<name>.md`. Those
  files are thin stubs that delegate to the canonical content in
  `.github/agents/<name>.agent.md`; do not fork full agent content into
  `.claude/agents/`.
