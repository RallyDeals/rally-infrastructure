#!/usr/bin/env pwsh
# Bring up the full RallyDeals local stack (infra + services) in detached mode.
# Usage: ./scripts/up.ps1 [-NoBuild]

[CmdletBinding()]
param(
    [switch]$NoBuild
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here
Set-Location $root

if (-not (Test-Path ".env")) {
    Write-Error "Missing .env. Copy .env.example to .env and fill in values first."
    exit 1
}

$buildArg = if ($NoBuild) { @() } else { @("-d", "--build") }
if ($NoBuild) {
    $buildArg = @("-d")
}

docker compose --env-file .env up $buildArg
if ($LASTEXITCODE -ne 0) {
    Write-Error "docker compose up failed (exit $LASTEXITCODE)."
    exit $LASTEXITCODE
}

Write-Host ""
Write-Host "RallyDeals is starting. Useful endpoints:" -ForegroundColor Green
Write-Host "  Gateway / API   http://localhost:8080"
Write-Host "  Kafka UI        http://localhost:9000"
Write-Host "  Mailpit (UI)    http://localhost:8025"
Write-Host ""
Write-Host "Follow logs with:  ./scripts/logs.ps1"
