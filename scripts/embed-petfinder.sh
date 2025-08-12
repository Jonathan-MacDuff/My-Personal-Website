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

echo "Syncing Pet Finder backend..."

SRC_BACKEND_DIR="../server"
DEST_BACKEND_DIR="../../server/petfinder"

# rsync excluding migrations folder and database files (app.db, instance folder, migrations)
rsync -av --exclude='__pycache__' --exclude='*.pyc' --exclude='*.pyo' --exclude='migrations' --exclude='instance' --exclude='app.db' "$SRC_BACKEND_DIR/" "$DEST_BACKEND_DIR/"

# Convert Flask app to Blueprint in routes.py (adjust paths and names accordingly)
sed -i 's/#1/from flask import Blueprint/' "$DEST_BACKEND_DIR/routes.py"
sed -i 's/#2/petfinder_bp = Blueprint("petfinder", __name__)/' "$DEST_BACKEND_DIR/routes.py"

# Remove any CORS(app) calls and add CORS for the blueprint
sed -i '/petfinder_bp = Blueprint("petfinder", __name__)/a\
\
from flask_cors import CORS\n\
CORS(petfinder_bp, origins=["https://autistic-insight.com", "https://www.autistic-insight.com"])\
' "$DEST_BACKEND_DIR/routes.py"

echo "Backend synced and converted to blueprint in $DEST_BACKEND_DIR"

echo "Pet Finder fully embedded!"