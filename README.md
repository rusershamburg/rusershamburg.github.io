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


### Content




### Building Page


**rebuilding r-markdown**

```r
blogdown::build_dir("rmd_posts/")
file.copy(
  from      = list.files("rmd_posts/", pattern = "\\.md", full.names = TRUE), 
  to        = "_posts/", 
  overwrite = TRUE
)
```

**rebuilding page**

```bash
jekyll build
```
