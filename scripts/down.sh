#!/usr/bin/env bash
# Stop (and remove) the RallyDeals local stack.
# Usage: ./scripts/down.sh [-v|--volumes]

set -euo pipefail

HEREDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$HEREDIR")"
cd "$ROOT"

COMPOSE="$ROOT/docker/local/docker-compose.yml"
ENV_FILE="$ROOT/docker/local/.env"

EXTRA=()
if [[ "${1:-}" == "-v" || "${1:-}" == "--volumes" ]]; then
  EXTRA+=("-v")
fi

docker compose -f "$COMPOSE" --env-file "$ENV_FILE" down "${EXTRA[@]}"
