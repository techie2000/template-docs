# Work Template Docs

This repository is a reusable template for documentation-first projects.

Use it as a starting point for collecting vendor documentation, internal notes,
and operational references for the software or service being documented.

## Structure

| Folder | Purpose |
| ------ | ------- |
| [docs/](docs/) | Documentation index for the docs area and subfolders |
| [docs/internal/](docs/internal/) | Internal notes, decisions, and meeting records |
| [docs/vendor/](docs/vendor/) | Vendor-supplied documentation, manuals, and reference material |
| [images/](images/) | Supporting screenshots and diagrams |

## Tooling

| File/Folder | Purpose |
| ----------- | ------- |
| [.githooks/](.githooks/) | Git hook scripts used for pre-commit and pre-push validation |
| [.github/instructions/](.github/instructions/) | Repository instructions used by Copilot and other tooling |
| [.github/workflows/](.github/workflows/) | GitHub Actions workflows used for automated repository validation |
| [scripts/](scripts/) | Utility scripts used by hooks (settings/extensions/word-list sorting) |
| [.markdownlint.yaml](.markdownlint.yaml) | Shared markdownlint rule configuration used by the pre-commit hook |
| [Makefile](Makefile) | Optional shortcuts for hook setup, sorting, and docs linting |

## Quick Start

```bash
make init
make lint-docs
```

`make init` is the recommended first-run bootstrap command. It configures Git
hooks (`core.hooksPath=.githooks`) and normalizes VS Code workspace files.

Git does not allow a repository template to enforce local `.git/config` values
automatically, so this bootstrap step must be run once per cloned/generated
repository.

## PowerShell Guidance

When adding or editing PowerShell in repositories created from this template:

- Use only approved PowerShell verbs for function names.
- Treat `PSScriptAnalyzer` rule `PSUseApprovedVerbs` as a required check for new or edited PowerShell code.
- Review `.github/instructions/powershell-approved-verbs.instructions.md` for the repository instruction used by Copilot.
- The repository includes `scripts/PSScriptAnalyzerSettings.psd1` and `.github/workflows/powershell-lint.yml` to validate PowerShell scripts in GitHub Actions.

## Repository Customization Checklist

1. Replace this README with project-specific context.
2. Add or update files in [docs/vendor/](docs/vendor/) and [docs/internal/](docs/internal/).
3. Add screenshots/diagrams under [images/](images/).
4. Update [.vscode/extensions.json](.vscode/extensions.json) recommendations if needed.
5. Add project-specific words to `*-words.txt` files in [.vscode/](.vscode/).
6. Register each new word list under `cSpell.customDictionaries` in [.vscode/settings.json](.vscode/settings.json).
7. If you add PowerShell automation, keep `scripts/PSScriptAnalyzerSettings.psd1` aligned with your linting policy and ensure the GitHub Actions workflow still covers your PowerShell files.
