mkdir -p texlive-hnp
cd texlive-hnp

# 拷贝 dist-ohos 内容
cp -r ../dist-ohos/bin .
cp -r ../dist-ohos/lib .
cp -r ../dist-ohos/share .
cp -r ../dist-ohos/texmf .

cat > hnp.json << 'EOF'
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

cd ..
$TOOL_HOME/sdk/default/openharmony/toolchains/hnpcli pack -i ./texlive-hnp -o ./output -name texlive -v 1.0.0

