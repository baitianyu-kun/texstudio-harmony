#!/bin/bash
set -e

# --- SDK Path ---
export NATIVE_OHOS_SDK="$TOOL_HOME/sdk/default/openharmony/native"

# --- Configuration ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

QT_SRC_DIR="$PROJECT_ROOT/build/src/qt-harmonyos-5.12.12"
QT_BUILD_DIR="$PROJECT_ROOT/build/build-qt-ohos"
QT_INSTALL_DIR="$PROJECT_ROOT/build/build-qt-ohos-install"

# Target Architecture (arm64-v8a, armeabi-v7a, x86_64)
export OHOS_TARGET_ARCH=${OHOS_TARGET_ARCH:-arm64-v8a}

# --- Validation ---
if [ -z "$NATIVE_OHOS_SDK" ]; then
    echo "Error: NATIVE_OHOS_SDK environment variable is not set."
    echo "Please set it to your OpenHarmony SDK native folder, e.g.:"
    echo "export NATIVE_OHOS_SDK=/path/to/ohos-sdk/linux/native"
    exit 1
fi

if [ ! -d "$QT_SRC_DIR" ]; then
    echo "Error: Qt source directory not found at $QT_SRC_DIR"
    exit 1
fi

# --- Preparation ---
echo "Creating build directory: $QT_BUILD_DIR"
mkdir -p "$QT_BUILD_DIR"
mkdir -p "$QT_INSTALL_DIR"

cd "$QT_BUILD_DIR"

# --- Configure ---
echo "Configuring Qt for OpenHarmony ($OHOS_TARGET_ARCH)..."
"$QT_SRC_DIR/configure" \
    -prefix "$QT_INSTALL_DIR" \
    -xplatform ohos-clang \
    -ohos-arch "$OHOS_TARGET_ARCH" \
    -opensource -confirm-license \
    -nomake tests -nomake examples \
    -shared \
    -silent \
    -skip qtscript \
    -device-option QMAKE_CXXFLAGS+="-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR"
    #-no-opengl \

# --- Build & Install ---
echo "Building Qt..."
make -j$(nproc)

echo "Installing Qt to $QT_INSTALL_DIR..."
make install

echo "Qt build and installation complete."
