---
description: >
  Requires every script in scripts/template/ to have counterparts for both Bash (.sh) and
  PowerShell (.ps1) unless the script is explicitly documented as intentionally
  platform-specific (e.g. git-hook utilities that mandate pwsh).
applyTo: 'scripts/**'
---

# Script Shell Parity

## Rule

Every script added to `scripts/template/` **must ship with a counterpart in the other shell
flavour** in the same commit/PR:

| New file | Required counterpart |
| -------- | -------------------- |
| `scripts/template/foo.sh` | `scripts/template/foo.ps1` |
| `scripts/template/foo.ps1` | `scripts/template/foo.sh` |

## Rationale

The project runs on Windows (PowerShell 7+ / `pwsh`) and on Linux/macOS CI runners
(bash).  Scripts that exist only for one platform block developers on the other and
break `make` targets that try to detect the available shell.

## Known intentional exceptions

The following scripts are **intentionally single-shell only**; no counterpart in
the other shell flavour is expected:

| Script | Reason |
| ------ | ------ |
| `scripts/template/sort-vscode-settings.ps1` | PowerShell-only - the project's `.githooks` call it directly and mandate `pwsh`. No bash counterpart. |
| `scripts/template/settings-sort-claude.sh` | Bash-only - bridges bash environments to the PowerShell-only `sort-vscode-settings.ps1` above by checking for `pwsh` before invoking it. The Windows branch of `make settings-sort-claude` calls `sort-vscode-settings.ps1` directly (not this script); a `.ps1` counterpart to this bash wrapper would just duplicate that same call with no functional difference. No PowerShell counterpart. |

If you add a new script that is intentionally platform-specific, add a row to the
table above with a clear justification and get it reviewed in the PR.

## Checklist (apply when adding or reviewing scripts)

- [ ] Both `.sh` and `.ps1` variants exist for the new script
- [ ] Both variants implement functionally equivalent flags / exit codes and comparable output messages
- [ ] `Makefile` references both (using the `ifeq ($(OS),Windows_NT)` or
  `command -v bash / pwsh` detection pattern already in the file)
- [ ] Any new exception is documented in the table above
