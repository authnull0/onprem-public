# Bare‑IP (no domain / no TLS) deployment guide

How to run the AuthNull on‑prem stack reachable over a **plain IP address on HTTP**
(no DNS record, no TLS cert), including PAM database access (ProxySQL + wallet MFA)
and the DB console.

This captures every change made to get bare‑IP working end to end. Values below use
the reference deployment (platform VM `172.174.113.240`, backend Postgres VM
`20.163.172.40`, org `dkram`, tenant `1`) — substitute your own.

> Org/tenant no longer come from the hostname. They are read from `.env`
> (`DOMAIN_URL` → org/tenant, `ORG_NAME`), so an IP with no dot‑labels works.
> This requires the org/tenant‑from‑config service builds (see “Service builds” below).

---

## 1. `.env`

| var | value | meaning |
|---|---|---|
| `SYSTEM_URL` | `http://<PUBLIC_IP>` | Reachable API base — **all** HTTP traffic, email links, agent API, wallet baseURL, ProxySQL MFA. Plain `http://IP`, no port, no trailing slash. |
| `DOMAIN_URL` | `default.<org>.<domain>` | Logical org/tenant identity key only (never fetched). Split → org = label[1], tenant = label[0]. e.g. `default.dkram.prod.authnull.com`. |
| `ORG_NAME` | `<org>` | Fallback org name (e.g. `dkram`). |
| `TENANT_ID` | `1` | |

`docker-compose.yaml` already injects `SYSTEM_URL`/`DOMAIN_URL` into every service that
needs them. **Editing `.env` requires recreating the affected containers**
(`docker compose up -d <svc>`) — interpolation happens at container‑create time.

---

## 2. nginx — plain‑HTTP catch‑all (host install, not a container)

Use **`nginx-bare-ip.conf`** from this repo. It is a single `listen 80 default_server;
server_name _;` server that serves any Host (bare IP, localhost, anything), with no TLS
and no `/etc/letsencrypt` references.

```bash
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak.$(date +%F)
sudo cp nginx-bare-ip.conf /etc/nginx/nginx.conf
sudo nginx -t && sudo systemctl reload nginx
```

Points that are easy to lose when hand‑editing (all already correct in `nginx-bare-ip.conf`):

- **`location /pam/` must STRIP the prefix:** `proxy_pass http://onprem_pam/;`
  (**not** `.../pam/`). pam‑service serves `/api/v1/...`; the `/pam` prefix only
  disambiguates it from user‑service. Wrong form → every `/pam/*` call 404s with a
  Goa `{"name":"fault","message":"404 page not found"}`.
- **Every WebSocket location needs the upgrade headers** — `location /pam/` and
  **`location /console/`** (the DB web console) both carry:
  ```nginx
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection $connection_upgrade;
  ```
  Missing these on `/console/` → the console WebSocket dies with code 1006.
  (`map $http_upgrade $connection_upgrade` is defined at the top of `http{}`.)
- CORS `$cors_origin` map echoes `http://IP[:port]` and `http://localhost:2345`
  origins (credentials are on, so `*` is not allowed).

Optional laptop access without opening port 80: `ssh -L 2345:localhost:80 authnull@<IP>`
then browse `http://localhost:2345`.

---

## 3. PAM database access (ProxySQL + wallet MFA)

DB access = client → **ProxySQL** → `do-authenticationV4` (authn‑service) → **PR pushed
to the user’s wallet** → approve → session. Pieces:

### 3a. ProxySQL (host service `proxysql.service`, config `/etc/proxysql.cnf`)
Custom `[authnull]` section (read at process start; env vars win over the file):
```ini
[authnull]
org_id    = <ORG_ID>            # e.g. 3
tenant_id = <TENANT_ID>         # e.g. 1
api_url   = "http://<PUBLIC_IP>/authnull0/api/v1/authn/v3/do-authenticationV4"
```
- `api_url` **must** be the reachable local HTTP endpoint. A stale
  `https://onprem.prod.authnull.com/...` here fails every DB login (DNS/cert) and no PR
  is raised. After editing, `sudo systemctl restart proxysql`.
- Alternatively set env `AUTHNULL_API_URL` / `AUTHNULL_ORG_ID` / `AUTHNULL_TENANT_ID` in
  the systemd unit (env overrides the file — preferred for reinstalls).
- Client ports: **6133** (pgsql), **6033** (mysql). Connect with username
  `"<dbuser>,<token>"` and password `<token>` (the token is issued by the platform).

### 3b. ProxySQL backend health check (`monitor`)
ProxySQL health‑checks the backend as user `monitor`, connecting to a db that defaults to
its own name. On the **backend Postgres** create both:
```sql
CREATE ROLE monitor WITH LOGIN PASSWORD 'monitor';
GRANT pg_monitor TO monitor;
CREATE DATABASE monitor OWNER monitor;
```
Without these the backend is marked `OFFLINE HARD` and no query routes.
(Default ProxySQL monitor creds are `monitor`/`monitor`; match `proxysql.cnf`.)
> Note: the agent then discovers this `monitor` DB/role as inventory. Cleaner long‑term
> is to point ProxySQL’s monitor at an existing db/user (`pgsql-monitor_dbname`) and drop
> the dedicated `monitor` — see “Known issues”.

### 3c. Backend Postgres (the customer DB VM, e.g. `20.163.172.40`)
```
# postgresql.conf
listen_addresses = '*'
# pg_hba.conf
host all all <PLATFORM_VM_IP>/32 scram-sha-256
```
Create the agent’s connection role (must be able to provision/rotate DB users):
```sql
CREATE ROLE authnull WITH LOGIN PASSWORD '<pw>' SUPERUSER;  -- or CREATEROLE w/ admin
GRANT pg_read_all_data, pg_monitor TO authnull;
```
`reload`/`restart` Postgres after config edits. **These must survive reboot** — a reboot
that resets role passwords or bind address silently breaks the agent.

### 3d. Database agent (`db-agent.service`, `/opt/authnull-db-agent/`)
- `db.env`: `API=http://<PUBLIC_IP>` (must not be empty), plus `ORG_ID`,`TENANT_ID`,
  `KEY`,`MACHINE_KEY`.
- `data-source.yaml`: backend host/port/user/password (plaintext accepted if not
  `ENC()`‑wrapped; `ENC()` decrypts with `KEY` via `openssl aes-256-cbc -pbkdf2 -iter 100000`).
- Make it resilient: `Restart=always` in the unit (it currently **exits** if the backend
  is unreachable at startup, e.g. during a backend reboot).
- The agent syncs only **non‑system** databases (skips `postgres`/`template*`); create a
  real DB (e.g. `testdb`) for anything to appear in the UI.

---

## 4. Firewall / cloud NSG

ProxySQL runs on the host, so its ports must be open in **both** ufw and the cloud NSG.

| where | open |
|---|---|
| Platform VM ufw | `sudo ufw allow 6133/tcp` and `6033/tcp` (defaults allowed only 80/443/22/5432) |
| Platform VM NSG (inbound) | **6133** (pgsql proxy), 6033 if MySQL, 80 |
| Backend DB VM NSG (inbound) | **5432** from the platform VM |

---

## 5. Service builds required for bare IP

These app‑layer fixes must be in the deployed images (all built from the customer’s
branch — here `production-az`, except mfa‑service on `onprem`):

- **Org/tenant from config** — user‑service, mfa‑service, authnz, wallet‑service,
  issuer‑service, okta‑login resolve org/tenant from `DOMAIN_URL`/`ORG_NAME` instead of
  the request hostname.
- **authn‑service — no hardcoded Authnull host** (branch `production-az`, commit
  `f2891c2`): policy lookup and wallet presentation submission read `SYSTEM_URL` /
  `VERIFIER_SERVER_URL` instead of `https://onprem.prod.authnull.com`. Without it, DB
  MFA is rejected (`isValid=false`) even though the policy exists.
- **Wallet app (wallet-react-native)** — credential‑list slug crash fix (a credential
  with empty slug fields threw and blanked the whole list). See the app repo.

---

## 6. Known issues / open dev items

- **Policy‑service does not issue the DATABASE credential on policy creation** in the
  deployed build — `CallCreateDatabaseCredentialAPI` (uses `ISSUER_SERVICE`) exists but
  has no caller. The DB credential is instead created by the **database‑agent** when it
  picks up the policy’s job.
- **Agent can create the DB credential for the wrong DB user** — it has picked `monitor`
  (the health‑check role) instead of the policy’s DB user (`authnull`), so
  authn‑service’s lookup (keyed on the policy DB user) can’t match it. Workaround until
  fixed: don’t leave a stray `monitor` db_user in inventory (see 3b).
- **`json: cannot unmarshal number into ... localUser`** in issuer logs is a non‑fatal
  audit‑log warning (the credential still returns 201).

---

## Validation

- `curl -I http://<IP>/` → 200 from the frontend (not a 301 to https).
- `curl -sf -XPOST http://<IP>/pam/api/v1/users/listAll -d '{}'` → not 404 (routes to pam‑service).
- DB console: `/console/init` → 200, WS `/console/ws?sessionId=…` → `101 Switching Protocols`.
- DB access: `psql "postgresql://<dbuser>,<token>:<token>@<IP>:6133/<db>"` → pauses for the
  wallet PR → approve → connects.
