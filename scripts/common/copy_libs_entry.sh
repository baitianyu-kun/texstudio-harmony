#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

QT_INSTALL_DIR="$PROJECT_ROOT/build/build-qt-ohos-install"
POPPLER_INSTALL_DIR="$PROJECT_ROOT/build/build-poppler-ohos-install"
TEXSTUDIO_BUILD_DIR="$PROJECT_ROOT/build/build-texstudio-ohos"
HAP_LIBS_DIR="$PROJECT_ROOT/texstudio_harmony/entry/libs/arm64-v8a"

mkdir -p $HAP_LIBS_DIR

echo "Copying Qt shared libraries..."

cp "$QT_INSTALL_DIR/plugins/platforms/libqohos.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5Multimedia.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5PrintSupport.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5Svg.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5Xml.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5Qml.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5Concurrent.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5DBus.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5Network.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5Widgets.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5Gui.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5Core.so" "$HAP_LIBS_DIR/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/lib/libQt5OhosExtras.so" "$HAP_LIBS_DIR/" 2>/dev/null || true

mkdir -p "$HAP_LIBS_DIR/imageformats"
mkdir -p "$HAP_LIBS_DIR/iconengines"
cp "$QT_INSTALL_DIR/plugins/imageformats/libqsvg.so" "$HAP_LIBS_DIR/imageformats/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/plugins/imageformats/libqjpeg.so" "$HAP_LIBS_DIR/imageformats/" 2>/dev/null || true
cp "$QT_INSTALL_DIR/plugins/iconengines/libqsvgicon.so" "$HAP_LIBS_DIR/iconengines/" 2>/dev/null || true

echo "Copying TexStudio shared libraries..."
cp "$TEXSTUDIO_BUILD_DIR/libtexstudio.so" "$HAP_LIBS_DIR/" 2>/dev/null || true

echo "Copying Poppler shared libraries..."
cp "$POPPLER_INSTALL_DIR/lib/libpoppler.so.108.0.0" "$HAP_LIBS_DIR/libpoppler.so.108" 2>/dev/null || true
cp "$POPPLER_INSTALL_DIR/lib/libpoppler-qt5.so.1.27.0" "$HAP_LIBS_DIR/libpoppler-qt5.so.1" 2>/dev/null || true