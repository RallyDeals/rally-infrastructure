#!/usr/bin/env bash
# Follow logs. Optionally pass a service name.
# Usage: ./scripts/logs.sh [service]

set -euo pipefail

HEREDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$HEREDIR")"
cd "$ROOT"

SERVICE="${1:-}"
if [[ -n "$SERVICE" ]]; then
  docker compose --env-file .env logs -f "$SERVICE"
else
  docker compose --env-file .env logs -f
fi
