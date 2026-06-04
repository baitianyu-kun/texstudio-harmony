#!/bin/bash
set -e

# --- SDK Path ---
export NATIVE_OHOS_SDK="$TOOL_HOME/sdk/default/openharmony/native"

# --- Configuration ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

TEXSTUDIO_SRC_DIR="$PROJECT_ROOT/third_party/texstudio"
TEXSTUDIO_BUILD_DIR="$PROJECT_ROOT/build/build-texstudio-ohos"
QT_INSTALL_DIR="$PROJECT_ROOT/build/build-qt-ohos-install"
POPPLER_INSTALL_DIR="$PROJECT_ROOT/build/build-poppler-ohos-install"

# Target Architecture (must match the one used for Qt)
export OHOS_TARGET_ARCH=${OHOS_TARGET_ARCH:-arm64-v8a}

# --- Validation ---
if [ -z "$NATIVE_OHOS_SDK" ]; then
    echo "Error: NATIVE_OHOS_SDK environment variable is not set."
    exit 1
fi

if [ ! -d "$QT_INSTALL_DIR" ]; then
    echo "Error: Qt installation not found at $QT_INSTALL_DIR."
    echo "Please run download_qt.sh and build_qt.sh first."
    exit 1
fi

if [ ! -d "$POPPLER_INSTALL_DIR" ]; then
    echo "Error: Poppler installation not found at $POPPLER_INSTALL_DIR."
    echo "Please run build_poppler.sh first."
    exit 1
fi

# Add OHOS toolchain to PATH for compilation
export PATH="$NATIVE_OHOS_SDK/llvm/bin:$PATH"

# Set PKG_CONFIG_PATH so FindPoppler.cmake can locate poppler-qt5
export PKG_CONFIG_PATH="$POPPLER_INSTALL_DIR/lib/pkgconfig:$QT_INSTALL_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"

# --- Preparation ---
echo "Creating build directory: $TEXSTUDIO_BUILD_DIR"
mkdir -p "$TEXSTUDIO_BUILD_DIR"

cd "$TEXSTUDIO_BUILD_DIR"

# --- Build ---
echo "Running CMake for TeXstudio ($OHOS_TARGET_ARCH)..."
cmake "$TEXSTUDIO_SRC_DIR" \
    -DCMAKE_TOOLCHAIN_FILE="$NATIVE_OHOS_SDK/build/cmake/ohos.toolchain.cmake" \
    -DOHOS_ARCH="$OHOS_TARGET_ARCH" \
    -DCMAKE_PREFIX_PATH="$QT_INSTALL_DIR;$POPPLER_INSTALL_DIR" \
    -DCMAKE_FIND_ROOT_PATH="$QT_INSTALL_DIR;$POPPLER_INSTALL_DIR" \
    -DPoppler_INCLUDE_DIR="$POPPLER_INSTALL_DIR/include/poppler" \
    -DPoppler_LIBRARY="$POPPLER_INSTALL_DIR/lib/libpoppler.so" \
    -DPoppler_VERSION_STRING="21.03.0" \
    -DPoppler_qt5_INCLUDE_DIR="$POPPLER_INSTALL_DIR/include/poppler/qt5" \
    -DPoppler_qt5_LIBRARY="$POPPLER_INSTALL_DIR/lib/libpoppler-qt5.so" \
    -DPoppler_qt5_VERSION_STRING="21.03.0" \
    -DQT_VERSION_MAJOR=5 \
    -DTEXSTUDIO_ENABLE_TESTS=OFF \
    -DPHONON=OFF

echo "Compiling TeXstudio..."
make -j$(nproc)

echo "TeXstudio build complete."
echo "The binary (libtexstudio.so) can be found in $TEXSTUDIO_BUILD_DIR"
