# GitHub Copilot Configuration for Work Template Docs

This repository uses GitHub Copilot custom instructions, agents, and prompts to maintain code quality and consistency.
The configuration has been tailored specifically for this repository.

## Repository Structure

```text
.github/
├── agents/           # Specialized AI assistants for specific workflows
├── instructions/     # Coding standards and best practices (language/framework-specific)
├── prompts/          # Reusable prompt templates for common tasks
├── skills/           # Domain-specific knowledge modules
└── workflows/        # GitHub Actions for automation
```text

## Special Instructions

### README Structure Maintenance (REQUIRED)

When a change adds, removes, renames, or repurposes folders or significant files,
update the repository structure sections in `README.md` in the same change.

Follow:

- `.github/instructions/readme-structure-maintenance.instructions.md`

### Ilograph Diagram Sync (REQUIRED)

When a change updates repository structure, significant files, or runtime flow,
update Ilograph sources in `docs/diagrams/` in the same change to avoid drift.

Keep `workspace-overview.ilograph.yaml` deterministic as files evolve:

- Keep top-level sections in functional order (`docs`, `src`, `test`, `scripts`, then tooling/config).
- Keep nested children alphabetized unless explicit runtime flow ordering is needed.
- Keep relations grouped in a consistent sequence (tasks/hooks, CI, governance).

Follow:

- `.github/instructions/ilograph-sync.instructions.md`

### PR Conversation Handling (REQUIRED)

When asked to process PR conversations/review threads end-to-end, follow:

- `.github/instructions/copilot-pr-conversation-workflow.instructions.md`

This covers the required flow to review each thread, apply fixes, commit with traceability,
reply in-thread with commit references, and resolve each conversation.

### Markdown Compliance Gate (REQUIRED)

When an agent edits any `*.md` file, it must run this loop before commit or PR update:

1. `make lint-docs-fix`
2. `make lint-docs`
3. If lint still fails, fix remaining issues and rerun `make lint-docs` until clean

Rules:

- Do not commit markdown changes while markdown lint is failing.
- Treat markdown lint failures as blocking, not advisory.

### Commit Failure Recovery (REQUIRED)

If a commit fails because pre-commit checks fail, agents must automatically attempt remediation
before asking the user for manual fixes.

Required flow:

1. Run `make lint-docs-fix`.
2. Run `make lint-docs`.
3. Stage any markdown changes made by auto-fixes.
4. If failure is from VS Code settings ordering, run `make settings-sort` and stage
  `.vscode/settings.json`.
5. Retry the commit operation.

Rules:

- Do not stop at "lint failed" when auto-fix commands are available.
- Only escalate to manual intervention after auto-fix + recheck still fails.

## Temporary and Diagnostic Output File Placement (REQUIRED)

When running commands or scripts that produce log files, timing files, build output, or any other
transient diagnostic files, **never write them to the repository root**.

Rules:

- Always redirect output to `.tmp/` at the repository root (e.g., `.tmp/backend_build.log`,
  `.tmp/migration-run-20260409.log`).
- The `.tmp/` directory is already in `.gitignore` and will not be committed.
- Patterns like `*_timing.txt`, `*_build.log`, `migration-run-*.log`, and `tmp_*.log` are also
  gitignored as a safety net, but prefer `.tmp/` placement over relying on the safety net.
- If a script or `make` target currently writes to the repo root, update it to write to `.tmp/`
  in the same change.

Example:

```powershell
$outDir = Join-Path (git rev-parse --show-toplevel) ".tmp"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
go build ./... 2>&1 | Tee-Object "$outDir/backend_build.log"
```

## Markdown Authoring Guardrail (REQUIRED)

When creating or editing markdown files, use the `markdownlint` rules defined in
`.markdownlint.yaml` to ensure consistent formatting and style:

1. Before pushing, run `make lint-docs-fix` then `make lint-docs`; if lint still fails, fix manually until clean.

### Diagram Standards (REQUIRED)

**Prescribe both Mermaid and Ilograph where they each fit best.**

- **Mermaid for inline docs**: Keep diagrams embedded in markdown so they render
  directly in GitHub and VS Code without extra tooling.
- **Ilograph for deep-dive architecture**: Use `docs/diagrams/*.ilograph.yaml`
  when interactive exploration and richer multi-perspective views improve
  understanding.
- **Keep both in sync** when a markdown Mermaid view and an Ilograph view describe
  the same structure or runtime behavior.

- **Format**: Mermaid markdown code blocks
- **Location**: Embedded in README.md, ADRs, or separate `.md` files in `docs/diagrams/`
- **Types**: Use appropriate Mermaid diagram types:
  - `flowchart` - Process flows, decision trees
  - `sequenceDiagram` - API interactions, component communication
  - `classDiagram` - Object models, data structures
  - `erDiagram` - Database schemas, entity relationships
  - `stateDiagram` - State machines, lifecycle flows
  - `gitGraph` - Branching strategies
  - `gantt` - Project timelines

#### Mermaid Best Practices

##### Mermaid Label Line Break Rule (REQUIRED)

When writing multi-line Mermaid node labels:

- Use `<br/>` inside quoted labels.
- Do **not** use escaped newline tokens like `\n` in labels.

Required pre-check before finalizing diagram markdown:

1. Search changed diagram markdown for literal `\n` text.
2. Replace any `\n` label content with `<br/>`.

This prevents visible `\n` artifacts in rendered diagrams in GitHub and VS Code previews.

```markdown
## Example Architecture Diagram

\`\`\`mermaid
flowchart LR
    A[Input] --> B{Decision}
    B -->|Yes| C[Process]
    B -->|No| D[Skip]
    C --> E[Output]

    style A fill:#e1f5ff
    style E fill:#d4edda
    style D fill:#fff3cd
\`\`\`

## Example Sequence Diagram

\`\`\`mermaid
sequenceDiagram
    participant Client
    participant API
    participant DB

    Client->>API: POST /users
    API->>DB: INSERT user
    DB-->>API: Success
    API-->>Client: 201 Created
\`\`\`

## Example State Diagram

\`\`\`mermaid
stateDiagram-v2
    [*] --> New
    New --> Processing: Submit
    Processing --> Completed: Success
    Processing --> Failed: Error
    Failed --> Processing: Retry
    Completed --> [*]
\`\`\`
```

#### Why Mermaid?

- ✅ **Version Control**: Text-based diagrams tracked in Git
- ✅ **Collaboration**: Easy to review and update in PRs
- ✅ **Rendering**: Works in GitHub, VS Code, and most documentation tools
- ✅ **No Binary Files**: Avoid binary image files that cause merge conflicts
- ✅ **Consistency**: Standardized syntax across all diagrams
- ✅ **Maintainability**: Update diagrams as code changes

**DO NOT** use:

- ❌ Binary image files (PNG, JPG) for architecture diagrams
- ❌ External diagram tools (draw.io, Visio) unless absolutely necessary
- ❌ ASCII art (hard to read and maintain)
- ❌ External hosting (links break, requires external accounts)

#### Color Scheme for Dark Mode

Use medium-saturation colors that work in both light and dark modes:

```yaml
services/components: "#2C5F8D" (medium blue) with white text
processing/intermediate: "#17A2B8" (teal) with white text
success/output: "#28A745" (medium green) with white text
errors/validation: "#D9534F" (medium red) with white text
warnings/DLQ: "#F0AD4E" (medium orange) with dark text
backgrounds: "#555" (dark gray) with white text
```
