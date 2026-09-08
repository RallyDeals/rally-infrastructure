#!/usr/bin/env pwsh
# Build all application service images WITHOUT starting the stack.
# Usage: ./scripts/build-all.ps1

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here
$compose = Join-Path $root "docker\local\docker-compose.yml"
$envFile = Join-Path $root "docker\local\.env"
Set-Location $root

if (-not (Test-Path $envFile)) {
    Write-Error "Missing docker\local\.env. Copy docker\local\.env.example to docker\local\.env first (needs GITHUB_ACTOR / GITHUB_TOKEN)."
    exit 1
}

docker compose -f $compose --env-file $envFile build
if ($LASTEXITCODE -ne 0) {
    Write-Error "docker compose build failed (exit $LASTEXITCODE)."
    exit $LASTEXITCODE
}
