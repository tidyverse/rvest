
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rvest <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/rvest)](https://cran.r-project.org/package=rvest)
[![Travis build
status](https://travis-ci.org/tidyverse/rvest.svg?branch=master)](https://travis-ci.org/tidyverse/rvest)
[![Codecov test
coverage](https://codecov.io/gh/tidyverse/rvest/branch/master/graph/badge.svg)](https://codecov.io/gh/tidyverse/rvest?branch=master)
<!-- badges: end -->

## Overview

rvest helps you scrape information from web pages. It is designed to
work with [magrittr](https://github.com/smbache/magrittr) to make it
easy to express common web scraping tasks, inspired by libraries like
[beautiful soup](https://www.crummy.com/software/BeautifulSoup/).

``` r
library(rvest)
lego_movie <- read_html("http://www.imdb.com/title/tt1490017/")

rating <- lego_movie %>% 
  html_nodes("strong span") %>%
  html_text() %>%
  as.numeric()
rating
#> [1] 7.8

cast <- lego_movie %>%
  html_nodes("#titleCast .primary_photo img") %>%
  html_attr("alt")
cast
#>  [1] "Will Arnett"     "Elizabeth Banks" "Craig Berry"    
#>  [4] "Alison Brie"     "David Burrows"   "Anthony Daniels"
#>  [7] "Charlie Day"     "Amanda Farinos"  "Keith Ferguson" 
#> [10] "Will Ferrell"    "Will Forte"      "Dave Franco"    
#> [13] "Morgan Freeman"  "Todd Hansen"     "Jonah Hill"

poster <- lego_movie %>%
  html_nodes(".poster img") %>%
  html_attr("src")
poster
#> [1] "https://m.media-amazon.com/images/M/MV5BMTg4MDk1ODExN15BMl5BanBnXkFtZTgwNzIyNjg3MDE@._V1_UX182_CR0,0,182,268_AL_.jpg"
```

## Installation

Install the release version from CRAN:

``` r
install.packages("rvest")
```

Or the development version from GitHub

``` r
# install.packages("devtools")
devtools::install_github("tidyverse/rvest")
```

## Key functions

The most important functions in rvest are:

  - Create an html document from a url, a file on disk or a string
    containing html with `read_html()`.

  - Select parts of a document using CSS selectors: `html_nodes(doc,
    "table td")` (or if you’ve a glutton for punishment, use XPath
    selectors with `html_nodes(doc, xpath = "//table//td")`). If you
    haven’t heard of [selectorgadget](http://selectorgadget.com/), make
    sure to read `vignette("selectorgadget")` to learn about it.

  - Extract components with `html_name()` (the name of the tag),
    `html_text()` (all text inside the tag), `html_attr()` (contents of
    a single attribute) and `html_attrs()` (all attributes).

  - (You can also use rvest with XML files: parse with `xml()`, then
    extract components using `xml_node()`, `xml_attr()`, `xml_attrs()`,
    `xml_text()` and `xml_name()`.)

  - Parse tables into data frames with `html_table()`.

  - Extract, modify and submit forms with `html_form()`, `set_values()`
    and `submit_form()`.

  - Detect and repair encoding problems with `guess_encoding()` and
    `repair_encoding()`.

  - Navigate around a website as if you’re in a browser with
    `html_session()`, `jump_to()`, `follow_link()`, `back()`,
    `forward()`, `submit_form()` and so on. (This is still a work in
    progress, so I’d love your feedback.)

To see examples of these function in use, check out the demos.

## Inspirations

  - Python:
    [RoboBrowser](http://robobrowser.readthedocs.org/en/latest/readme.html),
    [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/).

## Code of Conduct

Please note that the rvest project is released with a [Contributor Code of Conduct](https://rvest.tidyverse.org/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
