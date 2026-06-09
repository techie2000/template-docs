Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path "package.json")) {
    Write-Host "No package.json found; skipping package bootstrap."
    exit 0
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "npm not found; skipping package bootstrap."
    exit 0
}

$package = Get-Content -Raw "package.json" | ConvertFrom-Json -AsHashtable
$currentName = if ($package.ContainsKey("name")) { [string]$package["name"] } else { "" }

$repoName = Split-Path -Leaf (Get-Location)
$sanitized = $repoName.ToLowerInvariant()
$sanitized = [regex]::Replace($sanitized, "[^a-z0-9._-]", "-")
$sanitized = [regex]::Replace($sanitized, "-+", "-")
$sanitized = $sanitized.Trim('-', '.', '_')
if ([string]::IsNullOrWhiteSpace($sanitized)) {
    $sanitized = "project-docs"
}

$placeholders = @("template-docs", "work-template-docs")
$shouldReplace = [string]::IsNullOrWhiteSpace($currentName) -or $placeholders.Contains($currentName)

if ($shouldReplace -and $currentName -ne $sanitized) {
    & npm pkg set "name=$sanitized" | Out-Null
    Write-Host "Updated package.json name: $currentName -> $sanitized"
} else {
    Write-Host "Keeping package.json name: $currentName"
}

& npm pkg set "private=true" --json | Out-Null
