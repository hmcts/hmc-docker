FROM postgres:11.5

COPY init-db.sh /docker-entrypoint-initdb.d

HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD psql -c 'select 1' -d hmc_cft_hearing_service -U ${HMC_DB_USERNAME}

EXPOSE 5432
