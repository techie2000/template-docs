# Work Template Docs

This repository is a reusable template for documentation-first projects.

Use it as a starting point for collecting vendor documentation, internal notes,
and operational references for the software or service being documented.

## Structure

| Folder | Purpose |
| ------ | ------- |
| [docs/](docs/) | Documentation index for the docs area and subfolders |
| [docs/vendor/](docs/vendor/) | Vendor-supplied documentation, manuals, and reference material |
| [docs/internal/](docs/internal/) | Internal notes, decisions, and meeting records |
| [images/](images/) | Supporting screenshots and diagrams |

## Tooling

| File/Folder | Purpose |
| ----------- | ------- |
| [.githooks/](.githooks/) | Git hook scripts used for pre-commit and pre-push validation |
| [scripts/](scripts/) | Utility scripts used by hooks (settings/extensions/word-list sorting) |
| [.markdownlint.yaml](.markdownlint.yaml) | Shared markdownlint rule configuration used by the pre-commit hook |
| [Makefile](Makefile) | Optional shortcuts for hook setup, sorting, and docs linting |

## Quick Start

```bash
make install-hooks
make settings-sort
make lint-docs
```

## Repository Customization Checklist

1. Replace this README with project-specific context.
2. Add or update files in [docs/vendor/](docs/vendor/) and [docs/internal/](docs/internal/).
3. Add screenshots/diagrams under [images/](images/).
4. Update [.vscode/extensions.json](.vscode/extensions.json) recommendations if needed.
5. Add project-specific words to `*-words.txt` files in [.vscode/](.vscode/).
6. Register each new word list under `cSpell.customDictionaries` in [.vscode/settings.json](.vscode/settings.json).
