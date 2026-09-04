#!/usr/bin/env bash
# Build all application service images WITHOUT starting the stack.
# Usage: ./scripts/build-all.sh

set -euo pipefail

HEREDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$HEREDIR")"
cd "$ROOT"

if [[ ! -f .env ]]; then
  echo "Missing .env. Copy .env.example to .env first (needs GITHUB_ACTOR / GITHUB_TOKEN)." >&2
  exit 1
fi

docker compose --env-file .env build
