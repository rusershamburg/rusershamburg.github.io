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
# rebuild all Rmd-Posts
blogdown::build_dir("rmd_posts/", force = FALSE)

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

**(2) re-building page**

```bash
jekyll build
```

**(3) adding resources for r-makrdown posts**

```r
rmd_post_folders <- list.dirs("rmd_posts/", recursive = FALSE, full.names = TRUE)
for( i in seq_along(rmd_post_folders) ){
  year  <- gsub("(\\d{4})-(\\d{2})-(\\d{2})-*(.*)", "\\1", basename(rmd_post_folders[i]) )
  month <- gsub("(\\d{4})-(\\d{2})-(\\d{2})-*(.*)", "\\2", basename(rmd_post_folders[i]) )
  day   <- gsub("(\\d{4})-(\\d{2})-(\\d{2})-*(.*)", "\\3", basename(rmd_post_folders[i]) )
  title <- gsub("(\\d{4})-(\\d{2})-(\\d{2})-*(.*)", "\\4", basename(rmd_post_folders[i]) )
  to    <- paste("_site/blog", year, month, day, title, sep = "/")
  
  dir.create(path = to, showWarnings = FALSE, recursive = TRUE)
  file.copy(
    from = list.dirs("rmd_posts/", recursive = FALSE, full.names = TRUE),
    to   = paste(year, month, day, title, sep = "/"),
    overwrite = TRUE, 
    recursive = TRUE
  )
}

```
