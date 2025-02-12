```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```

# Hugo quick guide
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
1. Continue with the rest of the basic setups from the guides above
    - Set up formspree form, add it to `contact.md`
2.  Create a `.gitignore` with this content:
   ```
   # Hugo output directories
    public/
	resources/
	hugo_stats.json
    .hugo_build.lock
    
	# Local dev & system files
	.DS_Store
	Thumbs.db
```
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