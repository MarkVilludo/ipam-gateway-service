# IPAM Gateway Service

Nginx gateway and Docker Compose orchestration for the IPAM stack (auth, IP management, frontend).

## Quick start

```bash
cp .env.example .env   # optional: set JWT_SECRET
docker compose up --build
```

- **Frontend**: http://localhost:3000
- **Gateway**: http://localhost:8000
- **APIs**: http://localhost:8000/api/auth/\*, http://localhost:8000/api/ip-addresses, etc.

## Viewing logs

Compose **service names** (use these with `docker compose logs <service>`):

| Service name | Container name | Description    |
| ------------ | -------------- | -------------- |
| `gateway`    | ipam_gateway   | Nginx gateway  |
| `auth`       | ipam_auth      | Auth service   |
| `ip`         | ipam_ip        | IP management  |
| `frontend`   | ipam_frontend  | Vue frontend   |
| `auth-db`    | auth_db        | MySQL for auth |
| `ip-db`      | ip_db          | MySQL for IP   |

Examples:

```bash
docker compose logs auth      # Auth service (not ipam_auth)
docker compose logs ip
docker compose logs auth-db
```

If **auth is unhealthy**: check `docker compose logs auth` for DB connection errors, migration failures, or PHP errors. Ensure `auth-db` is healthy first.

See [README-JWT.md](README-JWT.md) for JWT and 401 troubleshooting.
