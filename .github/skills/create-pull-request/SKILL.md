---
name: create-pull-request
description: >
  Create a GitHub Pull Request with correct issue linkage and a verification
  checklist. Encodes the repo's PR hygiene expectations: closing-keyword
  correctness for multi-issue links, issue-reference conventions, and
  verification before requesting review.
argument-hint: >
  Optionally specify a title, base branch, or whether to create as a draft
---

# Create a GitHub Pull Request

Prepare PR metadata, create the pull request, and confirm the automated label
and status-sync workflows have picked it up correctly.

## When to Use

- The user wants to open a PR for their current or a specified branch
- The user has finished a feature or fix and wants to submit it for review
- The user wants to create a draft PR to share work in progress
- The user asks to "open a PR", "create a pull request", or "submit for review"

## Procedure

### 1. Gather Information

- **Head branch**: If not specified, use the current git branch (`git branch --show-current`).
- **Base branch**: If not specified, omit it and let `gh pr create` use the repository's
  default branch.
- **Title**: If not provided, derive one from the branch name or recent commits. Use
  imperative mood, under 72 characters (e.g., `Add retry logic for failed API requests`).
- **Body**: If not provided, prepare a concise summary of what changed and why, following
  `.github/pull_request_template.md` if the repository has one.
- **Draft**: Default to non-draft unless the user indicates the work is not ready for review.

### 2. Check for Uncommitted or Unpushed Changes

Before creating the PR:

1. `git status` — if there are staged or unstaged changes, ask the user to commit them or
   confirm they belong in a later commit.
2. Check for unpushed commits on the branch; push before creating the PR if needed.
3. The head branch must exist on the remote before `gh pr create` will work.

### 3. Prepare PR Details

**Body** should include:

- A short summary of what changed and why.
- Any relevant issue references (e.g., `Fixes #123`, `Refs #123`).
- **For multiple issues, repeat the keyword per issue** — `Fixes #1, Fixes #2`, not
  `Fixes #1, #2`. GitHub only closes the issue immediately after the keyword; it does not
  apply the keyword across a comma-separated list, so trailing issues would stay open even
  though the PR merged. This repo's `check-pr-issue-link` workflow fails the PR if it
  detects the incorrect form.
- Notable implementation decisions if useful for the reviewer.

If the repo has no backing issue for this PR, check the `No linked issue` box in the PR
template body and give a brief reason (hotfix, chore, dependency bump, etc.).

### 4. Create the PR

```bash
gh pr create --title "<title>" --body-file <path-to-body.md> [--base <base>] [--draft]
```

Capture the PR URL and number from the output.

### 5. Confirm Automated Labeling and Status Sync

**Do not manually apply labels or issue-status changes in this repo** — they are handled by
CI:

- `.github/workflows/auto-label-prs.yml` applies `linked-issue` or `no-issue-needed` based
  on the PR body.
- `.github/workflows/sync-issue-status-from-pr.yml` moves linked issues through
  `status: triage` → `status: in progress` → `status: done`, and closes the issue once it
  reaches `status: done` if it's still open.

After creating the PR, confirm these workflows ran (`gh pr checks <pr-number>`) and that the
expected labels landed (`gh pr view <pr-number> --json labels`). If this project later adds
its own category/area label taxonomy, extend this step to apply those labels too.

### 6. Request Reviewer (If Applicable)

If the repository has a `CODEOWNERS` file or a documented default-reviewer convention,
request review accordingly:

```bash
gh pr edit <pr-number> --add-reviewer <reviewer-or-team>
```

If no such convention exists, skip this step.

### 7. Post a Verification Checklist

Post a concise, project-appropriate checklist as a PR comment, tailored to what actually
changed (tests added/updated, build/lint passes, docs updated, no regressions). Adjust the
specifics to the language/stack of the changed files — don't invent checklist items that
don't apply to this change.

```bash
gh pr comment <pr-number> --body-file <path-to-checklist.md>
```

---

## Best Practices

1. **Imperative title**: "Add X", "Fix Y", "Update Z".
2. **Link issues early**: Use `Fixes #123` or `Refs #123` in the body.
3. **Explain the why**: Not just what changed, but why.
4. **Repeat closing keywords per issue** when linking more than one.

---

## See Also

- `.github/copilot-instructions.md` — PR/Issue linkage guardrails and enforcement mode.
- `.github/instructions/copilot-pr-conversation-workflow.instructions.md` — reviewing and
  addressing feedback once the PR is open (see also `address-pr-comments`).
- `.github/instructions/github-issue-management.instructions.md` — duplicate-issue handling.
