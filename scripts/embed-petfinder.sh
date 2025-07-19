#!/bin/bash

echo "Building Pet-Finder React app..."
cd ./Pet-Finder/client || exit
PUBLIC_URL=/Pet-Finder npm run build

echo "Copying frontend build to personal site..."
rm -rf ../../client/public/Pet-Finder/*
cp -r build/* ../../client/public/Pet-Finder/

echo "Syncing backend files to website..."

cd ../server || exit
mkdir -p ../../server/models
mkdir -p ../../server/seed

cp models.py ../../server/models/petfinder.py
cp seed.py ../../server/seed/petfinder_seed.py
cp config.py ../../server/config.py

# Skip copying Pet-Finder migrations to avoid interfering with website backend

echo "Backend logic integrated. Pet-Finder embedding complete!"