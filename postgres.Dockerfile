FROM postgres:12.1

# copy db init script into image
COPY ["./scripts/funwar_initdb.sh", "/docker-entrypoint-initdb.d"]
