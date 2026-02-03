# IPAM Gateway Service

Nginx gateway and Docker Compose orchestration for the IPAM stack (auth, IP management, frontend).

## Quick start

```bash
docker compose up --build
```

To set a custom JWT secret (e.g. for production), copy `.env.example` to `.env` and set `JWT_SECRET`. See [README-JWT.md](README-JWT.md).

- **Frontend**: http://localhost:3000
- **Gateway**: http://localhost:8000
- **APIs**: http://localhost:8000/api/auth/\*, http://localhost:8000/api/ip/ip-addresses, etc.

## Accessing the application via CLI if needed (when you need to debug the application or run commands inside the container (migrate, seed, etc.)))

Auth service:

```bash
docker exec -it ipam_auth bash
```

IP management service:

```bash
docker exec -it ipam_ip bash
```

## Checking the health of the services

```bash
docker compose ps
```
