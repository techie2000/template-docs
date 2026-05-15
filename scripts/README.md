# Scripts

This folder contains helper scripts for local repository tooling.

## Script Index

| Script | Shell | Purpose |
| ------ | ----- | ------- |
| `install-hooks.ps1` | PowerShell | Configures `core.hooksPath` to `.githooks`. |
| `install-hooks.sh` | Bash | Configures `core.hooksPath` to `.githooks` and applies executable bits when available. |
| `lint-docs.ps1` | PowerShell | Runs markdownlint-cli2 using `.markdownlint.yaml`; supports optional fix mode. |
| `lint-docs.sh` | Bash | Runs markdownlint-cli2 using `.markdownlint.yaml`; supports optional fix mode. |
| `settings-sort.ps1` | PowerShell | Wrapper for `sort-vscode-settings.ps1`; supports `-CheckOnly`. |
| `settings-sort.sh` | Bash | Wrapper that delegates to `sort-vscode-settings.ps1` via `pwsh`. |
| `sort-vscode-settings.ps1` | PowerShell | Canonical JSON key sorter for `.vscode/settings.json`; used by git hooks. |

## Common Usage

PowerShell:

```powershell
pwsh ./scripts/install-hooks.ps1
pwsh ./scripts/settings-sort.ps1
pwsh ./scripts/lint-docs.ps1
pwsh ./scripts/lint-docs.ps1 -Fix
```

Bash:

```bash
./scripts/install-hooks.sh
./scripts/settings-sort.sh
./scripts/lint-docs.sh
./scripts/lint-docs.sh --fix
```

## Notes

- `sort-vscode-settings.ps1` is intentionally PowerShell-only because git hooks call it directly.
- The `.ps1`/`.sh` helper pairs are maintained for cross-platform script parity.
