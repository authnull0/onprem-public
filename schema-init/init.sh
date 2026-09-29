#!/bin/bash
# Idempotent schema init: never drops data on an already-initialised database.
set -euo pipefail

export PGHOST=postgres PGUSER="$DB_USER"
q() { psql -v ON_ERROR_STOP=1 -tAX "$@"; }

echo 'Waiting for Postgres...'
until pg_isready -h postgres -U "$DB_USER" -d postgres >/dev/null 2>&1; do sleep 2; done
sleep 2

# Step 1: kloudone database (did.sql only if its DID schema is missing).
# Checking a table rather than the database means a half-finished import is
# retried on the next run; -1 makes the import all-or-nothing.
kloudone_exists=$(q -d postgres -c "SELECT 1 FROM pg_database WHERE datname='kloudone'")
if [ "$kloudone_exists" != "1" ]; then
  echo 'Creating kloudone database...'
  q -d postgres -c 'CREATE DATABASE kloudone'
fi
kloudone_schema=$(q -d kloudone -c "SELECT 1 FROM information_schema.tables WHERE table_schema='did' AND table_name='organizations'")
if [ "$kloudone_schema" = "1" ]; then
  echo 'DID schema already present in kloudone - skipping'
else
  echo 'Applying DID schema to kloudone...'
  q -d kloudone -1 -f /db-init/did.sql -f /db-init/index.sql
fi

# Step 1.5: remove the legacy tenant URL trigger. It rewrote site_url to
# http://<SYSTEM_IP>/<org>, but login looks tenants up by DOMAIN_URL, so every
# tenant created with it active failed with "Tenant not found or inactive".
q -d kloudone <<SQL
DROP TRIGGER IF EXISTS trigger_fix_tenant_url ON did.tenants;
DROP FUNCTION IF EXISTS fix_tenant_url();
SQL

# Step 2: DID schema in $DB_NAME (did.sql only if did.organizations is missing)
schema_exists=$(q -d "$DB_NAME" -c "SELECT 1 FROM information_schema.tables WHERE table_schema='did' AND table_name='organizations'")
if [ "$schema_exists" = "1" ]; then
  echo "DID schema already present in $DB_NAME - skipping"
else
  echo "Applying DID schema to $DB_NAME..."
  q -d "$DB_NAME" -1 -f /db-init/did.sql -f /db-init/index.sql
fi

echo '=== All database initializations complete ==='
