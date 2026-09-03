---
name: diagrams
description: >
  Author and maintain Mermaid and Ilograph diagrams for this repo - format
  choice, Mermaid syntax conventions, and color scheme for dark mode.
tools: []
target: vscode
---

# Diagram Standards

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

## Mermaid Best Practices

### Mermaid Label Line Break Rule (REQUIRED)

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

## Why Mermaid?

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

## Color Scheme for Dark Mode

Use medium-saturation colors that work in both light and dark modes:

```yaml
services/components: "#2C5F8D" (medium blue) with white text
processing/intermediate: "#17A2B8" (teal) with white text
success/output: "#28A745" (medium green) with white text
errors/validation: "#D9534F" (medium red) with white text
warnings/DLQ: "#F0AD4E" (medium orange) with dark text
backgrounds: "#555" (dark gray) with white text
```
