param(
    [string]$SettingsPath = ".vscode/settings.json",
    [switch]$CheckOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$sorterScript = Join-Path $PSScriptRoot "sort-vscode-settings.ps1"
$params = @{ SettingsPath = $SettingsPath }
if ($CheckOnly) {
    $params.CheckOnly = $true
}

& $sorterScript @params
exit $LASTEXITCODE
