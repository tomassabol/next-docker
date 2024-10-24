#!/bin/bash

# Env Vars
POSTGRES_USER="myuser"
POSTGRES_PASSWORD=$(openssl rand -base64 12)  # Generate a random 12-character password
POSTGRES_DB="mydatabase"
SECRET_KEY="my-secret" # for the demo app
NEXT_PUBLIC_SAFE_KEY="safe-key" # for the demo app
DOMAIN_NAME="nextselfhost.dev" # replace with your own
EMAIL="your-email@example.com" # replace with your own

# For Docker internal communication ("db" is the name of Postgres container)
DATABASE_URL="postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@db:5432/$POSTGRES_DB"

# For external tools (like Drizzle Studio)
DATABASE_URL_EXTERNAL="postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost:5432/$POSTGRES_DB"

# Create the .env file inside the app directory (~/myapp.env)
echo "POSTGRES_USER=$POSTGRES_USER" > ".env"
echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> ".env"
echo "POSTGRES_DB=$POSTGRES_DB" >> ".env"
echo "DATABASE_URL=$DATABASE_URL" >> ".env"
echo "DATABASE_URL_EXTERNAL=$DATABASE_URL_EXTERNAL" >> ".env"

# These are just for the demo of env vars
echo "SECRET_KEY=$SECRET_KEY" >> ".env"
echo "NEXT_PUBLIC_SAFE_KEY=$NEXT_PUBLIC_SAFE_KEY" >> ".env"

# Build and run the Docker containers from the app directory (~/myapp)
docker compose up --build -d

# Check if Docker Compose started correctly
if ! docker compose ps | grep "Up"; then
  echo "Docker containers failed to start. Check logs with 'docker compose logs'."
  exit 1
fi

# Output final message
echo "Deployment complete. Your Next.js app and PostgreSQL database are now running. 
Next.js is available at https://$DOMAIN_NAME, and the PostgreSQL database is accessible from the web service.

The .env file has been created with the following values:
- POSTGRES_USER
- POSTGRES_PASSWORD (randomly generated)
- POSTGRES_DB
- DATABASE_URL
- DATABASE_URL_EXTERNAL
- SECRET_KEY
- NEXT_PUBLIC_SAFE_KEY"
