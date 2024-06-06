#!/bin/sh

# Wait for PostgreSQL to be ready
if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

# Apply database migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --no-input --clear

# Execute the command passed to the container
exec "$@"
