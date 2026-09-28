#!/bin/bash
# Idempotent schema init: never drops data on an already-initialised database.
set -euo pipefail

export PGHOST=postgres PGUSER="$DB_USER"
q() { psql -v ON_ERROR_STOP=1 -tAX "$@"; }

echo 'Waiting for Postgres...'
until pg_isready -h postgres -U "$DB_USER" -d postgres >/dev/null 2>&1; do sleep 2; done
sleep 2

# Step 1: kloudone database (did.sql only if the database does not exist)
kloudone_exists=$(q -d postgres -c "SELECT 1 FROM pg_database WHERE datname='kloudone'")
if [ "$kloudone_exists" = "1" ]; then
  echo 'kloudone exists - skipping schema import'
else
  echo 'Creating kloudone database...'
  q -d postgres -c 'CREATE DATABASE kloudone'
  q -d kloudone -f /db-init/did.sql
  q -d kloudone -f /db-init/index.sql
fi

# Step 1.5: tenant URL trigger (safe to re-run)
q -d kloudone <<SQL
CREATE OR REPLACE FUNCTION fix_tenant_url() RETURNS TRIGGER AS \$fn\$
BEGIN
    NEW.site_url := 'http://${SYSTEM_IP}/' || split_part(NEW.site_url, '.', 2);
    RETURN NEW;
END;
\$fn\$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_fix_tenant_url ON did.tenants;
CREATE TRIGGER trigger_fix_tenant_url
BEFORE INSERT ON did.tenants
FOR EACH ROW EXECUTE FUNCTION fix_tenant_url();
SQL

# Step 2: DID schema in $DB_NAME (did.sql only if did.organizations is missing)
schema_exists=$(q -d "$DB_NAME" -c "SELECT 1 FROM information_schema.tables WHERE table_schema='did' AND table_name='organizations'")
if [ "$schema_exists" = "1" ]; then
  echo "DID schema already present in $DB_NAME - skipping"
else
  echo "Applying DID schema to $DB_NAME..."
  q -d "$DB_NAME" -f /db-init/did.sql
  q -d "$DB_NAME" -f /db-init/index.sql
fi

echo '=== All database initializations complete ==='
