# rusershamburg.github.io

Sources for the homepage of R Users Hamburg group. 



## Setup


### Description 

The page is powered by Jekyll and Github Pages. Jekyll provides tooling for 
building static content pages while allowing in an ordered and automatic manner: 
Content is created by user as markdown files and during the build process layout 
is applied to the content. Furthermore script snippets allow for automated  
content and automatic updates of e.g. table of contents or RSS-feed files. 

- Jekyll version 3.7.3

```bash
jekyll --version
```

- Jekyll concept: https://jekyllrb.com/docs/structure/
- Jekyll config: https://jekyllrb.com/docs/configuration/



### Content

**adding markdown posts**

Simple Markdown post can be added by addin a markdown file to `_posts` folder.
The document should have a file name of format: `YYYY-MM-DD-name-of-the-post` 
and it should contain a YAML-header like this:

```yaml
---
title: "Up and Running"
date: "2018-03-11 13:16:01"
categories: blog
tags: 
    - log
---
```

... or like this ...

```yaml
---
title:  "Up and running"
date:   "2018-02-11 13:16:01"
categories: blog
tags:
    - rstats
    - robotstxt
---
```

The former will appear in feed.xml as atom feed while the latter will appear in 
feed.xml as well as in feed_r.xml. 


- https://jekyllrb.com/docs/posts/




### Building Page (only needed for local previews)

<!-- 
**(1) re-building r-markdown**

```r
# rebuild all Rmd-Posts
blogdown::build_dir("rmd_posts/", force = TRUE)

# pass along yaml-header and save md file in _posts folder
fnames <- list.files("rmd_posts/", pattern = "\\.Rmd", full.names = TRUE)
for ( i in seq_along(fnames) ){
  rmd_content <- readLines(fnames[i])
  rmd_content_yaml_borders <- grep("^---", rmd_content)[1:2]
  
  md_content     <- readLines(gsub("\\.Rmd$", ".md", fnames[i]))
  md_content_new <- 
   c(
    rmd_content[seq(rmd_content_yaml_borders[1], rmd_content_yaml_borders[2])],
    "","",
    md_content
   )
   
  writeLines(
    md_content_new, 
    paste0("_posts/", basename(gsub("\\.Rmd$", ".md", fnames[i])))
  )
}
```
-->

**re-building page**

```bash
jekyll build
```

<!--
**(3) adding resources for r-makrdown posts**

```r
rmd_post_folders <- list.dirs("rmd_posts/", recursive = FALSE, full.names = TRUE)
for( i in seq_along(rmd_post_folders) ){
  year  <- gsub("(\\d{4})-(\\d{2})-(\\d{2})-*(.*)", "\\1", basename(rmd_post_folders[i]) )
  month <- gsub("(\\d{4})-(\\d{2})-(\\d{2})-*(.*)", "\\2", basename(rmd_post_folders[i]) )
  day   <- gsub("(\\d{4})-(\\d{2})-(\\d{2})-*(.*)", "\\3", basename(rmd_post_folders[i]) )
  title <- gsub("(\\d{4})-(\\d{2})-(\\d{2})-*(.*)", "\\4", basename(rmd_post_folders[i]) )
  title <- gsub("_files$", "", title )
  to    <- paste("_site/blog", year, month, day, title, sep = "/")
  
  dir.create(path = to, showWarnings = FALSE, recursive = TRUE)
  file.copy(
    from = rmd_post_folders[i],
    to   = to,
    overwrite = TRUE, 
    recursive = TRUE
  )
}

```
--> 

**local live rebuild**

```bash
jekyll serve
```




### Deployment

```bash
git push
```

... to master branch of rusershamburg.github.io repo will result in an 
update of https://rusershamburg.github.io with approximatly 10-20 seconds delay.

## stats

The stats folder hosts two kinds of files: .json-files which store data that might be used within the webpage and .R-scripts that are triggered to collect data. 

**Beware!** the .R-scripts are aimed at being used by a remote worker - a server - and might do potential destructive things like `git checkout master`, `git pull`, `git add`, `git commit` and `git push`.


## Folder Structure

## / 

The root of the page's source files. Almost anything in root will be compiled into _site. Compilation means that content (e.g. in the form of html and markdown files in the page root) will be matched with layout templates, SASS files filled with html and all liquid statements are evaluated (i.e. the stuff in double curly braces: `{{ varaible }}`). 

As rule of thumb anything that is not prepended with an underscore (including files in ) is copied/compiled as-is into _site. Everything that has an underscore has some special logic and might get pre-process-re-arranged before finding its way into _site - e.g. _posts gets compiled into the blog folder and blog than gets cpopied into _site. 



## _site

That's where `jekyll build` builds the site into - a preview of what is to be deployed on rusershamburg.github.io. Folder was excluded via `.gitignore` since Github will build this part again anyways. 


## _includes

HTML and JS snippets that can be included anywhere via liquid statements like this: `{% include meetup_group_stats.html %}` 


## _layouts

Layouts live here. Content can use layouts requesting them in a yaml-header: 

```yaml
---
layout: blank
---
```

Layouts specify where the content goes with a liquid snippet requesting the content variable:

```
...
{{ content }}
...
```

Layouts can themselfes use layouts. 


## _posts

Blog posts live here.


## _sass

SASS-files live here that will be compiled to css or can be included by other SASS-files - e.g. _a


## assets

The place to put assests like images, styles, Javascript use by the site. 


## blog 

Contains the front page for the blog posts. 


## rmd_posts

A place 'stage' posts written in RMarkdown. RMarkdown has to be compiled to Markdown and than put into _posts.

## stats

The page's data, statistics and analytics department: code that gathers data as well as data files live here. 

## _config.yml

The page's config - this sets options for Jekyll to know how to compile - or put another way: this file sets global varaibles that later on are available in liquid. 

## index.md, archive.html, blogroll.html

The site's (main) pages - do not forget to add them to `_config.yml`.


## feed_r.xml

Jekyll will automatically wrap up all blog posts into an Atom (think RSS successor) feed: `feed.xml`. Now `feed_r.xml` is an Atom feed that consists of an subset of posts - namely only those that have been provisioned with an "rstats" tag in the yaml header: 

```
---
...
tags:
    - rstats
    - package
    - convenience
...
---
```



# More

- **Jekyll:** https://jekyllrb.com/docs/home/
- **Liquid:** https://learn.cloudcannon.com/jekyll/introduction-to-liquid/







