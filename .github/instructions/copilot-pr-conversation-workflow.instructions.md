---
description: >
  Defines the required workflow for handling GitHub PR review conversations end-to-end:
  review each conversation, apply fixes, commit with traceability, reply in-thread with
  commit reference, and resolve the conversation.
applyTo: '**'
---

# Copilot PR Conversation Workflow

Use this workflow whenever asked to process PR conversations, review threads, or comments,
including prompts such as:

- "review each conversation"
- "fix each conversation"
- "comment each conversation thread"
- "resolve the conversation"

## Required Sequence

1. Discover unresolved review conversations on the active PR.
2. For each conversation thread, determine whether code/docs changes are needed.
3. Implement only the required change for that thread.
4. Commit with traceability:
   - Prefer one commit per conversation when practical.
   - If multiple threads require tightly related edits, group them in a single commit.
   - Use a commit message that references the thread topic or concern.
5. Reply in the same conversation thread with:
   - What changed
   - Why it addresses the feedback
   - The commit SHA (or SHAs) containing the fix
6. Resolve the conversation only after the thread reply is posted and the fix is committed.
7. Repeat until all intended conversations are addressed.

## Thread Reply Requirements

Each in-thread reply should include:

- A concise summary of the change
- A direct commit reference (full or short SHA)
- Any important caveat (if partially addressed)

If a thread cannot be fully addressed, do not resolve it. Reply with blocker details and
next action.

## Operational Rules

- Prefer GitHub CLI (`gh`) for thread replies/resolution in local VS Code sessions.
- If an API path/tool returns permission errors (for example 403), immediately use `gh`
  CLI fallback for replies.
- Do not post only a top-level PR summary when the request asks for conversation handling;
  replies must be in-thread.

## Verification Checklist

- [ ] All targeted conversations received in-thread replies
- [ ] Each reply references the relevant commit SHA
- [ ] Each resolved thread is actually marked resolved on the PR
- [ ] Any unresolved thread has an explicit blocker comment

## Commit Message Templates

Use one of these templates so a commit can be traced back to a conversation quickly.

Preferred single-thread format:

```text
fix(pr-thread): <path or topic> - <short action>
```

Examples:

```text
fix(pr-thread): scripts/lint-docs - handle empty markdown set
fix(pr-thread): README install step - clarify pwsh requirement
docs(pr-thread): contributing guide - add branch naming example
test(pr-thread): docs lint task - cover windows path case
```

When one commit intentionally addresses multiple tightly related threads:

```text
fix(pr-threads): <shared topic> - address related review feedback
```

Body template (optional but recommended):

```text
Addresses PR review thread(s):
- <thread topic 1>
- <thread topic 2>

Why:
- <brief rationale>
```

Avoid generic messages such as `fix feedback` or `update files`; the subject should make
the conversation reason obvious without opening the diff.

## Ready-To-Run GH CLI Playbook

Use this sequence in local VS Code sessions when processing review conversations.

### 1. Identify Active PR And Unresolved Threads

```powershell
# Confirm current branch and active PR
$branch = git branch --show-current
$prNumber = [int](gh pr view --json number --jq '.number')

# List unresolved review threads (id + path + line + first comment)
$query = @'
query($owner:String!, $repo:String!, $number:Int!) {
  repository(owner:$owner, name:$repo) {
    pullRequest(number:$number) {
      reviewThreads(first:100) {
        nodes {
          id
          isResolved
          path
          line
          comments(first:1) {
            nodes { body author { login } }
          }
        }
      }
    }
  }
}
'@

$repoInfo = gh repo view --json owner,name | ConvertFrom-Json
$owner = $repoInfo.owner.login
$repo = $repoInfo.name

$result = gh api graphql -f query="$query" -F owner="$owner" -F repo="$repo" -F number=$prNumber | ConvertFrom-Json
$threads = $result.data.repository.pullRequest.reviewThreads.nodes | Where-Object { -not $_.isResolved }
$threads | Select-Object id,path,line,@{Name='comment';Expression={$_.comments.nodes[0].body}} | Format-Table -AutoSize

# Note: reviewThreads(first:100) returns at most 100 threads per request.
# For very large PRs, paginate with pageInfo{hasNextPage,endCursor} and after:<cursor>
# until all unresolved threads are collected.
```

### 2. Fix One Thread At A Time (Prefer One Commit Per Thread)

```powershell
# After making code/doc changes for one thread:
git add -A
git commit -m "fix(pr-thread): address <short thread topic>"

# Capture commit SHA for thread reply text
$sha = git rev-parse --short HEAD
Write-Output "Committed: $sha"
```

### 3. Reply In The Same Thread With Commit Reference

```powershell
# Prepare multiline reply in a file (avoid inline escaped newlines)
$threadId = "<REVIEW_THREAD_NODE_ID>"
$bodyPath = ".tmp/thread-reply-$threadId.md"
New-Item -ItemType Directory -Force -Path ".tmp" | Out-Null

@"
Addressed in commit $sha.

Summary:
- <what changed>
- <why this resolves feedback>
"@ | Set-Content -Encoding utf8 $bodyPath

$replyBody = Get-Content -Raw $bodyPath

$replyMutation = @'
mutation($threadId:ID!, $body:String!) {
  addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:$threadId, body:$body}) {
    comment { id url }
  }
}
'@

gh api graphql -f query="$replyMutation" -F threadId="$threadId" -f body="$replyBody"
```

### 4. Resolve The Thread After Reply Is Posted

```powershell
$resolveMutation = @'
mutation($threadId:ID!) {
  resolveReviewThread(input:{threadId:$threadId}) {
    thread { id isResolved }
  }
}
'@

gh api graphql -f query="$resolveMutation" -F threadId="$threadId"
```

### 5. Verify No Intended Threads Were Missed

```powershell
$result = gh api graphql -f query="$query" -F owner="$owner" -F repo="$repo" -F number=$prNumber | ConvertFrom-Json
$result.data.repository.pullRequest.reviewThreads.nodes |
  Select-Object id,isResolved,path,line |
  Format-Table -AutoSize

# If your PR can exceed 100 review threads, run this verification over paginated results.
```

If any thread remains unresolved intentionally, leave a blocker reply and keep it open.
