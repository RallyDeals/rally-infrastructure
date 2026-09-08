#!/usr/bin/env bash
# Follow logs. Optionally pass a service name.
# Usage: ./scripts/logs.sh [service]

set -euo pipefail

HEREDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$HEREDIR")"
cd "$ROOT"

COMPOSE="$ROOT/docker/local/docker-compose.yml"
ENV_FILE="$ROOT/docker/local/.env"

SERVICE="${1:-}"
if [[ -n "$SERVICE" ]]; then
  docker compose -f "$COMPOSE" --env-file "$ENV_FILE" logs -f "$SERVICE"
else
  docker compose -f "$COMPOSE" --env-file "$ENV_FILE" logs -f
fi
