---
name: github-issues
description: >
  Create, update, and manage GitHub issues with the gh CLI. Covers
  duplicate-prevention search, title/body conventions, the repo's status
  label lifecycle, and the closing-keyword rules enforced by
  check-pr-issue-link and sync-issue-status-from-pr.
---

# GitHub Issues

Manage GitHub issues using the `gh` CLI (works the same whether the agent has GitHub MCP
tools available or only shell access).

## Workflow

1. **Determine action**: Create, update, or query?
2. **Check for duplicates before creating** (see below).
3. **Structure content**: Use a template from [references/templates.md](references/templates.md).
4. **Execute**: Run the corresponding `gh issue` command.
5. **Confirm**: Report the issue URL back to the user.

## Duplicate Check (Required Before Creating)

1. Identify 2-4 search terms from the proposed issue title or summary.
2. Run `gh issue list --search "<keywords>" --limit 10`.
3. Compare against issues created earlier in the same session when the topic is closely
   related.
4. If a matching issue exists, use that issue instead of creating a duplicate — update it
   or reference it.
5. If you intentionally create a follow-on issue, reference the parent/predecessor issue
   in the body.

See also `.github/instructions/github-issue-management.instructions.md` for the full
duplicate-prevention and duplicate-closure procedure.

## Creating Issues

```bash
gh issue create --title "<title>" --body-file <path-to-body.md> [--label bug,...]
```

### Title Guidelines

- Prefer an action-oriented title that states the change or broken behavior directly.
- Keep it under 72 characters when possible.
- Avoid weak starters such as `bug`, `issue`, `problem`, `help`, `feature request`, `task`.
- Keep environment, repro steps, and long context in the body, not the title.
- Preferred patterns:
  - Bug: `Fix <broken behavior> when <condition>`
  - Feature: `Add <capability> for <user or workflow>`
  - Task: `Update <artifact or workflow> to <outcome>`
  - Docs: `Document <topic or workflow>`
- A short type prefix (`[Bug]`, `[Feature]`, `[Task]`, `[Docs]`) is fine if it improves
  scanning consistency for the project.

### Body Structure

Use the templates in [references/templates.md](references/templates.md), chosen by type:

| User Request | Template |
| -------------------------------- | --------------- |
| Bug, error, broken, not working | Bug Report |
| Feature, enhancement, add, new | Feature Request |
| Task, chore, refactor, update | Task |

## Updating Issues

```bash
gh issue edit <issue-number> --add-label "<label>" --remove-label "<label>"
gh issue close <issue-number> --reason <reason>
gh issue reopen <issue-number>
```

Fetch the current issue first to avoid clobbering unrelated fields:

```bash
gh issue view <issue-number> --json title,body,labels,assignees,milestone
```

## Status Label Lifecycle

This repo's CI manages `status:*` labels automatically from linked PR state via
`.github/workflows/sync-issue-status-from-pr.yml` and
`.github/workflows/auto-label-issues.yml`. Do not apply these manually except to correct
an incorrect state.

| Label | Meaning |
| ----------------------- | ------------------------------------ |
| `status: triage` | Needs initial review |
| `status: in progress` | Linked PR is open and active |
| `status: done` | Linked PR merged |

When a linked PR merges, `sync-issue-status-from-pr` both applies `status: done` and
closes the issue if it's still open, so the label and lifecycle state cannot drift apart.

This template ships only the `status:*` lifecycle labels plus `no-issue-needed` and
`linked-issue` (see `.github/workflows/auto-label-prs.yml`). If the project later adopts
an area/category/type label taxonomy, extend this section and the corresponding
auto-labeling workflow together so the docs stay accurate.

## PR Issue Link and Closing Keywords

PRs should reference a linked issue in the description. Prefer `Refs #N` by default. Use
closing keywords only when `#N` is confirmed to be an issue, not a pull request.

```text
Refs #7
Closes #123  (issue only)
Fixes #42    (issue only)
```

For multiple issues, repeat the keyword per issue — `Fixes #1, Fixes #2` — or put one
reference per line. GitHub only closes the issue immediately following the keyword; a bare
comma-separated list (`Fixes #1, #2, #3`) closes only `#1`, leaving the rest open even
though the PR merged. `.github/workflows/check-pr-issue-link.yml` fails the PR if it
detects this pattern.

If no backing issue exists, check the **No linked issue** box in the PR template and state
a brief reason (hotfix, chore, dependency bump, etc.). Bot-authored PRs are exempt
automatically.

## Comment Body Safety (Required)

When posting or updating issue/PR comments from terminal commands, always use real
multiline Markdown bodies and verify the stored comment text immediately.

1. Build the body with real newlines.
2. Prefer writing it to a file and passing it with `--body-file`.
3. If you must use a variable, use a PowerShell here-string (or bash heredoc) with real
   newlines — never an inline string with escaped `\n`.
4. Verify the stored body immediately: `gh api ... --jq .body` or `gh issue view --json body`.
5. If malformed (escaped newlines, control-character artifacts), patch the same comment in
   place — don't post a replacement duplicate.

```powershell
$commentPath = Join-Path $env:TEMP "gh-comment-body.md"
$body = @'
## Update

- Item one
- Item two
'@

Set-Content -Path $commentPath -Value $body -Encoding utf8
gh issue comment 123 --body-file "$commentPath"

# Verify final stored body
gh issue view 123 --comments
```

## Tips

- Confirm the repository context before creating issues (`gh repo view`).
- Ask for missing critical information rather than guessing.
- Link related issues when known: `Related to #123`.
- For updates, fetch the current issue first to preserve unchanged fields.
