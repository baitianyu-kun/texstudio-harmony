#!/bin/bash
set -e

# --- Configuration ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

TARGET_BASE_DIR="$PROJECT_ROOT/build/src"
POPPLER_DIR="$TARGET_BASE_DIR/poppler"

# --- Preparation ---
echo "Creating directory: $TARGET_BASE_DIR"
mkdir -p "$TARGET_BASE_DIR"
cd "$TARGET_BASE_DIR"

# --- Download ---
if [ ! -d "$POPPLER_DIR/.git" ]; then
    echo "Cloning Poppler repository..."
    git clone https://gitlab.freedesktop.org/poppler/poppler.git
else
    echo "Poppler repository already exists. Fetching updates..."
    cd poppler
    git fetch origin
    cd ..
fi

echo "Checking out poppler-24.12.0..."
cd poppler
git checkout poppler-24.12.0

echo "Poppler download and checkout complete."
