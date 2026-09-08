#!/usr/bin/env pwsh
# Stop (and remove) the RallyDeals local stack.
# Usage: ./scripts/down.ps1 [-Volumes]

[CmdletBinding()]
param(
    [switch]$Volumes
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here
$compose = Join-Path $root "docker\local\docker-compose.yml"
$envFile = Join-Path $root "docker\local\.env"
Set-Location $root

if (-not (Test-Path $envFile)) {
    Write-Warning "No docker\local\.env found - using default variables for teardown."
}

$args = @("-f", $compose, "--env-file", $envFile, "down")
if ($Volumes) {
    $args += "-v"
}

docker compose @args
Set-Location $here
