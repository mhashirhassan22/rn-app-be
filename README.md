# rn-app-be

FastAPI backend for [rn-app-fe](https://github.com/mhashirhassan22/rn-app-fe).

## Quick start

```bash
cp .env.example .env
make run        # local venv, reload, http://localhost:8000/docs
make up         # or: docker compose with hot reload
make test lint
make help       # all targets
```

## Layout

```
app/
  main.py        app factory, CORS, router registration
  config.py      env-driven settings (pydantic-settings)
  api/           routers (add new modules here)
tests/
Dockerfile       slim production image (non-root, healthcheck)
docker-compose.yml  dev stack with hot reload
```

## Connecting the mobile app

- iOS simulator: `http://localhost:8000`
- Android emulator: `http://10.0.2.2:8000`
- Physical device: `http://<your-LAN-IP>:8000`

Health check: `GET /health` (also at `/api/v1/health`).
