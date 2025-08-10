#!/bin/bash

set -e

cd ../Cat-Meme-Generator/client || exit

echo "Updating BACKEND_URL for production..."
sed -i.bak 's|const BACKEND_URL = "http://localhost:5000"|const BACKEND_URL = "https://my-personal-website-ss2x.onrender.com/catmemes"|' src/App.js

PUBLIC_URL=/Cat-Meme-Generator npm run build

mv src/App.js.bak src/App.js

rm -rf ../../client/public/Cat-Meme-Generator/*
cp -r build/* ../../client/public/Cat-Meme-Generator/

echo "Cat Meme Generator React app embedded successfully!"

echo "Syncing Cat Meme Generator backend..."

SRC_BACKEND_DIR="../server"
DEST_BACKEND_DIR="../../server/catmemes"

rsync -av --exclude='__pycache__' --exclude='*.pyc' --exclude='*.pyo' "$SRC_BACKEND_DIR/" "$DEST_BACKEND_DIR/"

sed -i 's/from flask import Flask, jsonify/from flask import Blueprint, jsonify/' "$DEST_BACKEND_DIR/app.py"
sed -i 's/@app.route/@catmemes_bp.route/g' "$DEST_BACKEND_DIR/app.py"
sed -i 's/app = Flask(__name__)/catmemes_bp = Blueprint("catmemes", __name__)/' "$DEST_BACKEND_DIR/app.py"
sed -i '/if __name__ == .__main__./,/app.run/d' "$DEST_BACKEND_DIR/app.py"
sed -i '/CORS(app)/d' "$DEST_BACKEND_DIR/app.py"
sed -i '/catmemes_bp = Blueprint("catmemes", __name__)/a\
\
CORS(catmemes_bp, origins=["https://autistic-insight.com", "https://www.autistic-insight.com"])
' "$DEST_BACKEND_DIR/app.py"

echo "Backend synced to $DEST_BACKEND_DIR"

echo "Cat Meme Generator fully embedded!"