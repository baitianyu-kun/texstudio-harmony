#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MODULE_JSON_PATH="$SCRIPT_DIR/libtexstudio-harmonyos/entry/src/main/module.json5"

python3 - <<EOF
import sys
import os

filepath = "$MODULE_JSON_PATH"

if not os.path.exists(filepath):
    print(f"Error: {filepath} does not exist.")
    sys.exit(1)

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

if '"hnpPackages"' not in content:
    last_brace = content.rfind('}')
    if last_brace == -1:
        print("Error: Invalid JSON5 structure (no closing brace found).")
        sys.exit(1)
        
    second_last_brace = content.rfind('}', 0, last_brace)
    if second_last_brace == -1:
        print("Error: Invalid JSON5 structure (no inner closing brace found).")
        sys.exit(1)
        
    # Find the last non-whitespace character before the second last brace
    prev_char_idx = second_last_brace - 1
    while prev_char_idx >= 0 and content[prev_char_idx].isspace():
        prev_char_idx -= 1
        
    insert_content = """,
    "hnpPackages": [
      {
        "package": "texlive.hnp",
        "type": "public"
      }
    ]"""
    
    new_content = content[:prev_char_idx+1] + insert_content + content[prev_char_idx+1:]
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Successfully added hnpPackages to module.json5")
else:
    print("hnpPackages already exists in module.json5")
EOF
