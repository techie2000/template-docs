---
description: >
  Formalizes when and how to keep README.md synchronized with repository structure changes.
  README.md must serve as the primary human entrypoint for the repository and accurately reflect
  stable top-level folders and critical root-level workflow files.
applyTo: '**'
---

# README Structure Maintenance

Use this instruction to keep repository README files accurate as the codebase evolves.

## Scope

Track these files:

- `README.md` (root)
- `docs/README.md`
- `docs/internal/README.md`
- `docs/vendor/README.md`
- Other subdirectory README files as applicable

## Purpose

README.md serves as the primary human entrypoint for the repository. It must:

- List all stable top-level folders that contributors navigate directly
- Include critical root-level workflow files that contributors interact with
- Provide a clear mental model of repository structure and purpose
- Act as a landing page before exploring `.github/` configuration or detailed docs

## Required Updates

### When Folders Change

Update README.md in the same PR when:

1. A top-level folder is added, removed, or renamed
2. A folder's purpose changes significantly (e.g., from "placeholder" to "active")
3. A folder is moved to a different top-level location
4. Ownership boundaries or responsibility areas shift between folders

### When Key Files Change

Update relevant README sections when:

1. New root-level workflow files are added (e.g., new Makefile target, new root config file)
2. Existing root-level files are removed or renamed
3. Critical config files change their scope or purpose (e.g., a `.vscode/` setting becomes permanent vs. temporary)

### What to Update

- **Structure table**: Add/remove/rename rows to match actual folder structure
- **Tooling table**: Add/remove root-level files and `.github/` entries as applicable
- **Descriptions**: Keep purpose statements in sync with actual folder usage
- **Links**: Ensure all folder and file links are correct and point to existing resources

## Best Practices

### Deterministic Ordering

Use consistent ordering so README diffs remain small:

1. Keep top-level folders in functional order: `docs`, `src`, `test`, `scripts`, then tooling/config sections
2. Within each section, maintain alphabetical order unless a functional sequence is required
3. Keep root-level files grouped by purpose (source, tooling, config)

### Subdirectory README Pattern

Each subdirectory README must:

- Describe the purpose of that directory
- List its own subdirectories or key files
- Link to related documentation or guidelines
- Not duplicate information from parent README or upper-level docs

Example structure:
- `docs/README.md` → high-level docs layout
- `docs/internal/README.md` → what belongs in internal docs
- `docs/vendor/README.md` → what belongs in vendor docs

### What NOT to Include in README

- Deep per-file inventories (not a file tree listing)
- Detailed implementation details
- Changeable transient files or temporary outputs
- Hidden configuration that contributors rarely touch

## Coordination with Other Instructions

When updating README.md for structure changes:

1. Also update Ilograph sources in `docs/diagrams/workspace-overview.ilograph.yaml` in the same change (enforced by `ilograph-sync.instructions.md`)
2. Ensure any referenced instruction files exist and are correctly formatted
3. Run `make lint-docs` before committing markdown changes (enforced by `copilot-instructions.md`)

## Verification Checklist

Before finalizing a README change:

- [ ] All top-level folders in the repository are listed
- [ ] All critical root-level workflow files are listed
- [ ] Links to listed folders/files are correct and not broken
- [ ] Descriptions match actual folder/file purpose
- [ ] Ordering is deterministic and matches the pattern for this repo
- [ ] Related README files in subdirectories have been updated if applicable
- [ ] Ilograph sources have been updated (if structure changed)
- [ ] `make lint-docs` passes without errors
