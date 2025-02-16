```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```

# Hugo quick guide - Ananke theme website
_Updated February 2025_

* Verify `hugo` and `git` are installed
* General guides to follow:
  - [https://gohugo.io/getting-started/quick-start](https://blog.devgenius.io/it-has-never-been-easier-to-build-your-own-personal-website-f6974eb4ec1d)
  - [https://blog.devgenius.io/it-has-never-been-easier-to-build-your-own-personal-website-f6974eb4ec1d](https://blog.devgenius.io/it-has-never-been-easier-to-build-your-own-personal-website-f6974eb4ec1d)
## Initial configuration
1. If need, install the latest hugo binary from (use extended .deb)[https://github.com/gohugoio/hugo/releases](https://github.com/gohugoio/hugo/releases)
2. From websites directory, run
`hugo new site hiddenjewelstravel`
3.
```bash
cd hiddenjewelstravel
# create the git repo
$ git init
# add the theme, note the dest directory
$ git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
```
2. Copy example `config.toml` file from example site and set the theme, then start the server
```bash
cp config.toml /mnt/Data/websites/hiddenjewelstravel
echo "theme = 'ananke'" >> hugo.toml
```
3. Remove `static` and `content` folders from the root of the site and replace with the ones inside the example site, then start the server
```bash
rm -rf static/ content/
cp -r themes/ananke/exampleSite/static ../../../
cp -r themes/ananke/exampleSite/content ../../../
hugo server
```
4. Create a `.gitignore` with this content:
   ```
   # Hugo output directories
    public/
	resources/
	hugo_stats.json
    .hugo_build.lock
    
	# Local dev & system filesppi
	.DS_Store
	Thumbs.db

NOTE: These are essential for Hugo to generate the site correctly:

**Required Files/Folders for commits: - y.**
`config.toml` or `config/` → Your site settings
`content/` → Your pages & blog posts
`layouts/` → Custom templates (if modified)
`static/` → Images, CSS, JS, and other static assets
`themes/` → If manually copied (if using a Git submodule, handle it separately)
`archetypes/` → Templates for new content
`data/` → Optional structured data (e.g., YAML/JSON files for dynamic content)
`assets/` → SCSS, JS, and other preprocessed files used in your site

5. Continue with the rest of the basic setups from the guides above
    - Set up formspree form, add it to `contact.md`
    - Rename various pages and defaults in the `config.toml` file
    - Play with buttons, order as described [here](https://blog.devgenius.io/it-has-never-been-easier-to-build-your-own-personal-website-f6974eb4ec1d?gi=18a2c0902916)
    - Configure social media, other links and change background colors (had to create a custom css form targeting the _formspree_ on the Contact page):
   - Configure background colors, text and images in the `config.toml` using these for color guidance: [here](https://github.com/tachyons-css/tachyons/blob/v4.7.0/src/_skins.css#L96)
6. Configure Defaults under **archetypes - default.md** as a basic template for all new posts such as
```markdown
---
title: "{{ replace .Name "-" " " | title }}"
description: ""
featured_image: "/images/..."
date: {{ .Date }}
draft: true
tags: ["Python", "Plotly", "Dashboard"]
---

# Description:


# Details:
```
7. - Make a new post `hugo new post/promo3.md`. 
     - View the new file project-1.md. The file has the same content as previously defined in previous section. Insert all images for this article into the folder `static`>> `images`>> `promo-3` folder. Make sure to only use small letter.
    - The path to background image for this article should be defined into featured_image attribute. (Refer to figure 42)
    - Define the proper tags for the corresponding article. With tags, the reader can quickly find other articles using the same tag.
    - You can start writing the article by using other markdown files as reference ( promo3.md — promo4.md ).
    - Important: Change the `draft: true`to `draft: false` If it’s true, the article will not be visible when running hugo server.
8. To insert image into a file, 
- Option 1 is to use markdown:
```markdown
![alt text](/images/project-1/project-1_00.png "Overview of LDA text Analysis")
```
- Option 2 is to use shortcode if markdown isn't desired:
```html
{{< rawhtml >}} 
    <div style="align: left; text-align:center;">
        <img src="/images/project-1/project-1_00.png" height="50%" width="50%" />
        <div class="caption">Overview of LDA text Analysis</div>
    </div>
{{< /rawhtml >}}
```
9. To insert links, use markdown:
```markdown
[PLM_same_page](https://en.wikipedia.org/wiki/Product_lifecycle)
```
or to open a new tab, shortcode:
```html
{{< rawhtml >}}<a href="https://en.wikipedia.org/wiki/Product_lifecycle" target="_blank">PLM_new_tab</a>{{< /rawhtml >}}
```
9. To insert other HTML using shortcodes, follow guide [https://blog.bdemers.io/blog/2018/how-to-hugo/](https://blog.bdemers.io/blog/2018/how-to-hugo/)
10. When all is done, commit all changes and run `hugo`
11. Push to github repo, then publish to Cloudflare using instructions [here](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/)
	**IMPORTANT**
Setup 2 environmental variables in Cloudflare for this setup to work - `HUGO_VERSION` should be 0.143.1 or similar and `HUGO_ENV` should be set to **production**