#!/usr/bin/env pwsh
# Build all application service images WITHOUT starting the stack.
# Usage: ./scripts/build-all.ps1

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here
Set-Location $root

if (-not (Test-Path ".env")) {
    Write-Error "Missing .env. Copy .env.example to .env first (needs GITHUB_ACTOR / GITHUB_TOKEN)."
    exit 1
}

docker compose --env-file .env build
if ($LASTEXITCODE -ne 0) {
    Write-Error "docker compose build failed (exit $LASTEXITCODE)."
    exit $LASTEXITCODE
}
