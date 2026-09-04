# rally-infrastructure

The **single source of truth** for running the entire RallyDeals platform locally with Docker Compose.

One command starts all infrastructure (Kafka, Kafka UI, Redis, Mailpit, one Postgres per service) **and** every application service, built from the sibling repos in `../`.

> This replaces the fragmented, conflicting per-service `docker-compose.yml` files. Those files are intentionally left in place (untouched) — this repo is the one you should use.

## Quick start (Windows / PowerShell)

```powershell
# 1. Prepare your .env (git-ignored). This is the single place to set secrets.
Copy-Item .env.example .env
#    -> open .env and set: JWT_SECRET, GITHUB_ACTOR, GITHUB_TOKEN, STRIPE_API_KEY, STRIPE_WEBHOOK_SECRET

# 2. Build images + start everything
./scripts/up.ps1

# 3. Watch logs
./scripts/logs.ps1
```

Stop with `./scripts/down.ps1` (add `-Volumes` to also delete data volumes).

## Quick start (bash / WSL / macOS / Linux)

```bash
cp .env.example .env    # fill in values
./scripts/up.sh         # or: ./scripts/up.sh --no-build
./scripts/logs.sh
./scripts/down.sh       # add --volumes to delete data
```

## Endpoints

| Component | URL | Notes |
|-----------|-----|-------|
| Gateway (API) | http://localhost:8080 | entry point for all services |
| Kafka UI | http://localhost:9000 | |
| Mailpit UI | http://localhost:8025 | SMTP catcher on `localhost:1025` |
| Redis | `localhost:6379` | gateway rate limiter |

> **Stripe CLI** (`stripe-cli`) starts alongside the stack. It listens for Stripe events and forwards them to the payment service on the internal network (`http://payment:8082/api/v1/payments/webhook`). Requires `STRIPE_API_KEY` (and a webhook signing secret) in `.env`. Run `stripe listen` yourself instead if you prefer local event capture.

### Services & host ports

| Service | Port | DB container (host port) |
|---------|------|--------------------------|
| gateway | 8080 | – |
| auth | 8084 | auth-postgres (5430) |
| catalog | 8083 | catalog-postgres (5433) |
| deal | 8085 | deal-postgres (5435) |
| order | 8010 | order-postgres (5434) |
| payment | 8082 | payment-postgres (5432) |
| inventory | 8087 | inventory-postgres (5436) |
| notification | 8010 | – (no DB) |
| participation | 8086 *(placeholder)* | – |
| management | *(placeholder)* | – |

`participation` and `management` are behind the `placeholders` compose profile until their repos ship runnable services:

```bash
docker compose --env-file .env --profile placeholders up -d
```

## Build requirements

- Docker with **BuildKit** (default in recent Docker Desktop).
- **auth, payment, notification, gateway** no longer build from a Dockerfile — the compose pulls the **Jib-built images** `medhatdh/rally-auth:latestTEST`, `medhatdh/rally-payment:latestTEST`, `medhatdh/rally-notification:latestTEST`, `medhatdh/rally-gateway:latestTEST`. These must be pushed to a registry (`Docker Hub` by default) before `docker compose up`:

  ```bash
  cd ../rally-gateway && mvn compile jib:build
  cd ../rally-auth && mvn compile jib:build
  cd ../rally-payment && mvn compile jib:build
  cd ../rally-notification && mvn compile jib:build
  ```

- **GitHub Packages access** for services that build from source and depend on `rally-common` / `rally-security` (catalog, deal). Set `GITHUB_ACTOR` and `GITHUB_TOKEN` (a token with `read:packages`) in `.env`.

## Layout

```
rally-infrastructure/
├── docker-compose.yml      # monolithic compose: infra + services
├── .env.example           # single source of every env var (copy to .env)
├── .gitignore             # ignores .env, docker data, etc.
├── scripts/               # up/down/build/logs (pwsh + bash)
├── configs/postgres/      # optional per-DB init SQL
├── clone-all-repos.sh     # (legacy) clone all RallyDeals repos
└── clone-all-repos.bat
```

## Known limitations / next steps

- `rally-order` has **no Dockerfile** and hardcodes `localhost` URLs in `application.properties` — it cannot run as a container yet.
- `rally-notification` also hardcodes `localhost` SMTP/Kafka/port — convert to env-driven config before containerizing.
- `rally-notification` (Jib image) still hardcodes `localhost` SMTP/Kafka/port in `application.properties` - override at runtime with compose env vars; convert to env-driven placeholders for full runtime control.
- `rally-auth` (Jib image) depends on `rally-common` / `rally-security` from GitHub Packages - its Jib build needs the GitHub registry configured in Maven (`settings.xml`) at build time.
See `docs/local-development.md` for details.
