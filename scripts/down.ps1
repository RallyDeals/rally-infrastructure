#!/usr/bin/env pwsh
# Stop (and remove) the RallyDeals local stack.
# Usage: ./scripts/down.ps1 [-Volumes]

[CmdletBinding()]
param(
    [switch]$Volumes
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here
Set-Location $root

if (-not (Test-Path ".env")) {
    Write-Warning "No .env found - using default variables for teardown."
}

$args = @("--env-file", ".env", "down")
if ($Volumes) {
    $args += "-v"
}

docker compose @args
Set-Location $here
