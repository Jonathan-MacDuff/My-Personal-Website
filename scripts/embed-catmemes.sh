#!/bin/bash

cd ../Cat-Meme-Generator/client || exit
PUBLIC_URL=/Cat-Meme-Generator npm run build

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