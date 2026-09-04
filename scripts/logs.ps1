#!/usr/bin/env pwsh
# Follow logs. Optionally pass a service name.
# Usage: ./scripts/logs.ps1 [-f] [service]

param(
    [string]$Service = ""
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here
Set-Location $root

if ($Service -ne "") {
    docker compose --env-file .env logs -f $Service
} else {
    docker compose --env-file .env logs -f
}
