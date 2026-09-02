---
name: check-template-updates
description: >
  Manually trigger the check-template-updates workflow to detect drift
  between this repo and its upstream template, then interpret and act on
  the resulting tracking issue and/or draft sync PR.
---

# Check Template Updates

Trigger an on-demand template drift check and work through the results —
this repo's copy of `.github/workflows/check-template-updates.yml` also runs
automatically every Monday 09:00 UTC, so this skill is for "check now" and
for following up on either the scheduled or manual run's output.

## When to Use

- User asks to check for template drift/updates, "are we behind the
  template", "sync with the template", or "run the template check".
- Following up on an existing `template-sync`-labeled tracking issue or
  draft PR to decide what to adopt.

## Background

- Workflow: `.github/workflows/check-template-updates.yml`.
- Compares this repo (`current`) against `template_repo`/`template_ref`
  (default `techie2000/template-docs@main`), configured via
  `workflow_dispatch` inputs or `.github/template-sync.yml`. Inputs override
  the committed file; leave them blank to use the repo's own configuration.
- Only compares the `SYNC_PATHS` allow-list baked into the workflow —
  `.claude`, `.github/workflows`, `.github/instructions`, `.github/skills`,
  `.github/pull_request_template.md`, `AGENTS.md`, `CLAUDE.md`, `scripts`,
  `docs/internal`, etc. — not `README.md`, top-level `docs/`, or
  product/application code.
- Real 3-way classification (safe-adopt / auto-merge / conflict / local
  divergence) requires `baseline_ref` in `.github/template-sync.yml`.
  Without it, every difference shows up as "changed" in snapshot mode with
  no classification.

## Procedure

### 1. Check baseline configuration

```bash
cat .github/template-sync.yml
```

If `baseline_ref` is blank, tell the user snapshot mode will be noisy and
offer to set it once (see step 6) to the template commit this repo was
created or last synced from.

### 2. Trigger the workflow

```bash
gh workflow run check-template-updates.yml
# with overrides, e.g.:
gh workflow run check-template-updates.yml -f create_sync_pr=true -f generate_ai_suggestions=true
```

Defaults: `create_issue=true`, `create_sync_pr=false`, `generate_ai_suggestions=false`.

Before passing `create_sync_pr=true`, confirm the target repo has "Allow
GitHub Actions to create and approve pull requests" enabled (Settings >
Actions > General > Workflow permissions) — it cannot be set via the API
and the `create-sync-pr` job fails without it:

```bash
gh api repos/{owner}/{repo}/actions/permissions/workflow --jq .can_approve_pull_request_reviews
```

### 3. Watch the run

```bash
gh run list --workflow=check-template-updates.yml -L 1
gh run watch <run-id>
```

### 4. Retrieve the results

```bash
gh issue list --label template-sync --state open
gh pr list --label template-sync --state open --head chore/template-sync-auto-adopt
```

Read the report body posted to the issue (or appended as a comment if an
open tracking issue already existed). It groups differences into: New Files
in Template, Snapshot Changed (no baseline), Safe Adopt Candidates,
Auto-Merge Candidates, Manual Review Conflicts, Local Divergence, and
Baseline Gap.

### 5. Act per category

- **New Files / Safe Adopt / Auto-Merge** — already materialized into the
  draft PR if `create_sync_pr=true` was used. Review the diff, run this
  repo's tests/lint, and merge when satisfied. If no draft PR was
  requested, cherry-pick the files manually from the template repo.
- **Manual Review Conflicts** — no automated patch exists (the 3-way merge
  failed). Diff local vs. template vs. baseline for the file and resolve by
  hand. If `generate_ai_suggestions=true` was passed, advisory merge
  guidance is appended to the issue/report under "AI-Assisted Conflict
  Suggestions" — treat it as a starting point, not a patch to apply blindly.
- **Local Divergence** — local changed intentionally since baseline while
  the template didn't; usually no action, just confirm it's still
  intentional.
- **Baseline Gap** — `baseline_ref` doesn't have this path, usually meaning
  the baseline is stale; re-baseline (step 6) and re-run.

### 6. Re-baseline after adopting changes

Once changes are merged/reconciled, update `baseline_ref` in
`.github/template-sync.yml` to the template commit just synced to, so the
next run's 3-way diff starts clean:

```bash
git ls-remote upstream <template_ref>
# Fall back to the URL form only if no "upstream" remote points at the template repo yet:
git ls-remote https://github.com/<template_repo>.git <template_ref>
```

Commit the updated `.github/template-sync.yml` in its own change (not
folded into an unrelated PR).

## Notes

- The workflow output is advisory only — never accept safe-adopt or
  auto-merge changes into a merge without reviewing the diff first.
- Re-running with `create_issue=true` (the default) appends a new report to
  the existing open `template-sync` issue rather than creating a duplicate.

## See Also

- `.github/workflows/check-template-updates.yml`
- `.github/template-sync.yml`
