#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

DIST_DIR="${PROJECT_ROOT}/build/build-texlive-ohos-dist"
HNP_DIR="${PROJECT_ROOT}/build/build-texlive-ohos-hnp"

if [ -d "$HNP_DIR" ]; then
    rm -r "$HNP_DIR"
fi

mkdir -p $HNP_DIR

# 拷贝 dist-ohos 内容
cp -r $DIST_DIR/bin $HNP_DIR/
cp -r $DIST_DIR/lib $HNP_DIR/
cp -r $DIST_DIR/share $HNP_DIR/
cp -r $DIST_DIR/texmf $HNP_DIR/

cat > $HNP_DIR/hnp.json << 'EOF'
{
  "type": "hnp-config",
  "name": "texlive",
  "version": "1.0.0",
  "install": {
    "links": [
      { "source": "bin/pdftex",    "target": "bin/pdftex" },
      { "source": "bin/tex",       "target": "bin/tex" },
      { "source": "bin/xetex",     "target": "bin/xetex" },
      { "source": "bin/bibtex",    "target": "bin/bibtex" },
      { "source": "bin/makeindex", "target": "bin/makeindex" },
      { "source": "bin/dvipdfmx",  "target": "bin/dvipdfmx" },
      { "source": "bin/dvips",     "target": "bin/dvips" },
      { "source": "bin/kpsewhich", "target": "bin/kpsewhich" },
      { "source": "bin/latex", "target": "bin/latex" },
      { "source": "bin/lualatex", "target": "bin/lualatex" },
      { "source": "bin/pdflatex", "target": "bin/pdflatex" },
      { "source": "bin/xelatex", "target": "bin/xelatex" }
    ]
  }
}

EOF

$TOOL_HOME/sdk/default/openharmony/toolchains/hnpcli pack -i $HNP_DIR -o ${PROJECT_ROOT}/build -name texlive -v 1.0.0

