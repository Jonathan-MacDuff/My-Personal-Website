#!/bin/bash

echo "Building Pet-Finder..."
cd ../Pet-Finder/client || exit
PUBLIC_URL=/Pet-Finder npm run build

echo "Copying Pet-Finder build to website..."
rm -rf ../../../client/public/Pet-Finder/*
cp -r build/* ../../../client/public/Pet-Finder/

echo "Pet-Finder embedded successfully!"