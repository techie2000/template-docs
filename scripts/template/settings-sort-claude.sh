#!/usr/bin/env sh
set -eu

if ! command -v pwsh >/dev/null 2>&1; then
  echo "pwsh not found. Install PowerShell 7+ to sort .claude/settings.json."
  exit 1
fi

pwsh -NoProfile -ExecutionPolicy Bypass -File ./scripts/template/sort-vscode-settings.ps1 -SettingsPath .claude/settings.json "$@"
