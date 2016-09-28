#!/bin/bash

set -e

# Check to see if the database is available before starting the application
until psql -h db -U "postgres"; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

# Create teh tables if they aren't already created before startup
./create_db

# start the app, binding it to 0.0.0.0 so it is available outside the container
gunicorn -b 0.0.0.0 subrosa:app
