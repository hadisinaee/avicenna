# Avicenna Copilot Instructions

## Build and preview commands

This repository is a **Hugo theme**, not a standalone app. The normal way to exercise changes from the theme root is against `exampleSite/`.

```bash
# Preview the bundled example site from the theme repo root
sh scripts/hugo-example-site.sh server

# Build the bundled example site
sh scripts/hugo-example-site.sh

# Create one new publication or project entry in the example site
sh scripts/hugo-example-site.sh new publications/my-paper.md
sh scripts/hugo-example-site.sh new projects/my-project.md
```

There are **no repo-local lint or automated test commands** in this repository, and there is **no single-test runner** to target an individual case.

CI lives in `.github/workflows/ci.yml` and uses the same helper script to build `exampleSite/` and smoke-check subpath-safe output.

## High-level architecture

- `layouts/_default/baseof.html` and `layouts/partials/core/{head,footer,script}.html` define the shared page shell. Styling lives in `static/css/style.css`; Bootstrap CSS, Academicons, Google Fonts, and Feather icons are loaded from CDNs in the core partials.
- The landing page is assembled in `layouts/index.html` from the headless bundle at `content/home`. Each resource under `content/home/*.md` with `section_settings.show_section = true` becomes one homepage section, ordered by `weight`.
- Homepage section dispatch is dynamic: `layouts/index.html` reads each resource's `content_type` and renders `layouts/partials/<content_type>/<content_type>.html`. The same `content_type` is also passed to `.Site.GetPage`, so the home entry, the content section, and the partial path must stay aligned.
- `content/about/_index.md` is the data source for the about section. The home resource `content/home/about.md` only turns the section on and chooses its placement.
- `content/publications/` and `content/projects/` are headless section bundles. Their partials render child pages from `.Resources.ByType "page"`, so individual entries live alongside `index.md` inside each bundle.
- `content/news/_index.md` stores `news_items` and related settings (`num_news`, `show_news_icons`, `default_news_icon`). The news partial sorts those items by date and shows the first `num_news`.
- Blog pages are separate from the homepage bundle: `_default/list.html` renders the blog index, `_default/single.html` renders individual posts, `layouts/tags/list.html` renders tag pages, and `layouts/shortcodes/table_of_contents.html` provides the blog TOC shortcode used in example posts.
- `setup_avicenna.sh` and the README both assume the example site is the canonical starter. The setup flow creates a new Hugo site, clones this theme into `themes/avicenna`, and copies `exampleSite/*` into the consumer site root. For contributors working from this repo, `scripts/hugo-example-site.sh` temporarily wires `exampleSite/themes/avicenna` to the checked-out theme so builds use the local source tree.

## Key conventions

- Keep the **example site in sync with template changes**. If you add or rename required front matter, section resources, or assets, update `exampleSite/` too; it is both the documented reference and what the setup script copies into new sites.
- Treat **modernization work as cross-file work**. This repo still relies on older assumptions such as Bootstrap 4.5 from a CDN, theme/exampleSite coupling, and setup/docs/templates that need to stay aligned; review those together instead of "fixing" only one file in isolation.
- `content/home/*.md` controls **homepage orchestration only**: section visibility, ordering, and optional section titles/subtitles live there. The actual section data lives in the matching top-level content bundle (`about`, `news`, `publications`, `projects`).
- `content_type` is a strict contract. For example, `content_type = "projects"` expects both `layouts/partials/projects/projects.html` and a page resolvable via `.Site.GetPage "projects"`.
- The about section uses nested front matter shapes that are easy to break if flattened:
  - `affiliations` is a list of `affiliation` objects with `title`, `name`, and `email`
  - `academia` is a list of `course` objects with fields like `degree`, `institution`, `major`, `start_date`, `end_date`, `minor`, and `other_info`
  - `socials` values are handles/usernames, not full URLs; the template builds the platform URLs itself
  - `cv` is rendered directly as the href for the CV icon
- `profile_picture` in `content/about/_index.md` is honored by `layouts/partials/about/introduction.html`, but it still expects the file to live under `static/images/`.
- Publications expect front matter shaped like the archetype: `title`, `authors` array, `date`, `publication`, and a `links` map. Projects likewise use a `links` map, and the projects partial sorts entries descending by `Params.date`.
- Blog post tags are plain strings in front matter and render to hard-coded `/tags/<tag>/` URLs. The blog navbar and stylesheet also use site-root paths such as `/blog` and `/css/style.css`, so path changes usually require coordinated template edits rather than config-only changes.
- For layout or styling changes, validate against `exampleSite/` in a browser, not just by reading templates. This repository now has a project-level Playwright MCP config in `.mcp.json`, which is a good fit for checking rendered homepage sections, blog pages, and responsive behavior after theme edits.
