#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"
export QT_SRC_DIR="$PROJECT_ROOT/build/src/qt-harmonyos-5.12.12"

echo "Patching Qt source at $QT_SRC_DIR..."

python3 - << 'EOF'
import os
import sys

qt_src_dir = os.environ.get('QT_SRC_DIR')

# --- Patch qrandom.cpp ---
qrandom_path = os.path.join(qt_src_dir, 'qtbase/src/corelib/global/qrandom.cpp')
if os.path.exists(qrandom_path):
    with open(qrandom_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    old_qrandom = """#if defined(Q_COMPILER_CONSTEXPR) && !defined(Q_CC_MSVC) && !defined(Q_OS_INTEGRITY)
        // Currently fails to compile with MSVC 2017, saying QBasicMutex is not
        // a literal type. Disassembly with MSVC 2013 and 2015 shows it is
        // actually a literal; MSVC 2017 has a bug relating to this, so we're
        // withhold judgement for now.  Integrity's compiler is unable to
        // guarantee g's alignment for some reason.

        constexpr SystemAndGlobalGenerators g = {};
        Q_UNUSED(g);
        Q_STATIC_ASSERT(std::is_literal_type<SystemAndGlobalGenerators>::value);
#endif"""

    new_qrandom = """#if defined(Q_COMPILER_CONSTEXPR) && !defined(Q_CC_MSVC) && !defined(Q_OS_INTEGRITY)
        // Currently fails to compile with MSVC 2017, saying QBasicMutex is not
        // a literal type. Disassembly with MSVC 2013 and 2015 shows it is
        // actually a literal; MSVC 2017 has a bug relating to this, so we're
        // withhold judgement for now.  Integrity's compiler is unable to
        // guarantee g's alignment for some reason.

        constexpr SystemAndGlobalGenerators g = {};
        Q_UNUSED(g);
QT_WARNING_PUSH
QT_WARNING_DISABLE_CLANG("-Wdeprecated-declarations")
QT_WARNING_DISABLE_GCC("-Wdeprecated-declarations")
        Q_STATIC_ASSERT(std::is_literal_type<SystemAndGlobalGenerators>::value);
QT_WARNING_POP
#endif"""

    if new_qrandom in content:
        print(f"Already patched {qrandom_path}")
    elif old_qrandom in content:
        content = content.replace(old_qrandom, new_qrandom)
        with open(qrandom_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Successfully patched {qrandom_path}")
    else:
        print(f"Error: String to replace not found in {qrandom_path}")
        sys.exit(1)
else:
    print(f"Error: File not found {qrandom_path}. (Did you download Qt source?)")
    sys.exit(1)

# --- Patch qmake.conf ---
qmake_conf_path = os.path.join(qt_src_dir, 'qtbase/mkspecs/ohos-clang/qmake.conf')
if os.path.exists(qmake_conf_path):
    with open(qmake_conf_path, 'r', encoding='utf-8') as f:
        content = f.read()

    old_qmake = """OHOS_C_CXX_COMMON_FLAGS = \\
    $$OHOS_TOOLCHAIN_COMMON_FLAGS \\
    -fdata-sections \\
    -ffunction-sections \\
    -funwind-tables \\
    -fstack-protector-strong \\
    -no-canonical-prefixes \\
    -fno-addrsig \\
    -Wformat \\
    -Werror"""

    new_qmake = """OHOS_C_CXX_COMMON_FLAGS = \\
    $$OHOS_TOOLCHAIN_COMMON_FLAGS \\
    -fdata-sections \\
    -ffunction-sections \\
    -funwind-tables \\
    -fstack-protector-strong \\
    -no-canonical-prefixes \\
    -fno-addrsig \\
    -Wformat"""

    if new_qmake in content and old_qmake not in content:
        print(f"Already patched {qmake_conf_path}")
    elif old_qmake in content:
        content = content.replace(old_qmake, new_qmake)
        with open(qmake_conf_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Successfully patched {qmake_conf_path}")
    else:
        print(f"Error: String to replace not found in {qmake_conf_path}")
        sys.exit(1)
else:
    print(f"Error: File not found {qmake_conf_path}. (Did you download Qt source?)")
    sys.exit(1)

EOF

echo "Patching complete."
