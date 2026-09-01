# Plain-HTTP & IP access for Stemz — DevOps Runbook

Serve the Stemz AuthNull stack over plain HTTP so it can be reached by IP address
(no domain, no TLS), and opened from a laptop through an SSH tunnel.

| | |
|---|---|
| **Target host** | Stemz on-prem VM |
| **nginx** | host install, not container |
| **Config file** | `/etc/nginx/nginx.conf` |
| **Owner** | DevOps |

---

## ⚠️ BLOCKER — read before starting

**"Works with just an IP" needs a code change that ships separately.**

Today every login resolves the org/tenant from the **hostname** (the 2nd dot-label
of the URL). An IP address has no such label, so login fails with
`database "<octet>" does not exist` even after nginx is perfect.

The dev team is making org/tenant read from config (`ORG_NAME` / `TENANT_ID` in
`.env`). **This runbook sets up the HTTP/tunnel layer; full login over IP is only
expected once that build is deployed.** Everything below can still be done and
validated at the HTTP layer in the meantime.

---

## Objective

Replace the two TLS/domain-bound nginx server blocks with a single plain-HTTP
catch-all, expose it to a laptop over an SSH port-forward, and confirm the console
loads at `http://localhost:2345`. **No public port 80 is opened** — traffic rides
the existing SSH channel (port 22).

---

## Part A — Non-SSL nginx

### 1. Back up the current config
_on the VM_
```bash
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak.$(date +%F)
```

### 2. Keep the whole `http { }` preamble and every `upstream` block as-is
The `map`, the timeouts, and all `upstream onprem_*` definitions (everything up to
the first `server {`) do **not** change — only the `server` blocks below them are
replaced.

### 3. Delete all four existing `server` blocks
Remove both the "main domain" pair and the "tenant subdomain" pair — that's two
`listen 80 … return 301` redirect servers and two `listen 443 ssl` servers.
Nothing that references `/etc/letsencrypt` should remain.

### 4. Add one plain-HTTP catch-all server in their place
Paste the skeleton below, then move **every `location` block** from the old servers
into it. The two old servers had slightly different paths (e.g. `/pam/` vs
`/pam/api/v1/`) — keep the **union** of both; distinct prefixes coexist fine.

_/etc/nginx/nginx.conf — replaces the 4 server blocks_
```nginx
server {
    listen 80 default_server;
    server_name _;                 # catch-all: IP, localhost, any Host

    client_max_body_size 50m;
    proxy_connect_timeout 300;
    proxy_read_timeout 300;
    proxy_send_timeout 60;
    proxy_set_header Host              $http_host;
    proxy_set_header X-Real-IP         $remote_addr;
    proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto http;   # plain HTTP now

    # ---- paste the UNION of all location blocks here ----
    # location /pam/ { ... }             location /api/v1/users/ { ... }
    # location /authentication/ { ... }  location /ssc/ { ... }
    # location / { proxy_pass http://onprem_frontend; ... }  etc.
}
```

### 5. Allow the local origin through CORS
The `$cors_origin` map only lists `https://…` origins today. Add the tunnel origin
so browser calls aren't blocked. Credentials are on, so the origin must be echoed
explicitly — a `*` wildcard is **not** allowed with credentials.

_inside the existing `map $http_origin $cors_origin { }`_
```nginx
"http://localhost:2345"  "http://localhost:2345";
"~^http://[0-9.]+(:[0-9]+)?$"  $http_origin;   # any http://IP[:port]
```

### 6. Test the syntax, then reload
```bash
sudo nginx -t
sudo systemctl reload nginx
```
`nginx -t` must print *syntax is ok* / *test is successful* before you reload.
If it fails, the config still has a stray `ssl_certificate` or an unclosed block.

---

## Part B — Port-forward to a laptop

### 1. Open the tunnel from the laptop
Maps laptop port `2345` → the VM's local port `80`. Port 80 never needs to be public.
```bash
ssh -L 2345:localhost:80 authnull@<VM_PUBLIC_IP>
```

### 2. Open it in the browser
Leave the SSH session running and visit:
```
http://localhost:2345
```
Because `server_name _` is a catch-all, the `localhost:2345` Host header is accepted as-is.

### 3. Optional — use a name instead of localhost
If a `name:2345` URL is preferred, point a hosts entry at loopback on the laptop,
then browse `http://stemz.local:2345`:
```
# laptop /etc/hosts
127.0.0.1   stemz.local
```

---

## Part C — Validation

- **On the VM:** `curl -I http://localhost/` returns `200` from the frontend (not a `301` to https).
- **From the laptop** (tunnel up): `curl -I http://localhost:2345/` returns `200`.
- **In the browser:** the console renders and its network calls all go to
  `http://localhost:2345/...` — no request falls back to an `https://…authnull.com`
  origin (see open questions).
- **Full login over IP:** only after the org/tenant-from-config build is deployed (see blocker).

---

## Rollback

One step — restore the backup and reload:
```bash
sudo cp /etc/nginx/nginx.conf.bak.<date> /etc/nginx/nginx.conf
sudo nginx -t && sudo systemctl reload nginx
```

---

## Open questions for dev / to confirm

### ◇ Frontend API base URL — does the SPA call a hard-coded https origin?
If `did-react` (the console) bakes an API base like `https://onprem.stemz…` at build
time, its calls will bypass the tunnel and fail. The self-service-console reads a
runtime `env.js` (swappable without a rebuild), but the main console may need its
base URL pointed at the same-origin path (or the plain IP) — confirm with dev.

- **Org/tenant-from-config build** — which services and what version carry the fix,
  so login over IP can be re-tested once deployed.
- **Public port 80** — if direct `http://<IP>` access (no tunnel) is ever wanted, the
  VM firewall / security group must allow inbound 80. The tunnel approach here does not require it.

---

_Scope: nginx + tunnel only. Application-layer org/tenant resolution and any
frontend rebuild are owned by the dev team and tracked separately._
