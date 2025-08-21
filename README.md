# Vendelo App — Rails 7 + PostgreSQL (Dockerized Dev)

A lean local development setup for **Ruby on Rails 7.2.2.2** on **Ruby 3.3.9** with **PostgreSQL 16**, running entirely in Docker.

## What’s inside
- **Rails**: 7.2.2.2
- **Ruby**: 3.3.9 (official Debian slim image)
- **PostgreSQL**: 16 (separate container, persistent volume)
- **Bundler caching**: gems stored in a Docker volume for fast rebuilds
- **Entry point**: auto-removes `tmp/pids/server.pid` and runs `bundle check || bundle install`
- **Image deps**: `build-essential`, `libpq-dev`, `libyaml-dev`, `pkg-config`, `libvips`, `git`, `curl`

> Files of interest:
> - `Dockerfile` (dev image)
> - `docker-compose.yml` (web + db services)
> - `docker/entrypoint.sh` (dev entrypoint)
> - `config/database.yml` (reads `DATABASE_URL`)

---

## Prerequisites
- Docker Desktop (or Docker Engine)  
- Docker Compose v2 (`docker compose …`)

---

## Quick start

```bash
# 1) Build images
docker compose build

# 2) Start containers in the background
docker compose up -d

# 3) Create DB, run pending migrations, etc.
docker compose exec web bin/rails db:prepare

# 4) Open the app
# http://localhost:3000
```

Rails logs:
```bash
docker compose logs -f web
```

Stop everything:
```bash
docker compose down
```

---

## Environment / Database

By default (see `docker-compose.yml`):

- **DB host**: `db`
- **DB user/password**: `postgres` / `postgres`
- **Dev DB name**: `vendelo_development`
- **DATABASE_URL** (for web): `postgres://postgres:postgres@db:5432/vendelo_development`

`config/database.yml` uses `ENV["DATABASE_URL"]` for `development`.  
For tests it falls back to: `postgres://postgres:postgres@db:5432/vendelo_test` unless you override `DATABASE_TEST_URL`.

Create the test DB:
```bash
docker compose exec web bin/rails db:prepare RAILS_ENV=test
```

---

## Day-to-day commands (inside the web container)

```bash
# Rails console
docker compose exec web bin/rails console

# Run migrations
docker compose exec web bin/rails db:migrate

# Generate scaffold/model/controller/etc.
docker compose exec web bin/rails g scaffold Post title:string body:text

# Open a psql shell in the DB container
docker compose exec db psql -U postgres -d vendelo_development
```

---

## Networking & hosts in Docker

We already allow external access in dev:

- Rails binds to `0.0.0.0` (`-b 0.0.0.0` in the CMD).
- `config/environments/development.rb` should allow hosts (we use `config.hosts.clear`).
- App is exposed on `http://localhost:3000`.
