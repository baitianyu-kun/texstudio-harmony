#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../../.." &> /dev/null && pwd )"
TEXSTUDIO_HARMONY_DIR="${PROJECT_ROOT}/scripts/common/libtexstudio-harmonyos"
HNP_FILE="${PROJECT_ROOT}/build/texlive.hnp"

cd $TEXSTUDIO_HARMONY_DIR

hvigorw --mode module -p module=entry@default -p product=default -p requiredDeviceType=2in1 assembleHap --analyze=normal --parallel --incremental --daemon

cd $SCRIPT_DIR

# copy and put hnp
cp $TEXSTUDIO_HARMONY_DIR/entry/build/default/outputs/default/entry-default-unsigned.hap .

mkdir -p hnp/arm64-v8a
cp $HNP_FILE hnp/arm64-v8a/
zip -r -y entry-default-unsigned.hap hnp

rm -r hnp

# sign
if [ -f "build-profile.json5" ]; then
    echo "build-profile.json5软链接已存在"
else
    ln -s $TEXSTUDIO_HARMONY_DIR/build-profile.json5 .
fi

python3 sign.py entry-default-unsigned.hap entry-default-signed.hap

# push
export OHOS_SDK_HOME=$TOOL_HOME/sdk/default/openharmony
"$OHOS_SDK_HOME/toolchains/hdc" shell aa force-stop com.ohos.texstudio
"$OHOS_SDK_HOME/toolchains/hdc" file send ./entry-default-signed.hap /data/local/tmp
"$OHOS_SDK_HOME/toolchains/hdc" shell bm install -p /data/local/tmp/entry-default-signed.hap
"$OHOS_SDK_HOME/toolchains/hdc" shell aa start -a QAbility -b com.ohos.texstudio
