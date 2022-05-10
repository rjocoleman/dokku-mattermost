#!/bin/sh

eval "$(shdotenv -e /.env)"

exec /entrypoint.sh "$@"
