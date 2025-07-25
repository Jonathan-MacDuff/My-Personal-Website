#!/bin/bash

set -e

SRC_DIR="Pet-Finder/server"
DEST_DIR="server/petfinder"

echo "🔄 Updating PetFinder backend in $DEST_DIR..."

# Ensure destination folder exists
mkdir -p "$DEST_DIR"

# Copy and overwrite critical files
for file in app.py config.py models.py seed.py; do
    echo "📦 Copying $file..."
    cp -f "$SRC_DIR/$file" "$DEST_DIR/$file"
done

# Copy migrations (overwrite if needed)
if [ -d "$SRC_DIR/migrations" ]; then
    echo "📂 Copying migrations folder..."
    rm -rf "$DEST_DIR/migrations"
    cp -r "$SRC_DIR/migrations" "$DEST_DIR/migrations"
fi

# Set working directory to petfinder
cd "$DEST_DIR"

# Set Flask app entry point
export FLASK_APP=app.py

# Initialize DB only if migrations folder wasn't already used
if [ ! -d "migrations/versions" ]; then
    echo "🚧 Initializing database..."
    flask db init
fi

echo "🔧 Running migrations..."
flask db migrate -m "Auto migration update"
flask db upgrade

echo "✅ PetFinder server files synced and database migrated successfully."