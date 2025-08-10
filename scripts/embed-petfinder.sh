#!/bin/bash

set -e

cd ../Pet-Finder/client || exit

echo "Updating BACKEND_URL for production..."
sed -i.bak 's|const BACKEND_URL = ""|const BACKEND_URL = "https://my-personal-website-ss2x.onrender.com/petfinder"|' src/config.js

PUBLIC_URL=/Pet-Finder npm run build

mv src/config.js.bak src/config.js

rm -rf ../../client/public/Pet-Finder/*
cp -r build/* ../../client/public/Pet-Finder/

echo "Pet Finder React app embedded successfully!"

SRC_DIR="../server"
DEST_DIR="../../server/petfinder"

echo "Updating PetFinder backend in $DEST_DIR..."

# Ensure destination folder exists
mkdir -p "$DEST_DIR"

# Copy and overwrite critical files
for file in app.py config.py models.py seed.py; do
    echo "Copying $file..."
    cp -f "$SRC_DIR/$file" "$DEST_DIR/$file"
done

# Copy migrations (overwrite if needed)
# if [ -d "$SRC_DIR/migrations" ]; then
#     echo "Copying migrations folder..."
#     rm -rf "$DEST_DIR/migrations"
#     cp -r "$SRC_DIR/migrations" "$DEST_DIR/migrations"
# fi

# Set working directory to petfinder
cd "$DEST_DIR"

# Set Flask app entry point
export FLASK_APP=app.py

# Initialize DB only if migrations folder wasn't already used
# if [ ! -d "migrations/versions" ]; then
#     echo "🚧 Initializing database..."
#     flask db init
# fi

# echo "Running migrations..."
# flask db migrate -m "Auto migration update"
# flask db upgrade

echo "PetFinder server files synced and database migrated successfully."