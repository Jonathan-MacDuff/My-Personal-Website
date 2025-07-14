#!/bin/bash

echo "Copying Cat Meme Generator to website..."
rm -rf ../client/public/Cat-Meme-Generator/*
cp -r ../Cat-Meme-Generator/* ../client/public/Cat-Meme-Generator/

echo "Cat Meme Generator embedded successfully!"


: <<'END_COMMENT'
For later React deplyment:

#!/bin/bash

# Build Cat Meme Generator React app
cd ../Cat-Meme-Generator/client || exit
PUBLIC_URL=/Cat-Meme-Generator npm run build

# Copy build into website's public folder
rm -rf ../../../client/public/Cat-Meme-Generator/*
cp -r build/* ../../../client/public/Cat-Meme-Generator/

echo "Cat Meme Generator React app embedded successfully!"
END_COMMENT