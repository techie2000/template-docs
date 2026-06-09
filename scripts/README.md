# Scripts

This folder contains helper scripts for local repository tooling.

## Script Index

| Script | Shell | Purpose |
| ------ | ----- | ------- |
| `bootstrap-package-name.ps1` | PowerShell | Rewrites placeholder `package.json` name to a sanitized repository directory name. |
| `bootstrap-package-name.sh` | Bash | Rewrites placeholder `package.json` name to a sanitized repository directory name. |
| `install-hooks.ps1` | PowerShell | Configures `core.hooksPath` to `.githooks`. |
| `install-hooks.sh` | Bash | Configures `core.hooksPath` to `.githooks` and applies executable bits when available. |
| `lint-docs.ps1` | PowerShell | Runs markdownlint-cli2 using `.markdownlint.yaml`; supports optional fix mode. |
| `lint-docs.sh` | Bash | Runs markdownlint-cli2 using `.markdownlint.yaml`; supports optional fix mode. |
| `PSScriptAnalyzerSettings.psd1` | PowerShell | Shared PSScriptAnalyzer settings used to enforce approved PowerShell verbs. |
| `settings-sort.ps1` | PowerShell | Wrapper for `sort-vscode-settings.ps1`; supports `-CheckOnly`. |
| `settings-sort.sh` | Bash | Wrapper that delegates to `sort-vscode-settings.ps1` via `pwsh`. |
| `sort-vscode-settings.ps1` | PowerShell | Canonical JSON key sorter for `.vscode/settings.json`; used by git hooks. |

## Common Usage

PowerShell:

```powershell
make init
pwsh ./scripts/install-hooks.ps1
pwsh ./scripts/settings-sort.ps1
pwsh ./scripts/bootstrap-package-name.ps1
pwsh ./scripts/lint-docs.ps1
pwsh ./scripts/lint-docs.ps1 -Fix
```

Bash:

```bash
make init
bash ./scripts/install-hooks.sh
bash ./scripts/settings-sort.sh
bash ./scripts/bootstrap-package-name.sh
bash ./scripts/lint-docs.sh
bash ./scripts/lint-docs.sh --fix
```

For repos created from this template, run `make init` once after cloning.
Git local config (`.git/config`) is not version-controlled, so hook setup must
be applied per clone.

Invoke `.sh` helpers through `bash` rather than relying on the executable bit.
That keeps script execution reliable in agent-driven and cross-platform checkouts
where file mode metadata may not be preserved.

## Notes

- `sort-vscode-settings.ps1` is intentionally PowerShell-only because git hooks call it directly.
- `PSScriptAnalyzerSettings.psd1` is used by the GitHub Actions PowerShell lint workflow to enforce `PSUseApprovedVerbs`.
- The `.ps1`/`.sh` helper pairs are maintained for cross-platform script parity.
