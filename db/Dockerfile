FROM postgres:15

# (Optional defaults – you can override at `docker run`)
ENV POSTGRES_DB=mercur_db \
    POSTGRES_USER=postgres \
    POSTGRES_PASSWORD=postgres

# Run these files on first start (fresh data dir)
COPY init/*.sql /docker-entrypoint-initdb.d/