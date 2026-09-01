---
name: address-pr-comments
description: >
  Systematically work through open review feedback on the active pull
  request: categorize it, implement fixes, and post a comprehensive summary
  and linked-issue update once done. Complements the thread-by-thread
  reply/resolve mechanics in copilot-pr-conversation-workflow.instructions.md.
argument-hint: "Optionally specify a reviewer name or file to focus on"
---

# Address PR Review Comments

Read the active pull request, identify unresolved review comments and feedback,
implement the requested changes, then post a categorized summary and mirror the
outcome to any linked issues.

For the mechanics of replying in-thread, referencing commits, and resolving each
conversation, follow
`.github/instructions/copilot-pr-conversation-workflow.instructions.md` — that file is
the required sequence for the thread-by-thread work. This skill covers what wraps
around it: triage, batching, and the end-of-pass summary.

## When to Use

- A reviewer (human or an automated reviewer) has left comments or change requests
  on the active PR.
- You need to systematically work through all open review threads.
- You've fixed reviewer feedback and need to post resolutions and a summary.

## Procedure

### 1. Read the Active PR and Collect Feedback

```bash
gh pr view --json number,body,reviews,comments
```

Collect feedback needing action from:

- Unresolved inline review threads (see the conversation workflow instructions for the
  GraphQL query to list these with `isResolved: false`).
- General PR comments requesting changes.
- Linked issues extracted from the PR body (`Refs #123`, `Fixes #456`) for later updates.

Group related threads by file to handle them efficiently.

### 2. Categorize Feedback

Before implementing, sort comments into rough categories so the summary reads clearly.
Adjust these to fit the project — they're a starting point, not a fixed taxonomy:

- **Correctness** — bugs, edge cases, data integrity
- **Performance** — inefficient patterns, unnecessary work
- **Test Coverage** — missing or insufficient tests
- **Code Quality** — simplification, refactoring, reuse
- **Docs/Config** — formatting, lint, documentation gaps

### 3. Plan and Implement

For each unresolved comment:

1. Read it carefully and understand the concern.
2. Determine the minimal correct fix (not all comments require code changes).
3. Note dependencies between comments (e.g., a rename affecting multiple files).
4. If unclear or contradictory, reply asking for clarification instead of guessing.
5. Follow the reply/commit/resolve sequence in
   `copilot-pr-conversation-workflow.instructions.md` for each thread.

### 4. Track Resolutions

Keep a running list for the summary step:

```text
RESOLVED (4)
- {comment/thread ref} - Correctness - [description]
- {comment/thread ref} - Performance - [description]

DEFERRED (1)
- {comment/thread ref} - Test Coverage - [reason it's deferred]
```

### 5. Post a Comprehensive Summary

Once all threads for this pass are resolved (or explicitly deferred with a blocker
comment per the conversation workflow), post one summary comment on the PR:

```bash
gh pr comment <pr-number> --body-file <path-to-summary.md>
```

Summary template:

```markdown
## Review Feedback: [X] Issues Resolved

### Summary by Category

| Category      | Count | Status | Notes |
|----------------|-------|--------|-------|
| Correctness    | X     | done   | [specific items] |
| Performance    | X     | done   | [specific items] |
| Test Coverage  | X     | deferred | [follow-up plan] |
| Code Quality   | X     | done   | [specific items] |

### Detailed Resolutions

#### Correctness (X resolved)
- **[Issue]**: [what changed and why]

### Validation

- Existing tests pass: `<project test command>`
- [CI checks status]
- No unintended behavior changes

### Follow-Up Items

- **[Issue type]**: Deferred to [future PR/issue] - [why, what's needed]
```

Verify the rendered body immediately: `gh pr view <pr-number> --comments`.

### 6. Mirror Updates to Linked Issues

For each linked issue extracted from the PR body:

```bash
gh issue comment <issue-number> --body-file <path-to-issue-update.md>
```

Issue update template:

```markdown
**Implementation Status**: Feedback addressed

- PR: #<pr-number>
- Branch: `<branch-name>`
- Validation: [tests/CI status]

**What Changed**: [1-2 sentence summary]

**Next Steps**: Awaiting final review before merge.
```

Verify: `gh issue view <issue-number> --comments`.

---

## Best Practices

1. Post individual thread resolutions as each fix is committed; post the comprehensive
   summary once all fixes for the pass are pushed and CI has started.
2. Explain the "why", not just the "what" — link related issues or ADRs if applicable.
3. Keep resolution comments concise (1-3 bullet points per issue).
4. Validate fixes locally before posting resolution comments; wait for initial CI checks
   before posting the comprehensive summary.
5. Follow the comment-body safety rules in
   `.github/instructions/copilot-pr-conversation-workflow.instructions.md` (write
   multiline bodies to a file, verify the stored comment immediately) for every comment
   posted in this workflow.

---

## See Also

- `.github/instructions/copilot-pr-conversation-workflow.instructions.md` — required
  thread-by-thread reply/resolve sequence and comment-body safety rules.
- `.github/instructions/github-issue-management.instructions.md` — duplicate-issue
  handling if feedback surfaces a duplicate.
