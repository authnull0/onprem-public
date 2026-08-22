# AuthNull On-Prem — Installation

Single-node deployment via Docker Compose.

`ENCRYPTION_KEY` and `TOTP_ENCRYPTION_KEY` in `.env` are already generated for
this installation. Every other value you set yourself, as described below.

---

## 1. Prerequisites

- Docker Engine 24+ with the Compose v2 plugin (`docker compose`, not
  `docker-compose`)
- 8 GB RAM minimum — Cassandra and Elasticsearch account for most of it
- 20 GB free disk
- These host ports free: 80, 2000, 2882, 3000, 5173, 5432, 6060-6067, 6090,
  6379, 6967, 7079, 7233, 8000, 8085-8087, 9000, 9042, 9090, 9200, 9211,
  9234, 9255, 9291, 9595

Check for conflicts before starting:

    ss -tlnp | grep -E ':(9090|5432|6379|3000|5173|9200|9042)\s'

**Port 9090** is occupied by Cockpit on many RHEL and Debian hosts. If so,
set `PAM_HOST_PORT` in `.env` to any free port (for example `9091`). Nothing
else changes — internal service addressing is unaffected.

---

## 2. Values you must set

Open `.env` and populate the following. The stack will not start until all of
them have values.

### Database

    DB_USER=                 # Postgres role to create, e.g. authnull
    DB_NAME=                 # database to create, e.g. authnull_dev
    POSTGRES_PASSWORD=       # password for DB_USER

`DB_HOST`, `DB_PORT` and `DB_SCHEMA` are already set correctly — leave them.

### Redis

    REDIS_PASSWORD=          # Redis AUTH password

### MinIO (object storage)

    MINIO_ROOT_USER=         # console/API user, minimum 3 characters
    MINIO_ROOT_PASSWORD=     # minimum 8 characters

### Site identity

    SYSTEM_URL=              # how browsers reach this host, e.g.
                             #   https://onprem.example.com
    SYSTEM_IP=               # this host's public IP, e.g. 203.0.113.10
    ORG_NAME=                # your organisation short name, e.g. example
    DOMAIN_URL=              # tenant domain, e.g. default.example.com

`TENANT_ID=1` is already set and should not be changed on a fresh install.

### Email (required for user invitations and verification)

    SMTP_HOST=
    SMTP_PORT=
    SMTP_FROM=
    SMTP_PASSWORD=

> ### Password character restriction
>
> `POSTGRES_PASSWORD` and `REDIS_PASSWORD` are inserted into connection URLs
> internally:
>
>     postgres://<DB_USER>:<POSTGRES_PASSWORD>@postgres:5432/<DB_NAME>
>     redis://:<REDIS_PASSWORD>@redis:6379/0
>
> A password containing `@ : / ? #` produces a malformed URL and the affected
> service fails to connect, often with a confusing error. Use letters and
> digits only, or generate one with:
>
>     openssl rand -hex 24

> ### Set these before the first start
>
> Postgres initialises its data directory only once. Changing `DB_USER`,
> `DB_NAME` or `POSTGRES_PASSWORD` after the first `docker compose up` has no
> effect — the old credentials persist in the `postgres-data` volume, and
> services then fail to authenticate. Get these right before starting, or
> remove the volume and start over.

---

## 3. The pre-generated keys — do not change, and back them up

`.env` already contains:

    ENCRYPTION_KEY=          # encrypts stored credentials
    TOTP_ENCRYPTION_KEY=     # encrypts enrolled MFA secrets

These exist only in this file.

- **Losing them** makes the encrypted data unrecoverable. There is no reset.
- **Changing them** after the first start raises no error. It silently makes
  existing credentials undecryptable and locks every user out of MFA.

Copy `.env` to durable, restricted storage before you start, and restrict it
on the host:

    chmod 600 .env

---

## 4. Start

    docker compose up -d

First start takes several minutes: Cassandra must report healthy before
Temporal initialises its schema, which gates the log-workflow worker.

Watch progress:

    docker compose ps
    docker compose logs -f temporal

When settled, every service reads `running`, with two exceptions:
`cassandra-init` and `did-schema-init` are one-shot setup jobs and correctly
show `Exited (0)`.

Then:

- Admin console — port `5173`
- Self-service console — port `3000`
- MinIO console — port `9595`

---

## 5. Optional integrations

All of these are inactive when left blank.

| Variable(s) | Enables |
|---|---|
| `AI_SERVICE_API_KEY` | AI policy and risk endpoints |
| `IPINFO_TOKEN` | IP geolocation in access logs |
| `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_PHONE` | SMS-based MFA |
| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `AWS_BUCKET_NAME` | S3 storage for session recordings |
| `GCLOUD_BUCKET_NAME` | GCS storage for session recordings |
| `CLOUDFLARE_ZONE_ID`, `CLOUDFLARE_AUTH_KEY`, `CLOUDFLARE_AUTH_EMAIL` | Automatic DNS record management |
| `KAFKA_BROKERS`, `KAFKA_TOPIC` | Streaming audit logs to Kafka |
| `ALCHEMY_API_KEY` | On-chain credential verification |
| `MINIO_BROWSER_REDIRECT_URL` | MinIO console behind a reverse proxy |

Session recordings work without AWS or GCS — `pam-service` runs with
`LOCAL_STORAGE_ENABLED=true` by default.

### Okta SSO

Disabled by default, and requires a SAML application in your own Okta tenant.
Set both values:

    OKTA_LOGIN_ROOT_URL=            # SAML Audience URI / entity ID
    OKTA_LOGIN_IDP_METADATA_URL=    # "Identity Provider metadata" link

Both are found under Okta Admin → Applications → your app → Sign On. Then
start the stack including the profile:

    docker compose --profile okta up -d

Leaving these blank and omitting `--profile okta` is fully supported; the rest
of the platform is unaffected.

### Variables you can ignore

`.env` also lists `AIPOLICY_API_KEY`, `AZURE_OPENAI_API_KEY`,
`AZURE_STORAGE_ACCOUNT`, `AZURE_STORAGE_KEY`, `GIT_TOKEN`, `LOCAL_PASSWORD`
and `BLOCKCHAIN_OKTA_APP_SSO_URL`. These belong to components not included in
this deployment and have no effect.

---

## 6. Troubleshooting

**A service restarts repeatedly.** `docker compose logs <service>`. The usual
cause is a value from section 2 left blank.

**`address already in use`.** Another process holds one of the ports in
section 1. Identify it with `ss -tlnp | grep <port>`.

**Postgres connection errors in the first minute.** Some services start
before Postgres finishes initialising and retry automatically. These clear on
their own; an error persisting past two minutes is real.

**Authentication failures against Postgres after changing `.env`.** See the
warning in section 2 — the data volume retains the original credentials. To
start clean:

    docker compose down -v
    docker compose up -d

`down -v` removes every volume this deployment created, which destroys all
data — Postgres, Cassandra, Redis and MinIO contents alike. Your `.env`,
including the encryption keys, is untouched.

**Stopping and starting.**

    docker compose stop           # stop, keep data
    docker compose up -d          # start again
    docker compose down           # remove containers, keep volumes
