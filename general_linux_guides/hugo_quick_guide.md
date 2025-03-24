```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```

# Hugo guide - Ananke theme website and analytics/optimization
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

___

## OTHER WEBSITE TASKS

### **1. Submit Your Website to Google Search Console**
Google Search Console (GSC) is a free tool that helps you monitor and troubleshoot your website’s presence in Google Search results. Here’s how to get started:
- **Create a Google Search Console Account**: Go to [Google Search Console](https://search.google.com/search-console/) and sign in with your Google account.
- **Add Your Website**: Click “Add Property” and enter your website’s URL.
- **Verify Ownership**:
  - Since you’re using Cloudflare Pages, you can verify ownership by adding a DNS TXT record via Cloudflare’s DNS settings.
  - Alternatively, you can use the HTML file upload method (download the file from GSC and upload it to your Hugo site’s `static` folder, then redeploy).
- **Submit Your Sitemap**: Hugo automatically generates a sitemap.xml file. Submit this to GSC by going to **Sitemaps** in the left-hand menu and entering `sitemap.xml`.

___

### **Step 1: Create a Google Analytics Account**
1. Go to [Google Analytics](https://analytics.google.com/) and sign in with the same Google account you used for Google Search Console (or your business email).
2. Click **Start measuring**.
3. Set up an **Account Name** (e.g., "Hidden Jewels Travel").
4. Configure your **Property**:
   - Property name: `Hidden Jewels Travel Website`
   - Time zone: Choose your business’s time zone.
   - Currency: Choose your preferred currency.
5. Click **Next** and fill in your business details (industry, size, etc.).
6. Accept the terms and conditions.
### **Step 2: Get Your Google Analytics Tracking Code**
1. After setting up your property, you’ll be prompted to create a **Data Stream**.
   - Choose **Web** as the platform.
   - Enter your website URL (e.g., `https://hiddenjewelstravel.com`) and give it a stream name (e.g., "Hidden Jewels Travel Website").
2. Click **Create Stream**.
3. You’ll see your **Measurement ID** (e.g., `G-XXXXXXXXXX`). This is what you’ll use to connect Google Analytics to your Hugo site.
### **Step 3: Add the Tracking Code to Your Hugo Site**
Since you’re using the Ananke theme, you can add the Google Analytics tracking code to your site without modifying the theme files directly. Here’s how:

1. Open your Hugo project in your code editor.
2. Navigate to your site’s **configuration file** (usually `config.toml` or `config.yaml`).
3. Add the following lines to enable Google Analytics:
   ```toml
   [params]
     googleAnalytics = "G-XXXXXXXXXX"  # Replace with your Measurement ID
   ```
   If you’re using `config.yaml`, add:
   ```yaml
   params:
     googleAnalytics: "G-XXXXXXXXXX"  # Replace with your Measurement ID
   ```
4. Save the file and redeploy your site. Hugo will automatically inject the Google Analytics tracking code into all pages.

### **Step 4: Verify Google Analytics is Working**
1. After redeploying your site, visit your website in a browser.
2. Open the **Developer Tools** (usually by pressing `F12` or `Ctrl+Shift+I`).
3. Go to the **Network** tab and filter by `collect`.
4. Refresh the page. You should see a request to `https://www.google-analytics.com/g/collect` with a status of `200`. This confirms Google Analytics is working.