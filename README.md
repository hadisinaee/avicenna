# Avicenna Theme
A minimal academic page for academics!

Avicenna currently targets **Hugo extended v0.160+**.

**FOR THE DEMO, PLEASE SEE THE LINK BELOW**
[![Screenshot](https://github.com/hadisinaee/avicenna/blob/master/images/youtube.png "Avicenna")](https://youtu.be/rw29ZJJGFIM)

# Features
* Minimal, Responsive, and Clean
* :new: Supports Blog Posts
* :new: Supports News Feed
* Supports Google Analytics
* Supports Social Links
* Supports Publications Listing
* Supports Projects Listing

# How to use `Avicenna`?
To use `Avicenna`, you need to follow three steps:
1. Setup a site with `Avicenna`
2. Customize the site to your needs
3. Build your site and deploy it to your host

The following sections are based on the mentioned steps.
# 1. How to setup a site with `Avicenna`?
There are 3 ways to install `Avicenna`:
1. Use the automated setup script.
2. Use **Hugo Modules** directly.
3. Use the classic `themes/avicenna` Git clone workflow.

## 1. Automated script
Replace `my_cool_page` with your desired site folder:

```bash
wget https://raw.githubusercontent.com/hadisinaee/avicenna/master/setup_avicenna.sh && sh setup_avicenna.sh my_cool_page
```

To bootstrap a Hugo Modules based site instead of cloning the theme into `themes/`, use:

```bash
wget https://raw.githubusercontent.com/hadisinaee/avicenna/master/setup_avicenna.sh && sh setup_avicenna.sh --module my_cool_page
```

Run the site:
```bash
hugo serve
```

Now, you should be able to see the site at http://localhost:1313

## 2. Hugo Modules installation
<details>
  <summary>Click to see!</summary>
  
1. Install [Hugo][1] and [Go](https://go.dev/doc/install).
2. Create a new site and move into it:
```bash
hugo new site my_cool_page
cd my_cool_page
```

3. Initialize your site as a Hugo module:
```bash
hugo mod init example.com/my_cool_page
```

4. Add Avicenna as a module import in your `config.toml`:
```toml
[module]
  [[module.imports]]
    path = "github.com/hadisinaee/avicenna"
```

5. Fetch the module:

```bash
hugo mod get github.com/hadisinaee/avicenna@master
```

6. Copy the starter content from `exampleSite/` in this repository into your site root.

7. Run the site:
```bash
hugo serve
```

If you use the setup script with `--module`, it performs these steps for you and copies the starter content automatically.
</details>

## 3. Classic `themes/` installation
<details>
  <summary>Click to see!</summary>
  
1. You need to install [Hugo][1] first!
2. Create a new site and go to the directory:
```bash
# replace the `my_cool_page` with whatever you want!
hugo new site my_cool_page

# move to your project folder
cd my_cool_page
```

3. Add the stable release of `Avicenna` (the `master` branch) to your `themes` folder:
```bash
git clone --depth 1 --branch master https://github.com/hadisinaee/avicenna.git ./themes/avicenna
```

4. Copy the sample site to your project:
```bash
cp -R themes/avicenna/exampleSite/* ./
```

5. Run the site:
```bash
hugo serve
```

Now, you should be able to see the site at [http://localhost:1313](http://localhost:1313/)
</details>

# 2. How to Customize `Avicenna`?

## Start With `config.toml`
Start with the `config.toml` file at the root of your site. This is where you set the site's title, `baseURL`, pagination, Google Analytics ID, and either the theme name (classic install) or module import (Hugo Modules install).

## Adding Your Profile Picture, CV, and Favicon
There is a folder named `static` under the root of your site's folder. Its structure is as follows:

![static_folder](https://github.com/hadisinaee/avicenna/blob/master/static_folder.png)

- **Profile Picture**: Put your profile image under `static/images/`. The default is `profile.png`, and you can change the filename by setting `profile_picture` in `content/about/_index.md`.
- **CV**: Put your CV directly under `static/`. The default example uses `cv.pdf`, but you can point `cv` in `content/about/_index.md` at any file under `static/`.
- **Favicon**: Put the favicon file under `static/images/` and reference it from your site config if you add custom favicon handling.

## Content model
Most customization happens in the `content/` folder:

![the content folder structure](https://github.com/hadisinaee/avicenna/blob/master/avicenna_folder.png)

Avicenna is built around five user-facing content areas:

| Area | Source | Purpose |
| --- | --- | --- |
| About | `content/about/_index.md` | Profile, affiliations, socials, interests, academia, and intro text |
| News | `content/news/_index.md` | Short updates shown on the homepage |
| Publications | `content/publications/*.md` | Papers and publication links |
| Projects | `content/projects/*.md` | Projects and project links |
| Blog | `content/blog/*.md` | Standalone blog posts with tags |

The homepage layout itself is controlled by the headless files under `content/home/`. Each file maps a homepage section to a content area through `content_type`, and the section order is controlled by `weight`.

### Homepage section contract
Every file in `content/home/` should follow this pattern:

```toml
+++
headless = true
weight = 1
content_type = "about"

[section_settings]
show_section = true
title = "Optional heading override"
subtitle = "Optional subtitle"
+++
```

- `content_type` must match one of the supported section partials: `about`, `news`, `publications`, or `projects`
- `show_section` controls whether that section appears on the homepage
- `weight` controls the ordering on the homepage
- `title` and `subtitle` override the default heading shown by the section template

### `About` section
Edit `content/about/_index.md` to control the introductory section. The supported front matter is:

| Field | Required | Description |
| --- | --- | --- |
| `full_name` | Yes | Name shown at the top of the page |
| `profile_picture` | No | File name under `static/images/`; defaults to `profile.png` |
| `cv` | No | File under `static/`, such as `cv.pdf` |
| `blog` | No | Set to `true` to show the blog link in the social row |
| `socials` | No | Supported keys: `twitter`, `github`, `facebook`, `linkedin`, `twitch`, `google_scholar` |
| `affiliations` | No | List of affiliations; each item contains `title`, `name`, and `email` |
| `interests` | No | Bullet list shown under the Interests column |
| `academia` | No | Education history list shown under the Academia column |

The Markdown body of `content/about/_index.md` is rendered as your introduction text below the profile header.

### `News` section
Edit `content/news/_index.md` to control the news feed. News is currently stored in front matter instead of separate content files.

| Field | Required | Description |
| --- | --- | --- |
| `show_news_icons` | No | Enables Feather icons for each item |
| `default_news_icon` | No | Fallback icon name when an item does not provide its own icon |
| `num_news` | No | Maximum number of items shown on the homepage |
| `news_items` | Yes | List of items; each item supports `text`, `date`, `link`, `extra_text`, and `icon` |

### `Publications` section
All publications are stored in `content/publications/`. To create a new publication:

```bash
hugo new publications/your-pub-name.md
```

Each publication supports:

| Field | Required | Description |
| --- | --- | --- |
| `title` | Yes | Paper title |
| `authors` | Yes | Ordered list of author names |
| `date` | Yes | Publication date used for ordering |
| `publication` | Yes | Venue or journal name |
| `links` | No | Map of label to URL, such as `pdf`, `code`, `slides`, or `video` |

### `Projects` section
All projects are stored in `content/projects/`. To create a new project:

```bash
hugo new projects/your-project-name.md
```

Each project supports:

| Field | Required | Description |
| --- | --- | --- |
| `title` | Yes | Project title |
| `date` | Yes | Used to sort projects from newest to oldest |
| `links` | No | Map of label to URL, such as `website`, `code`, or `demo` |

### `Blog` section
All blog posts are stored in `content/blog/`. To create a new post:

```bash
hugo new blog/my-post.md
```

Each post supports:

| Field | Required | Description |
| --- | --- | --- |
| `title` | Yes | Post title |
| `date` | Yes | Publish date |
| `tags` | No | List of tags used on the post and tag pages |

The Markdown body is rendered as the full post content, and the `table_of_contents` shortcode can be used inside long posts.


# 3. How to Deploy `Avicenna`?
1. Make sure you have changed your `baseURL` in the `config.toml` file. It should be the address you want to deploy `Avicenna` on.
2. Run `hugo` in the root of your project. The result will be in the `public` folder in the root of your project.
3. Copy `public` folder and move it your host server.

# Developing the theme itself

From the theme repository root, use the bundled example site helper to preview or build changes:

```bash
sh scripts/hugo-example-site.sh server
sh scripts/hugo-example-site.sh
sh scripts/validate-example-site.sh
```

# Credits
* [Feather Icons](https://feathericons.com/)
* [Academic Icons](https://jpswalsh.github.io/academicons/)
* [Academic Hugo](https://wowchemy.com/templates/) 


[1]: https://gohugo.io/getting-started/installing/
