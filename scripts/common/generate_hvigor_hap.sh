#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"
QT_HOST_PATH="$PROJECT_ROOT/build/build-qt-host"

$QT_HOST_PATH/bin/harmonydeployqt --verbose --hvigor $TOOL_HOME/bin/hvigorw --input ./texstudio-harmony-deployment-settings.json