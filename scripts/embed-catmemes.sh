#!/bin/bash

set -e

cd ../Cat-Meme-Generator/client || exit

echo "🔧 Updating BACKEND_URL for production..."
sed -i.bak 's|const BACKEND_URL = "http://localhost:5000"|const BACKEND_URL = "https://my-personal-website-ss2x.onrender.com/catmemes"|' src/App.js

PUBLIC_URL=/Cat-Meme-Generator npm run build

mv src/App.js.bak src/App.js

rm -rf ../../client/public/Cat-Meme-Generator/*
cp -r build/* ../../client/public/Cat-Meme-Generator/

echo "Cat Meme Generator React app embedded successfully!"

echo "📦 Syncing Cat Meme Generator backend..."

SRC_BACKEND_DIR="../server"
DEST_BACKEND_DIR="../../server/catmemes"

mkdir -p "$DEST_BACKEND_DIR"

rsync -av --exclude='__pycache__' --exclude='*.pyc' --exclude='*.pyo' "$SRC_BACKEND_DIR/" "$DEST_BACKEND_DIR/"

echo "Backend synced to $DEST_BACKEND_DIR"

echo "Cat Meme Generator fully embedded!"