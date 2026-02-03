# JWT_SECRET and 401 Unauthenticated

**Auth and IP service must use the same `JWT_SECRET`.** Tokens are signed by the auth service and verified by the IP service. If the secret differs, `/api/audit-logs` and other protected IP routes return **401 Unauthenticated**.

## When using Docker (gateway stack)

1. **Copy `.env.example` to `.env`** in this folder so Docker Compose gets `JWT_SECRET`:

   ```bash
   cd ipam-gateway-service
   cp .env.example .env
   ```

   The same value is then passed to both `auth` and `ip` containers.

2. **Rebuild and restart** auth and IP after changing the secret:

   ```bash
   docker compose up -d --build auth ip
   ```

3. **Log in again** to get a new token (old tokens may be signed with a different secret or expired).

## When running services locally (no Docker)

Use the **same** `JWT_SECRET` in:

- `auth-service/site/.env`
- `ip-management-service/site/.env`

Your project already has the same value in both. Do not change one without the other.

## Quick check

- **Auth** signs tokens with `config('jwt.secret')`.
- **IP** verifies with `config('jwt.secret')`.
- If they differ → 401 on `/api/audit-logs`, `/api/ip-addresses`, etc.

## Testing with Postman (avoid 401 on /api/ip-addresses)

`GET /api/ip-addresses` returns **401** if the request has no valid JWT. You must send the token on every protected request:

1. **Login** – `POST http://localhost:8000/api/auth/login` with body (JSON):
   ```json
   { "email": "your@email.com", "password": "yourpassword" }
   ```
2. **Copy the token** from the response (e.g. `"token": "eyJ0eXAiOiJKV1QiLCJhbGc..."`).
3. **For GET /api/ip-addresses** (and any other protected IP route):
   - Open the **Authorization** tab.
   - Type: **Bearer Token**.
   - Paste the token in the **Token** field (no `Bearer ` prefix; Postman adds it).
   - Or add a header: **Authorization** = `Bearer <paste token>`.

If you don’t set Authorization on the request, the gateway still forwards the header (empty), and the IP service correctly returns 401.

## Role in JWT (super_admin vs user)

The auth service includes a `role` claim in the JWT (e.g. `user` or `super_admin`). The IP service reads this to sync the user and enforce permissions (e.g. audit-logs require `super_admin`). If you log in as super_admin but get 401 on `/api/ip-addresses` or your role is treated as `user`:

1. **Same JWT_SECRET** – Auth and IP must use the same secret (see above).
2. **Re-login** – Get a fresh token after any auth/IP or gateway config change.
3. **Auth roles** – Ensure the user has the `super_admin` role for guard `api` in the auth DB (e.g. run seeders: `user` and `super_admin` roles with `guard_name = api`).
