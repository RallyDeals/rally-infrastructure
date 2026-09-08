#!/usr/bin/env bash
# Bring up the full RallyDeals local stack (infra + services) in detached mode.
# Usage: ./scripts/up.sh [-n|--no-build]

set -euo pipefail

HEREDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$HEREDIR")"
cd "$ROOT"

COMPOSE="$ROOT/docker/local/docker-compose.yml"
ENV_FILE="$ROOT/docker/local/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing docker/local/.env. Copy docker/local/.env.example to docker/local/.env and fill in values first." >&2
  exit 1
fi

BUILD="--build"
if [[ "${1:-}" == "-n" || "${1:-}" == "--no-build" ]]; then
  BUILD=""
fi

docker compose -f "$COMPOSE" --env-file "$ENV_FILE" up -d $BUILD

echo ""
echo "RallyDeals is starting. Useful endpoints:"
echo "  Gateway / API   http://localhost:8080"
echo "  Kafka UI        http://localhost:9000"
echo "  Mailpit (UI)    http://localhost:8025"
echo ""
echo "Follow logs with:  ./scripts/logs.sh"
