#!/bin/bash
set -e

# --- Configuration ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

# Source directories
QT_SRC_DIR="$PROJECT_ROOT/build/src/qtbase"
QTTOOLS_SRC_DIR="$PROJECT_ROOT/build/src/qttools"
QTSVG_SRC_DIR="$PROJECT_ROOT/build/src/qtsvg"
QTDECLARATIVE_SRC_DIR="$PROJECT_ROOT/build/src/qtdeclarative"
QT5COMPAT_SRC_DIR="$PROJECT_ROOT/build/src/qt5compat"

# Build directories
QT_BUILD_DIR="$PROJECT_ROOT/build/build-qt-host"
QTTOOLS_BUILD_DIR="$PROJECT_ROOT/build/build-qttools-host"
QTSVG_BUILD_DIR="$PROJECT_ROOT/build/build-qtsvg-host"
QTDECLARATIVE_BUILD_DIR="$PROJECT_ROOT/build/build-qtdeclarative-host"
QT5COMPAT_BUILD_DIR="$PROJECT_ROOT/build/build-qt5compat-host"

# Install directory
QT_ALL_INSTALL_DIR="$PROJECT_ROOT/build/build-qt-host-install"

# Target Architecture & Jobs
export PARALLEL_JOBS=${PARALLEL_JOBS:-8}

# --- Validation ---
if [ ! -d "$QT_SRC_DIR" ]; then
    echo "Error: QtBase source directory not found at $QT_SRC_DIR"
    exit 1
fi


# ==========================================
# QtBase
# ==========================================

# --- Configure QtBase ---
echo "Creating QtBase host build directory: $QT_BUILD_DIR"
mkdir -p "$QT_BUILD_DIR"
cd "$QT_BUILD_DIR"

echo "Configuring QtBase for host..."
"$QT_SRC_DIR/configure" \
    -prefix "$QT_ALL_INSTALL_DIR" \
    -opensource \
    -confirm-license \
    -no-framework \
    -nomake examples \
    -nomake tests \
    -verbose

# --- Build QtBase ---
echo "Building QtBase host..."
cmake --build . --parallel "$PARALLEL_JOBS"

# --- Install QtBase ---
echo "Installing QtBase..."
cmake --install . --prefix "$QT_ALL_INSTALL_DIR"
echo "QtBase build and install complete."


# ==========================================
# QtTools
# ==========================================

# --- Configure QtTools ---
echo "Creating QtTools host build directory: $QTTOOLS_BUILD_DIR"
mkdir -p "$QTTOOLS_BUILD_DIR"
cd "$QTTOOLS_BUILD_DIR"
    
echo "Configuring QtTools for host..."
"$QT_BUILD_DIR/bin/qt-cmake" "$QTTOOLS_SRC_DIR"
    
# --- Build QtTools ---
echo "Building QtTools host..."
cmake --build . --parallel "$PARALLEL_JOBS"
    
# --- Install QtTools ---
echo "Installing QtTools..."
cmake --install . --prefix "$QT_ALL_INSTALL_DIR"
echo "QtTools build and install complete."


# ==========================================
# QtSvg
# ==========================================

# --- Configure QtSvg ---
echo "Creating QtSvg host build directory: $QTSVG_BUILD_DIR"
mkdir -p "$QTSVG_BUILD_DIR"
cd "$QTSVG_BUILD_DIR"
    
echo "Configuring QtSvg for host..."
"$QT_BUILD_DIR/bin/qt-cmake" "$QTSVG_SRC_DIR"
    
# --- Build QtSvg ---
echo "Building QtSvg host..."
cmake --build . --parallel "$PARALLEL_JOBS"
    
# --- Install QtSvg ---
echo "Installing QtSvg..."
cmake --install . --prefix "$QT_ALL_INSTALL_DIR"
echo "QtSvg build and install complete."


# ==========================================
# QtDeclarative
# ==========================================

# --- Configure QtDeclarative ---
echo "Creating QtDeclarative host build directory: $QTDECLARATIVE_BUILD_DIR"
mkdir -p "$QTDECLARATIVE_BUILD_DIR"
cd "$QTDECLARATIVE_BUILD_DIR"
    
echo "Configuring QtDeclarative for host..."
"$QT_BUILD_DIR/bin/qt-cmake" "$QTDECLARATIVE_SRC_DIR"
    
# --- Build QtDeclarative ---
echo "Building QtDeclarative host..."
cmake --build . --parallel "$PARALLEL_JOBS"
    
# --- Install QtDeclarative ---
echo "Installing QtDeclarative..."
cmake --install . --prefix "$QT_ALL_INSTALL_DIR"
echo "QtDeclarative build and install complete."


# ==========================================
# Qt5Compat
# ==========================================

# --- Configure Qt5Compat ---
echo "Creating Qt5Compat host build directory: $QT5COMPAT_BUILD_DIR"
mkdir -p "$QT5COMPAT_BUILD_DIR"
cd "$QT5COMPAT_BUILD_DIR"
    
echo "Configuring Qt5Compat for host..."
"$QT_BUILD_DIR/bin/qt-cmake" "$QT5COMPAT_SRC_DIR"
    
# --- Build Qt5Compat ---
echo "Building Qt5Compat host..."
cmake --build . --parallel "$PARALLEL_JOBS"
    
# --- Install Qt5Compat ---
echo "Installing Qt5Compat..."
cmake --install . --prefix "$QT_ALL_INSTALL_DIR"
echo "Qt5Compat build and install complete."
