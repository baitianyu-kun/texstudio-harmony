#!/bin/bash
set -e

# Ensure we are in the project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"
cd "$PROJECT_ROOT"

TARGET_BASE_DIR="build/src"

echo "Creating directory: $TARGET_BASE_DIR"
mkdir -p "$TARGET_BASE_DIR"
cd "$TARGET_BASE_DIR"

git clone git://code.qt.io/qt/qtbase.git
cd qtbase
git remote add gerrit https://codereview.qt-project.org/qt/qtbase
git fetch gerrit
git checkout -b origin_dev origin/dev 
git branch -D dev || true
git checkout -b dev gerrit/dev
cd ..

git clone git://code.qt.io/qt/qttools.git
cd qttools
git remote add gerrit https://codereview.qt-project.org/qt/qttools
git fetch gerrit
git checkout -b origin_dev origin/dev 
git branch -D dev || true
git checkout -b dev gerrit/dev
git submodule update --init --recursive
cd ..

git clone git://code.qt.io/qt/qtsvg.git
cd qtsvg
git remote add gerrit https://codereview.qt-project.org/qt/qtsvg
git fetch gerrit
git checkout -b origin_dev origin/dev 
git branch -D dev || true
git checkout -b dev gerrit/dev
cd ..

git clone https://code.qt.io/qt/qtdeclarative.git
cd qtdeclarative
git remote add gerrit https://codereview.qt-project.org/qt/qtdeclarative
git fetch gerrit
git checkout -b origin_dev origin/dev 
git branch -D dev || true
git checkout -b dev gerrit/dev
cd ..

git clone https://code.qt.io/qt/qt5compat.git
cd qt5compat
git remote add gerrit https://codereview.qt-project.org/qt/qt5compat
git fetch gerrit
git checkout -b origin_dev origin/dev 
git branch -D dev || true
git checkout -b dev gerrit/dev
cd ..

echo "Qt download and checkout complete."
