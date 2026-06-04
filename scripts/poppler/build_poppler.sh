#!/bin/bash
set -e

# --- SDK Path ---
export NATIVE_OHOS_SDK="$TOOL_HOME/sdk/default/openharmony/native"

# --- Configuration ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

POPPLER_SRC_DIR="$PROJECT_ROOT/third_party/poppler"
POPPLER_BUILD_DIR="$PROJECT_ROOT/build/build-poppler-ohos"
QT_INSTALL_DIR="$PROJECT_ROOT/build/build-qt-ohos-install"
POPPLER_INSTALL_DIR="$PROJECT_ROOT/build/build-poppler-ohos-install"

# Target Architecture
export OHOS_TARGET_ARCH=${OHOS_TARGET_ARCH:-arm64-v8a}

if [ ! -d "$POPPLER_SRC_DIR" ]; then
    echo "Error: poppler source directory not found at $POPPLER_SRC_DIR"
    exit 1
fi

echo "Creating build directory: $POPPLER_BUILD_DIR"
mkdir -p "$POPPLER_BUILD_DIR"
mkdir -p "$POPPLER_INSTALL_DIR"

cd "$POPPLER_BUILD_DIR"

# --- Build ---
echo "Running CMake for Poppler ($OHOS_TARGET_ARCH)..."
cmake "$POPPLER_SRC_DIR" \
    -DCMAKE_TOOLCHAIN_FILE="$NATIVE_OHOS_SDK/build/cmake/ohos.toolchain.cmake" \
    -DOHOS_ARCH="$OHOS_TARGET_ARCH" \
    -DCMAKE_PREFIX_PATH="$QT_INSTALL_DIR" \
    -DCMAKE_FIND_ROOT_PATH="$QT_INSTALL_DIR" \
    -DCMAKE_INSTALL_PREFIX="$POPPLER_INSTALL_DIR" \
    -DENABLE_QT5=ON \
    -DENABLE_QT6=OFF \
    -DENABLE_CPP=OFF \
    -DENABLE_GLIB=OFF \
    -DENABLE_GOBJECT_INTROSPECTION=OFF \
    -DENABLE_UTILS=OFF \
    -DENABLE_LIBOPENJPEG=none \
    -DENABLE_CMS=none \
    -DENABLE_DCTDECODER=unmaintained \
    -DENABLE_LIBCURL=OFF \
    -DENABLE_ZLIB=OFF \
    -DBUILD_GTK_TESTS=OFF \
    -DBUILD_QT5_TESTS=OFF \
    -DBUILD_QT6_TESTS=OFF \
    -DBUILD_CPP_TESTS=OFF \
    -DWITH_NSS3=OFF \
    -DFONT_CONFIGURATION=generic \
    -DENABLE_BOOST=OFF \
    -DCMAKE_DISABLE_FIND_PACKAGE_Cairo=ON \
    -DCMAKE_DISABLE_FIND_PACKAGE_NSS3=ON \
    -DCMAKE_DISABLE_FIND_PACKAGE_GLIB=ON \
    -DCMAKE_DISABLE_FIND_PACKAGE_GObject=ON \
    -DCMAKE_DISABLE_FIND_PACKAGE_GTK=ON

echo "Compiling Poppler..."
make -j$(nproc)
make install

echo "Poppler build complete. Installed to $POPPLER_INSTALL_DIR"
