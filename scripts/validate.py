#!/usr/bin/env python3
"""Build the actual module consumer and verify routes and appearance contracts."""
import os
from pathlib import Path
import subprocess
import tempfile
from html.parser import HTMLParser
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]


def build(destination, **settings):
    env = dict(os.environ, **settings)
    result = subprocess.run(
        ["hugo", "--source", "exampleSite", "--destination", str(destination),
         "--cleanDestinationDir", "--logLevel", "warn"],
        cwd=ROOT, env=env, text=True, capture_output=True,
    )
    return result


def successful(destination, **settings):
    result = build(destination, **settings)
    assert result.returncode == 0, result.stdout + result.stderr
    assert "WARN" not in result.stderr + result.stdout, result.stdout + result.stderr


class References(HTMLParser):
    def __init__(self):
        super().__init__()
        self.urls = []
        self.ids = set()

    def handle_starttag(self, tag, attributes):
        attrs = dict(attributes)
        if "id" in attrs:
            assert attrs["id"] not in self.ids, f"Duplicate ID: {attrs['id']}"
            self.ids.add(attrs["id"])
        for attr in ("href", "src"):
            if attrs.get(attr):
                self.urls.append(attrs[attr])


def check_links(destination, prefix=""):
    for page in destination.rglob("*.html"):
        refs = References()
        text = page.read_text()
        assert "ZgotmplZ" not in text, page
        refs.feed(text)
        for url in refs.urls:
            parsed = urlsplit(url)
            if parsed.scheme or parsed.netloc or not parsed.path:
                continue
            if parsed.path.startswith("/"):
                assert parsed.path.startswith(prefix + "/"), (page, url)
                target = destination / unquote(parsed.path[len(prefix):]).lstrip("/")
            else:
                target = page.parent / unquote(parsed.path)
            assert target.is_file() or (target / "index.html").is_file(), (page, url)


def appearance(destination):
    files = list((destination / "css").glob("appearance*.css"))
    assert len(files) == 1, files
    return files[0].read_text().lower()


def main():
    with tempfile.TemporaryDirectory(prefix="avicenna-check-") as temporary:
        dest = Path(temporary) / "public"
        for theme, color in [("cardinal", "#8c1515"), ("graphite", "#303030"), ("forest", "#3c5847")]:
            successful(dest, HUGO_PARAMS_APPEARANCE_THEME=theme)
            assert color in appearance(dest), theme
            assert "maple mono" in appearance(dest)
            check_links(dest)

        successful(dest, HUGO_PARAMS_APPEARANCE_PRIMARYFONT="system",
                   HUGO_PARAMS_APPEARANCE_SECONDARYFONT="system-mono",
                   HUGO_BASEURL="https://example.org/portfolio/", HUGO_PAGINATION_PAGERSIZE="1")
        css = appearance(dest)
        assert "system-ui" in css and "sfmono-regular" in css
        assert "source serif" not in css and "maple mono" not in css
        assert "fonts.googleapis.com" not in (dest / "index.html").read_text()
        for route in ["index.html", "blog/index.html", "blog/page/2/index.html",
                      "blog/boring-infrastructure/index.html", "tags/engineering/index.html",
                      "404.html", "sitemap.xml", "index.xml", "blog/index.xml"]:
            assert (dest / route).is_file(), route
        check_links(dest, "/portfolio")

        successful(dest, HUGO_PARAMS_APPEARANCE_PRIMARYFONT="source-serif",
                   HUGO_PARAMS_APPEARANCE_SECONDARYFONT="Courier New")
        assert "source serif" in appearance(dest) and "courier new" in appearance(dest)

        result = build(dest, HUGO_PARAMS_APPEARANCE_THEME="typo")
        assert result.returncode != 0 and "unknown appearance.theme" in result.stdout + result.stderr
        result = build(dest, HUGO_PARAMS_APPEARANCE_PRIMARYFONT="bad; font")
        assert result.returncode != 0 and "font names must" in result.stdout + result.stderr

        # Import this module from a fresh site with no profile or content sections.
        empty = Path(temporary) / "empty"
        (empty / "content").mkdir(parents=True)
        (empty / "go.mod").write_text(
            "module example.org/empty\n\ngo 1.18\n\n"
            "require github.com/hadisinaee/avicenna v0.0.0\n\n"
            f"replace github.com/hadisinaee/avicenna => {ROOT}\n"
        )
        (empty / "hugo.toml").write_text(
            "baseURL = 'https://example.org/'\ntitle = 'Empty site'\nlocale = 'en-US'\n"
            "[[module.imports]]\npath = 'github.com/hadisinaee/avicenna'\n"
        )
        (empty / "content/_index.md").write_text("+++\ntitle = 'Hello'\n+++\nA minimal site.\n")
        result = subprocess.run(["hugo", "--source", str(empty), "--destination", str(dest),
                                 "--cleanDestinationDir"], text=True, capture_output=True)
        assert result.returncode == 0, result.stdout + result.stderr
        html = (dest / "index.html").read_text()
        assert "A minimal site." in html
        assert 'id="publications"' not in html and 'id="projects"' not in html
    print("Passed: module import, three palettes, font presets/custom family, invalid config, subpath links, pagination, RSS, sitemap, tags, 404, and sparse content.")


if __name__ == "__main__":
    main()
