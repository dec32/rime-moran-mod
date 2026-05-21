#!/bin/bash

# Target download URL
URL="https://github.com/rimeinn/rime-moran/releases/latest/download/Trad-FullPack.zip"
ZIP_NAME="Trad-FullPack.zip"

echo "Downloading the latest version of Moran..."

# Use curl to download; -L follows redirects, -O keeps the original filename
curl -L -O "$URL"

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Download failed."
    exit 1
fi

echo "Extracting files..."

# -n flag: never overwrite existing files
# -q flag: quiet mode
unzip -nq "$ZIP_NAME"

# Remove the zip archive
rm "$ZIP_NAME"

echo "Complete."