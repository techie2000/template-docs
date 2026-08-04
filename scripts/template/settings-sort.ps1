param(
    [string]$SettingsPath = ".vscode/settings.json",
    [string[]]$AdditionalSettingsPaths = @(
        ".vscode/settings.generic.json",
        ".vscode/settings.opinionated.json"
    ),
    [string]$ExtensionsPath = ".vscode/extensions.json",
    [string[]]$WordListPaths = @(),
    [string]$WordListGlob = ".vscode/*-words.txt",
    [switch]$CheckOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$settingsSorterScript = Join-Path $PSScriptRoot "sort-vscode-settings.ps1"
$extensionsSorterScript = Join-Path $PSScriptRoot "sort-vscode-extensions.ps1"
$wordListSorterScript = Join-Path $PSScriptRoot "sort-word-list.ps1"

$commonParams = @{}
if ($CheckOnly) {
    $commonParams.CheckOnly = $true
}

$resolvedSettingsPaths = @($SettingsPath) + $AdditionalSettingsPaths
$resolvedSettingsPaths = @($resolvedSettingsPaths | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)

foreach ($path in $resolvedSettingsPaths) {
    if (Test-Path -LiteralPath $path) {
        & $settingsSorterScript -SettingsPath $path @commonParams
    } else {
        Write-Host "Skipping missing settings file: $path"
    }
}

if (Test-Path -LiteralPath $ExtensionsPath) {
    & $extensionsSorterScript -ExtensionsPath $ExtensionsPath @commonParams
} else {
    Write-Host "Skipping missing extensions file: $ExtensionsPath"
}

$resolvedWordListPaths = $WordListPaths
if ($resolvedWordListPaths.Count -eq 0) {
    $resolvedWordListPaths = @(
        Get-ChildItem -Path $WordListGlob -File -ErrorAction SilentlyContinue |
            ForEach-Object { $_.FullName }
    )
}

& $wordListSorterScript -WordListPaths $resolvedWordListPaths @commonParams
exit $LASTEXITCODE
