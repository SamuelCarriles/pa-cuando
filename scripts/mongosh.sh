#!/usr/bin/env bash
exec sudo docker compose exec mongo sh -c \
'mongosh -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin "$@"' \
  mongosh "$@"
