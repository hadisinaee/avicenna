# Avicenna — fresh Hugo module

A minimal academic website with a profile, publications, projects, news, and writing. This is a fresh implementation; the old theme's configuration is not compatible.

Requires **Hugo 0.168.0 or newer**, Go, and Git. No Node, npm, JavaScript framework, or CSS framework is required.

## Preview locally

From this directory:

```sh
hugo server --source exampleSite
```

Open http://localhost:1313/. The example site's `go.mod` imports the theme with a local replacement, so edits are reflected immediately without network access.

## Appearance

Change these three independent settings in `exampleSite/hugo.toml` (or your site's `hugo.toml`):

```toml
[params.appearance]
primaryFont = 'source-sans'
secondaryFont = 'maple-mono'
theme = 'cardinal'
```

| Setting | Responsibility | Presets |
| --- | --- | --- |
| `primaryFont` | Reading text and headings | `source-sans`, `source-serif`, `system` |
| `secondaryFont` | Labels, dates, resource links, tags, and code | `maple-mono`, `system-mono` |
| `theme` | Background, text, accents, borders, and surfaces | `cardinal`, `graphite`, `forest` |

The default `source-sans` preset preserves the prototype's editorial pairing: Source Sans 3 body text with Source Serif 4 headings. The `source-serif` preset uses Source Serif 4 throughout the primary text. The `system` preset uses system sans-serif throughout. Secondary fonts never change the main reading text, and themes never change fonts.

`cardinal` is the default red-and-neutral palette; `graphite` is monochrome; `forest` is green on warm off-white. Invalid theme names fail the build with an actionable message.

Preset webfonts load from Google Fonts and jsDelivr, with local/system fallbacks and `font-display: swap`. For an entirely offline site, choose `system` and `system-mono`, or self-host fonts as described below. Font loading is browser-side, so builds do not need to fetch fonts.

### Your own fonts and colors

You can also use a family name such as `primaryFont = 'Atkinson Hyperlegible'` or `secondaryFont = 'Courier New'`. Custom family names are not downloaded automatically: install locally or declare `@font-face` in your site's `assets/css/custom.css` and put font files under `static/fonts/`.

The optional `assets/css/custom.css` is loaded last. Override `--font-heading` there if you want a different heading font independently of the primary preset, without adding another mandatory setting. Override color tokens there to customize a palette:

```css
:root {
  --accent: #76314b;
  /* --paper, --ink, --muted, --line, --surface are also available. */
}
```

Keep normal text contrast at least 4.5:1. Custom font names allow letters, numbers, spaces, underscores, and hyphens. To configure a stack, use custom CSS rather than putting CSS into TOML.

## Content

| Content | Location | Front matter |
| --- | --- | --- |
| About | `content/_index.md` | `eyebrow`, `intro`, `interests`; Markdown bio |
| Publications | `content/publications/*.md` | `title`, `date`, `authors`, `venue`, optional `links` |
| Projects | `content/projects/*.md` | `title`, `date`, `description`, optional `links` |
| News | `content/news/*.md` | `title`, `date`, `description` |
| Writing | `content/blog/*.md` | `title`, `date`, `description`, `tags`, optional `toc` |

Use each section's `_index.md` to set its display title and introduction. Empty sections disappear from the homepage and sidebar. Homepage order is intentionally fixed: publications, projects, news, writing, with the three newest entries in each.

Profile fields are under `[params.profile]`: `name`, `role`, `location`, optional `image` and `cv` (paths relative to `static/`). Social links are `[[params.social]]` entries with `name` and `url`.

Resource links use an ordered array:

```toml
[[links]]
name = 'Paper'
url = 'https://example.org/paper.pdf'
[[links]]
name = 'Code'
url = 'https://github.com/your-name/project'
```

Create content from included archetypes:

```sh
hugo new content blog/my-post.md --source exampleSite
hugo new content publications/my-paper.md --source exampleSite
hugo new content projects/my-project.md --source exampleSite
hugo new content news/my-update.md --source exampleSite
```

New entries are drafts. Set `draft = false` to publish, or preview with `--buildDrafts`. Dates after the current date are hidden by Hugo unless `--buildFuture` is used.

## Use in another site

The example site already demonstrates a real module import. To adapt it locally, copy `exampleSite` and update its `go.mod` replacement to point to this theme's directory.

After this implementation is pushed to a branch or tag in `github.com/hadisinaee/avicenna`, a new remote consumer can use:

```sh
hugo new site my-site
cd my-site
hugo mod init example.org/my-site
```

Add this to `hugo.toml`:

```toml
[[module.imports]]
path = 'github.com/hadisinaee/avicenna'
```

Then run `hugo mod get github.com/hadisinaee/avicenna@YOUR_PUBLISHED_REF` and copy the example content and profile settings. Do not use the current remote `master`: it still contains the old theme. Do not copy the example `go.mod` into a published consumer: its replacement is for local development only.

## Validation and deployment

```sh
python3 scripts/validate.py
hugo --source exampleSite --minify
```

Deploy `exampleSite/public/` to a static host. Set your actual `baseURL` first, including any hosting subpath. The stylesheet pipeline minifies and fingerprints assets. Hugo generates RSS, sitemap, and tag pages; blog posts support optional TOC and build-time syntax highlighting.

CI tests the minimum supported Hugo and the latest release on pushes, pull requests, and weekly. Validation checks module consumption, appearance settings, invalid input, subpath links, pagination, RSS, sitemap, tags, 404, and empty sections. It does not verify browser font downloads or external links.

## Implementation

`layouts/baseof.html` supplies the shared shell; `home.html`, `page.html`, `section.html`, `term.html`, and `taxonomy.html` use Hugo's current template structure. `layouts/_partials/appearance.html` translates the three appearance settings into a fingerprinted CSS token file. `assets/css/main.css` consumes those tokens. No client-side settings persistence or application server is needed.

## Migrating from the previous theme

This rebuild changes both configuration and content structure; there is no compatibility layer. Start from the new [`exampleSite/`](exampleSite/) configuration rather than copying the old `config.toml`, `content/home/`, or `[params]` unchanged.

1. Move the biography Markdown body and introduction fields from `content/about/_index.md` and the old `content/home/about.md` section settings into the new `content/_index.md` front matter (`eyebrow`, `intro`, and `interests`) and body. Old `content/home/index.md` does not have a counterpart in the new structure.
2. Move the old About page's name, role, location, image, CV, and social URLs into `[params.profile]` and `[[params.social]]` in `hugo.toml`. Profile and social fields are no longer content front matter.
3. Move display titles and subtitles from the old `content/home/publications.md`, `projects.md`, and `news.md` into each new section's `_index.md` title and body; there are no headless `content/home/` section pages in the new layout.
4. The old `content/news/_index.md` stores updates in a `news_items` array; create one Markdown file per item in `content/news/`, with `title`, `date`, and `description` in TOML front matter and the item body. For example:

   ```toml
   +++
   title = 'Joined a research team'
   date = 2023-11-20
   description = 'Started a new role working on dependable systems.'
   +++
   ```

   Move the old `content/news/_index.md` display title/introduction to the new section's `_index.md` metadata, rather than carrying over the legacy `news_items` structure.

5. The old `content/publications/index.md` and `content/projects/index.md` are leaf-bundle pages. Move any section title/introduction into the corresponding new `_index.md`; keep each publication and project as its own Markdown file. Adapt publication `publication` to `venue`, and convert link maps such as `pdf = "..."` into the new ordered `links` array (`name`/`url` entries).
6. Keep each existing publication, project, and blog post filename/slug when moving it and its permalink can remain unchanged. News items become new routes because each now has its own content file; review every route before publishing and use Hugo `aliases` on pages whose URLs change. Check the tag names/URLs and deployed base URL as well.

MIT licensed. Font projects retain their own licenses. This development copy has not been pushed to GitHub.
