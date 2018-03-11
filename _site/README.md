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




- https://jekyllrb.com/docs/posts/


### Building Page


**(1) re-building r-markdown**

```r
blogdown::build_dir("rmd_posts/")
file.copy(
  from      = list.files("rmd_posts/", pattern = "\\.md", full.names = TRUE), 
  to        = "_posts/", 
  overwrite = TRUE
)
```

**(2) re-building page**

```bash
jekyll build
```

**(3) adding resources for r-makrdown posts**

```r
file.copy(
  from = list.dirs("rmd_posts/", recursive = FALSE, full.names = TRUE),
  to   = "_site",
  overwrite = TRUE, 
  recursive = TRUE
)
```
