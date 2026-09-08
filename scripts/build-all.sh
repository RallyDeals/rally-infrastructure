#!/usr/bin/env bash
# Build all application service images WITHOUT starting the stack.
# Usage: ./scripts/build-all.sh

set -euo pipefail

HEREDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$HEREDIR")"
cd "$ROOT"

COMPOSE="$ROOT/docker/local/docker-compose.yml"
ENV_FILE="$ROOT/docker/local/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing docker/local/.env. Copy docker/local/.env.example to docker/local/.env first (needs GITHUB_ACTOR / GITHUB_TOKEN)." >&2
  exit 1
fi

docker compose -f "$COMPOSE" --env-file "$ENV_FILE" build
