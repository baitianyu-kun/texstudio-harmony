#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

# --- SDK Path ---
export OHOS_SDK="$TOOL_HOME/sdk/default/openharmony"
# Allows overriding SDK and NDK paths via environment variables if needed
SDK_ROOT=$OHOS_SDK
NDK_ROOT=$OHOS_SDK/native

OUTPUT_FILE="$SCRIPT_DIR/texstudio-harmony-deployment-settings.json"

cat > "$OUTPUT_FILE" <<EOF
{
    "application-binary": "$PROJECT_ROOT/build/build-texstudio-ohos/libtexstudio.so",
    "harmonyos-app-name": "texstudio",
    "harmonyos-app-bundle-name": "com.ohos.texstudio",
    "harmonyos-target-arch": ["arm64-v8a"],
    "sdk-root": "$SDK_ROOT",
    "ndk-root": "$NDK_ROOT",
    "qtLibsDirectory": "$PROJECT_ROOT/build/build-qt-ohos-install/lib",
    "qtPluginsDirectory": "$PROJECT_ROOT/build/build-qt-ohos-install/plugins",
    "qtQmlDirectory": "$PROJECT_ROOT/build/build-qt-ohos-install/qml",
    "qtLibExecsDirectory": "$PROJECT_ROOT/build/build-qt-host-install/libexec",
    "qtHostDirectory": "$PROJECT_ROOT/build/build-qt-host-install",
    "harmonyos-package-source-directory": "$PROJECT_ROOT/build/build-qt-ohos-install/src/harmonyos/templates",
    "extra-libs-dirs": [
        "$PROJECT_ROOT/additional-packages/lib",
        "$PROJECT_ROOT/build/build-poppler-ohos-install/lib"
    ],
    "permissions": [
        {
            "name": "ohos.permission.SYSTEM_FLOAT_WINDOW",
            "reason": "Used to display windows on top of other applications.",
            "usedScene": {
                "abilities": ["QAbility"],
                "when": "always"
            }
        },
        { "name": "ohos.permission.FILE_ACCESS_PERSIST" },
        { "name": "ohos.permission.PRINT" },
        { "name": "ohos.permission.PREPARE_APP_TERMINATE" },
        { "name": "ohos.permission.STORE_PERSISTENT_DATA" },
        { "name": "ohos.permission.INTERNET" },
        { "name": "ohos.permission.READ_WRITE_USER_FILE" },
        {
            "name": "ohos.permission.READ_PASTEBOARD",
            "reason": "Used to read clipboard contents.",
            "usedScene": {
                "abilities": ["QAbility"],
                "when": "always"
            }
        },
        {
            "name": "ohos.permission.CAMERA",
            "reason": "Required for camera access.",
            "usedScene": {
                "abilities": ["QAbility"],
                "when": "always"
            }
        },
        {
            "name": "ohos.permission.MICROPHONE",
            "reason": "Required for microphone access.",
            "usedScene": {
                "abilities": ["QAbility"],
                "when": "always"
            }
        },
        {
            "name": "ohos.permission.CUSTOM_SCREEN_CAPTURE",
            "reason": "Required for screen capture.",
            "usedScene": {
                "abilities": ["QAbility"],
                "when": "always"
            }
        },
        { "name": "ohos.permission.ACCELEROMETER" },
        { "name": "ohos.permission.GYROSCOPE" },
        {
            "name": "ohos.permission.APPROXIMATELY_LOCATION",
            "reason": "Required for approximate location.",
            "usedScene": {
                "abilities": ["QAbility"],
                "when": "always"
            }
        },
        {
            "name": "ohos.permission.LOCATION",
            "reason": "Required for accurate location.",
            "usedScene": {
                "abilities": ["QAbility"],
                "when": "always"
            }
        },
        {
            "name": "ohos.permission.GET_WIFI_INFO",
            "reason": "Required to get WiFi info.",
            "usedScene": {
                "abilities": ["QAbility"],
                "when": "always"
            }
        },
        {
            "name": "ohos.permission.ACCESS_BLUETOOTH",
            "reason": "Required to access Bluetooth.",
            "usedScene": {
                "abilities": ["QAbility"],
                "when": "always"
            }
        },
        { "name": "ohos.permission.GET_FILE_ICON" }
    ],
    "project-libraries": [
        "$PROJECT_ROOT/build/build-qt-ohos-install/lib/libQt6Core.so",
        "$PROJECT_ROOT/build/build-qt-ohos-install/lib/libQt6Gui.so",
        "$PROJECT_ROOT/build/build-qt-ohos-install/lib/libQt6Widgets.so"
    ]
}
EOF

echo "Successfully generated \$OUTPUT_FILE"
