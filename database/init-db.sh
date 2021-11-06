#!/usr/bin/env bash

set -e

if [ -z "$HMC_DB_USERNAME" ] || [ -z "$HMC_DB_PASSWORD" ]; then
  echo "ERROR: Missing environment variable. Set value for both 'HMC_DB_USERNAME' and 'HMC_DB_PASSWORD'."
  exit 1
fi

# Create roles and databases
psql -v ON_ERROR_STOP=1 --username postgres --set USERNAME=$HMC_DB_USERNAME --set PASSWORD=$HMC_DB_PASSWORD <<-EOSQL
  CREATE USER :USERNAME WITH PASSWORD ':PASSWORD';
EOSQL

for service in hmc_cft_hearing_service; do
  echo "Database $service: Creating..."
psql -v ON_ERROR_STOP=1 --username postgres --set USERNAME=$HMC_DB_USERNAME --set PASSWORD=$HMC_DB_PASSWORD --set DATABASE=$service <<-EOSQL
  CREATE DATABASE :DATABASE
    WITH OWNER = :USERNAME
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;
EOSQL
  echo "Database $service: Created"
done
