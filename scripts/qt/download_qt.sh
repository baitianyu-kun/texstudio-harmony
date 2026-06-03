#!/bin/bash
set -e

# Configuration
QT_URL="https://download.qt.io/snapshots/qt/qt-for-harmonyos/5.12.12/qt-harmonyos-src-5.12.12-20260403.tar.xz"
QT_ARCHIVE=$(basename "$QT_URL")
TARGET_BASE_DIR="build/qt/src"
FINAL_DIR_NAME="qt-harmonyos-5.12.12"

# Ensure we are in the project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"
cd "$PROJECT_ROOT"

# 1. Create directory
echo "Creating directory: $TARGET_BASE_DIR"
mkdir -p "$TARGET_BASE_DIR"

# 2. Download
if [ ! -f "$TARGET_BASE_DIR/$QT_ARCHIVE" ]; then
    echo "Downloading $QT_URL..."
    curl -L "$QT_URL" -o "$TARGET_BASE_DIR/$QT_ARCHIVE"
else
    echo "Archive already exists: $QT_ARCHIVE"
fi

# 3. Extract
echo "Extracting $QT_ARCHIVE..."
# Get the top-level directory name from the archive
EXTRACTED_DIR=$(tar -tf "$TARGET_BASE_DIR/$QT_ARCHIVE" | head -n 1 | cut -f1 -d"/")
tar -xvf "$TARGET_BASE_DIR/$QT_ARCHIVE" -C "$TARGET_BASE_DIR"

# 4. Rename
if [ "$EXTRACTED_DIR" != "$FINAL_DIR_NAME" ]; then
    echo "Renaming $EXTRACTED_DIR to $FINAL_DIR_NAME..."
    if [ -d "$TARGET_BASE_DIR/$FINAL_DIR_NAME" ]; then
        echo "Removing existing directory $TARGET_BASE_DIR/$FINAL_DIR_NAME"
        rm -rf "$TARGET_BASE_DIR/$FINAL_DIR_NAME"
    fi
    mv "$TARGET_BASE_DIR/$EXTRACTED_DIR" "$TARGET_BASE_DIR/$FINAL_DIR_NAME"
fi

echo "Qt download and extraction complete."
