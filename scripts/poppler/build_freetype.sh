#!/bin/bash
set -e

# --- SDK Path ---
export NATIVE_OHOS_SDK="$TOOL_HOME/sdk/default/openharmony/native"

# --- Configuration ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

FREETYPE_SRC_DIR="$PROJECT_ROOT/build/src/freetype"
FREETYPE_BUILD_DIR="$PROJECT_ROOT/build/build-freetype-ohos"
FREETYPE_INSTALL_DIR="$PROJECT_ROOT/build/build-qt-ohos-install"

export OHOS_TARGET_ARCH=${OHOS_TARGET_ARCH:-arm64-v8a}

if [ ! -d "$FREETYPE_SRC_DIR" ]; then
    echo "Downloading FreeType source..."
    mkdir -p "$(dirname "$FREETYPE_SRC_DIR")"
    git clone --depth 1 -b VER-2-13-2 https://github.com/freetype/freetype.git "$FREETYPE_SRC_DIR"
fi

echo "Creating FreeType build directory..."
mkdir -p "$FREETYPE_BUILD_DIR"
cd "$FREETYPE_BUILD_DIR"

echo "Running CMake for FreeType ($OHOS_TARGET_ARCH)..."
cmake "$FREETYPE_SRC_DIR" \
    -DCMAKE_TOOLCHAIN_FILE="$NATIVE_OHOS_SDK/build/cmake/ohos.toolchain.cmake" \
    -DOHOS_ARCH="$OHOS_TARGET_ARCH" \
    -DCMAKE_INSTALL_PREFIX="$FREETYPE_INSTALL_DIR" \
    -DBUILD_SHARED_LIBS=OFF \
    -DFT_DISABLE_ZLIB=ON \
    -DFT_DISABLE_BZIP2=ON \
    -DFT_DISABLE_PNG=ON \
    -DFT_DISABLE_HARFBUZZ=ON \
    -DFT_DISABLE_BROTLI=ON

echo "Compiling FreeType..."
make -j$(nproc)
make install

echo "FreeType installed to $FREETYPE_INSTALL_DIR"
