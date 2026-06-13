#!/bin/bash

# Detect Proxy
os_type="$(uname -s)"
proxy=""

if [[ "$os_type" == MINGW* || "$os_type" == MSYS* || "$os_type" == CYGWIN* ]]; then
    proxy=$(reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+")
elif [[ "$os_type" == "Darwin" ]]; then
    port=$(networksetup -getwebproxy "Wi-Fi" 2>/dev/null | grep Port | awk '{print $2}')
    server=$(networksetup -getwebproxy "Wi-Fi" 2>/dev/null | grep Server | awk '{print $2}')
    
    if [[ "$port" == "0" || -z "$server" ]]; then
        port=$(networksetup -getwebproxy "Ethernet" 2>/dev/null | grep Port | awk '{print $2}')
        server=$(networksetup -getwebproxy "Ethernet" 2>/dev/null | grep Server | awk '{print $2}')
    fi

    if [[ "$port" != "0" && -n "$server" ]]; then
        proxy="$server:$port"
    fi
fi

## Apply proxy
if [[ -n "$proxy" ]]; then
    export http_proxy="http://$proxy"
    export https_proxy="http://$proxy"
    echo "Proxy detected: $proxy"
else
    echo "No proxy detected, using direct connection."
fi

# Target download URL
URL="https://github.com/rimeinn/rime-moran/releases/latest/download/Trad-FullPack.zip"
ZIP_NAME="Trad-FullPack.zip"
MODEL_URL="https://media.githubusercontent.com/media/rimeinn/octagram-data/refs/heads/master/models/fcitx/fcitx-zh-hant.gram?download=true"

echo "Downloading the latest version of Moran..."

# Use curl to download; -L follows redirects, -O keeps the original filename
curl -L -O "$URL"

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Download failed."
    exit 1
fi

echo "Extracting files..."

# -q flag: quiet mode
unzip -q "$ZIP_NAME"

# Remove the zip archive
rm "$ZIP_NAME"

echo "Downloading the language model..."

# Download the model
curl -L -O "$MODEL_URL"

echo "Complete."