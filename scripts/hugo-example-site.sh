#!/bin/sh

set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
THEME_LINK="$REPO_ROOT/exampleSite/themes/avicenna"
CREATED_LINK=0

cleanup() {
    if [ "$CREATED_LINK" -eq 1 ]; then
        rm -f "$THEME_LINK"
        rmdir "$REPO_ROOT/exampleSite/themes" 2>/dev/null || true
    fi
}

if [ ! -e "$THEME_LINK" ]; then
    mkdir -p "$REPO_ROOT/exampleSite/themes"
    ln -s ../.. "$THEME_LINK"
    CREATED_LINK=1
elif [ ! -L "$THEME_LINK" ]; then
    echo "expected $THEME_LINK to be a symlink to the theme repository" >&2
    exit 1
fi

trap cleanup EXIT INT TERM

cd "$REPO_ROOT"
hugo --source exampleSite "$@"
