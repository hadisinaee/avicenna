#!/bin/sh

set -eu

THEME_REPO_URL="https://github.com/hadisinaee/avicenna.git"
USE_MODULE=0

if [ "${1:-}" = "--module" ]; then
    USE_MODULE=1
    shift
fi

SITE_FOLDER=${1:-}

if [ -z "$SITE_FOLDER" ]; then
    echo "usage: sh setup_avicenna.sh [--module] <site-folder>" >&2
    exit 1
fi

hugo new site "$SITE_FOLDER"

cd "$SITE_FOLDER"
rm -f hugo.toml hugo.yaml hugo.yml hugo.json config.toml config.yaml config.yml config.json

if [ "$USE_MODULE" -eq 1 ]; then
    TMP_THEME_DIR=$(mktemp -d)

    cleanup() {
        rm -rf "$TMP_THEME_DIR"
    }

    trap cleanup EXIT INT TERM

    git clone --depth 1 --branch master "$THEME_REPO_URL" "$TMP_THEME_DIR/avicenna"
    cp -R "$TMP_THEME_DIR/avicenna/exampleSite/." ./

    sed -i.bak '/^theme = "avicenna"$/d' config.toml
    rm -f config.toml.bak

    hugo mod init "example.com/$(basename "$SITE_FOLDER")"

    cat >> config.toml <<'EOF'

[module]
  [[module.imports]]
    path = "github.com/hadisinaee/avicenna"
EOF

    hugo mod get github.com/hadisinaee/avicenna@master
else
    git clone --depth 1 --branch master "$THEME_REPO_URL" ./themes/avicenna
    cp -R themes/avicenna/exampleSite/. ./
fi
