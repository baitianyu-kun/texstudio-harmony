#!/bin/bash
set -e

# Configuration
TEXLIVE_URL="https://mirrors.tuna.tsinghua.edu.cn/tex-historic-archive/systems/texlive/2025/texlive-20250308-source.tar.xz"
TEXLIVE_ARCHIVE=$(basename "$TEXLIVE_URL")
TARGET_BASE_DIR="build/src"
FINAL_DIR_NAME="texlive-source"

# Ensure we are in the project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"
cd "$PROJECT_ROOT"

# 1. Create directory
echo "Creating directory: $TARGET_BASE_DIR"
mkdir -p "$TARGET_BASE_DIR"

# 2. Download
if [ ! -f "$TARGET_BASE_DIR/$TEXLIVE_ARCHIVE" ]; then
    echo "Downloading $TEXLIVE_URL..."
    curl -L "$TEXLIVE_URL" -o "$TARGET_BASE_DIR/$TEXLIVE_ARCHIVE"
else
    echo "Archive already exists: $TEXLIVE_ARCHIVE"
fi

# 3. Extract
echo "Extracting $TEXLIVE_ARCHIVE..."
# Get the top-level directory name from the archive
EXTRACTED_DIR=$(tar -tf "$TARGET_BASE_DIR/$TEXLIVE_ARCHIVE" | head -n 1 | cut -f1 -d"/")
tar -xJf "$TARGET_BASE_DIR/$TEXLIVE_ARCHIVE" -C "$TARGET_BASE_DIR"

# 4. Rename
if [ "$EXTRACTED_DIR" != "$FINAL_DIR_NAME" ]; then
    echo "Renaming $EXTRACTED_DIR to $FINAL_DIR_NAME..."
    if [ -d "$TARGET_BASE_DIR/$FINAL_DIR_NAME" ]; then
        echo "Removing existing directory $TARGET_BASE_DIR/$FINAL_DIR_NAME"
        rm -rf "$TARGET_BASE_DIR/$FINAL_DIR_NAME"
    fi
    mv "$TARGET_BASE_DIR/$EXTRACTED_DIR" "$TARGET_BASE_DIR/$FINAL_DIR_NAME"
fi

echo "TeX Live download and extraction complete."
