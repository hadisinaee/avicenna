#!/bin/sh

set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_ROOT=$(mktemp -d)
DEFAULT_DEST="$BUILD_ROOT/public"
SUBPATH_DEST="$BUILD_ROOT/public-subpath"

cleanup() {
    rm -rf "$BUILD_ROOT"
}

trap cleanup EXIT INT TERM

cd "$REPO_ROOT"

sh scripts/hugo-example-site.sh --destination "$DEFAULT_DEST"
sh scripts/hugo-example-site.sh --destination "$SUBPATH_DEST" --baseURL https://example.com/portfolio/

[ -f "$DEFAULT_DEST/index.html" ]
[ -f "$DEFAULT_DEST/blog/index.html" ]
[ -f "$DEFAULT_DEST/blog/blog1/index.html" ]
[ -f "$DEFAULT_DEST/tags/ml/index.html" ]
[ -f "$DEFAULT_DEST/404.html" ]

[ -f "$SUBPATH_DEST/index.html" ]
[ -f "$SUBPATH_DEST/blog/index.html" ]
[ -f "$SUBPATH_DEST/blog/blog1/index.html" ]
[ -f "$SUBPATH_DEST/tags/ml/index.html" ]
[ -f "$SUBPATH_DEST/404.html" ]

grep -q 'id="profile_picture"' "$DEFAULT_DEST/index.html"
grep -q 'alt="YOUR_NAME"' "$DEFAULT_DEST/index.html"
grep -q 'Recent Publications' "$DEFAULT_DEST/index.html"
grep -q 'Table of Contents' "$DEFAULT_DEST/blog/blog1/index.html"
grep -q 'Return home' "$DEFAULT_DEST/404.html"

grep -q 'href="/portfolio/blog/"' "$SUBPATH_DEST/blog/blog1/index.html"
grep -q 'href="/portfolio/tags/ml/"' "$SUBPATH_DEST/blog/blog1/index.html"
grep -q 'src="/portfolio/images/profile.png"' "$SUBPATH_DEST/index.html"
grep -q 'href="/portfolio/css/style.css"' "$SUBPATH_DEST/index.html"
grep -q 'href="/portfolio/"' "$SUBPATH_DEST/404.html"

! grep -R -E -q 'bootstrap@|bootstrap\.min\.css' "$DEFAULT_DEST" "$SUBPATH_DEST"

! grep -nF 'href="/"' "$SUBPATH_DEST/blog/index.html" "$SUBPATH_DEST/blog/blog1/index.html" "$SUBPATH_DEST/tags/ml/index.html"
! grep -nF 'href="/blog' "$SUBPATH_DEST/index.html" "$SUBPATH_DEST/blog/index.html" "$SUBPATH_DEST/blog/blog1/index.html" "$SUBPATH_DEST/tags/ml/index.html"
! grep -nF "href='/blog" "$SUBPATH_DEST/index.html" "$SUBPATH_DEST/blog/index.html" "$SUBPATH_DEST/blog/blog1/index.html" "$SUBPATH_DEST/tags/ml/index.html"
! grep -nF 'href="/tags/' "$SUBPATH_DEST/blog/index.html" "$SUBPATH_DEST/blog/blog1/index.html" "$SUBPATH_DEST/tags/ml/index.html"
! grep -nF "href='/tags/" "$SUBPATH_DEST/blog/index.html" "$SUBPATH_DEST/blog/blog1/index.html" "$SUBPATH_DEST/tags/ml/index.html"
! grep -nF 'href="/css/style.css"' "$SUBPATH_DEST/index.html" "$SUBPATH_DEST/blog/index.html" "$SUBPATH_DEST/blog/blog1/index.html" "$SUBPATH_DEST/tags/ml/index.html"
! grep -nF "href='/css/style.css'" "$SUBPATH_DEST/index.html" "$SUBPATH_DEST/blog/index.html" "$SUBPATH_DEST/blog/blog1/index.html" "$SUBPATH_DEST/tags/ml/index.html"
! grep -nF 'src="/images/' "$SUBPATH_DEST/index.html"
! grep -nF "src='/images/" "$SUBPATH_DEST/index.html"
