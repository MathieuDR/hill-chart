#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

# Wait until Postgres is ready
# Parse the DATABASE_URL to extract the host and port
DATABASE_USER=$(echo "$DATABASE_URL" | sed -n 's/^ecto:\/\/\([^:]*\):.*@.*$/\1/p')
DATABASE_HOST=$(echo "$DATABASE_URL" | sed -n 's/^ecto:\/\/[^@]*@\([^\/]*\)\/.*$/\1/p')

while ! pg_isready -q -h "$DATABASE_HOST" -U "$DATABASE_USER"
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Run migrations
echo "Running database migrations..."
bin/hill_chart eval "HillChart.Release.migrate"

# Start the Phoenix server
echo "Starting Phoenix server..."
exec bin/hill_chart start
