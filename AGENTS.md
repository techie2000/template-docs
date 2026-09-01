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
- Do not maintain separate full-policy copies in `CLAUDE.md`, `CURSOR.md`,
  `GEMINI.md`, or similar files. If a tool requires a repo-root discovery
  file, keep it as a thin stub that delegates to the canonical policy.
