# rally-infrastructure

Infrastructure + deployment files for the **RallyDeals** platform.

The repo is split into **local development** and **production** environments, each with its
own docker-compose file and env template.

## Layout

```
rally-infrastructure/
├── docker/
│   ├── local/                      # LOCAL DEVELOPMENT (everything runs in Docker)
│   │   ├── docker-compose.yml      #   postgres + infra + all services
│   │   ├── .env.example            #   env template (copy to .env)
│   │   ├── .env                    #   git-ignored real values
│   │   └── configs/
│   │       ├── grafana/            #   grafana provisioning + dashboards
│   │       └── loki/               #   loki config
│   └── prod/                       # PRODUCTION (databases hosted on Aiven)
│       ├── docker-compose.yml      #   infra + all services, NO postgres
│       ├── .env.example            #   env template (DB hosts -> Aiven)
│       └── .env                    #   git-ignored real values
├── scripts/                        # local up/down/build/logs (pwsh + bash)
├── clone-all-repos.sh              # clone all RallyDeals repos
├── clone-all-repos.bat
└── README.md
```

## Local Development

`docker/local/docker-compose.yml` runs **everything**: one Postgres per service, Kafka + Kafka UI,
Redis, Mailpit, Jaeger/Loki/Grafana, and all application services.

```powershell
# 1. Prepare your env (git-ignored). Set secrets:
Copy-Item docker/local/.env.example docker/local/.env
#    -> open docker/local/.env and set:
#       JWT_PRIVATE_KEY, JWT_PUBLIC_KEY, GITHUB_ACTOR, GITHUB_TOKEN, STRIPE_API_KEY, STRIPE_WEBHOOK_SECRET

# 2. Build images + start everything
./scripts/up.ps1

# 3. Watch logs
./scripts/logs.ps1
```

Stop with `./scripts/down.ps1` (add `-Volumes` to also delete data volumes).

### bash / WSL / macOS / Linux

```bash
cp docker/local/.env.example docker/local/.env   # fill in values
./scripts/up.sh         # or: ./scripts/up.sh --no-build
./scripts/logs.sh
./scripts/down.sh       # add --volumes to delete data
```

### Local endpoints

| Component | URL | Notes |
|-----------|-----|-------|
| Gateway (API) | http://localhost:8080 | entry point for all services |
| Kafka UI | http://localhost:9000 | |
| Mailpit UI | http://localhost:8025 | SMTP catcher on `localhost:1025` |
| Redis | `localhost:6379` | gateway rate limiter |
| Jaeger UI | http://localhost:16686 | traces |
| Grafana | http://localhost:3000 | admin / admin |

### Local services & host ports

| Service | Service port | DB container (host port) |
|---------|--------------|--------------------------|
| gateway | 8080 | – |
| order | 8081 | order-postgres (5434) |
| payment | 8082 | payment-postgres (5431) |
| catalog | 8083 | catalog-postgres (5433) |
| auth | 8084 | auth-postgres (5430) |
| deal | 8085 | deal-postgres (5435) |
| participation | 8086 | participation-postgres (5437) |
| inventory | 8087 | inventory-postgres (5436) |
| notification | 8088 | – (no DB) |

## Production

`docker/prod/docker-compose.yml` runs the same containers as local **except** Postgres, which is
hosted on **Aiven**. Set each service's DB connection in `docker/prod/.env`.

```bash
cp docker/prod/.env.example docker/prod/.env
#    -> open docker/prod/.env and set the Aiven host/port/user/password for:
#       AUTH_DB_*, CATALOG_DB_*, DEAL_DB_*, ORDER_DB_*, PAYMENT_DB_*,
#       INVENTORY_DB_*, PARTICIPATION_DB_*   (as well as JWT/GITHUB/STRIPE secrets)

docker compose -f docker/prod/docker-compose.yml --env-file docker/prod/.env up -d
```

There is **no** production helper script — the scripts in `scripts/` are for **local development only**.
Deploy production with the compose command above (or your CI/CD pipeline).

## Image requirements

- **gateway, auth, payment, notification** pull **Jib-built images** (`mariamaymann1/rally-<svc>:latest`),
  pushed to a registry before `docker compose up`:

  ```bash
  cd ../rally-gateway && mvn compile jib:build
  cd ../rally-auth && mvn compile jib:build
  cd ../rally-payment && mvn compile jib:build
  cd ../rally-notification && mvn compile jib:build
  ```

- **GitHub Packages access** for services that build from source and depend on `rally-common` /
  `rally-security` (catalog, deal). Set `GITHUB_ACTOR` and `GITHUB_TOKEN` (a token with
  `read:packages`) in your env file.

## Secrets & .env

- `.env` files are **git-ignored** (root `.gitignore`, plus `docker/prod/.gitignore`).
- Commit only the `.env.example` templates, never real `.env` values.
- `JWT_PRIVATE_KEY` / `JWT_PUBLIC_KEY` must be a matching RSA keypair shared across all services.
- `OTP_ENCRYPTION_PASSWORD` / `OTP_ENCRYPTION_SALT` must match between auth and notification.
