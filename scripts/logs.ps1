#!/usr/bin/env pwsh
# Follow logs. Optionally pass a service name.
# Usage: ./scripts/logs.ps1 [-f] [service]

param(
    [string]$Service = ""
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here
$compose = Join-Path $root "docker\local\docker-compose.yml"
$envFile = Join-Path $root "docker\local\.env"
Set-Location $root

if ($Service -ne "") {
    docker compose -f $compose --env-file $envFile logs -f $Service
} else {
    docker compose -f $compose --env-file $envFile logs -f
}
