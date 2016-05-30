<!-- README.md is generated from README.Rmd. Please edit that file -->
rvest
=====

[![Build Status](https://travis-ci.org/hadley/rvest.png?branch=master)](https://travis-ci.org/hadley/rvest) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rvest)](http://cran.r-project.org/package=rvest) [![Coverage Status](https://img.shields.io/codecov/c/github/hadley/rvest/master.svg)](https://codecov.io/github/hadley/rvest?branch=master)

rvest helps you scrape information from web pages. It is designed to work with [magrittr](https://github.com/smbache/magrittr) to make it easy to express common web scraping tasks, inspired by libraries like [beautiful soup](http://www.crummy.com/software/BeautifulSoup/).

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
  html_nodes("#titleCast .itemprop span") %>%
  html_text()
cast
#>  [1] "Will Arnett"     "Elizabeth Banks" "Craig Berry"    
#>  [4] "Alison Brie"     "David Burrows"   "Anthony Daniels"
#>  [7] "Charlie Day"     "Amanda Farinos"  "Keith Ferguson" 
#> [10] "Will Ferrell"    "Will Forte"      "Dave Franco"    
#> [13] "Morgan Freeman"  "Todd Hansen"     "Jonah Hill"

poster <- lego_movie %>%
  html_nodes("#img_primary img") %>%
  html_attr("src")
poster
#> [1] "http://ia.media-imdb.com/images/M/MV5BMTg4MDk1ODExN15BMl5BanBnXkFtZTgwNzIyNjg3MDE@._V1_SX214_AL_.jpg"
```

Overview
--------

The most important functions in rvest are:

-   Create an html document from a url, a file on disk or a string containing html with `read_html()`.

-   Select parts of a document using css selectors: `html_nodes(doc, "table td")` (or if you've a glutton for punishment, use xpath selectors with `html_nodes(doc, xpath = "//table//td")`). If you haven't heard of [selectorgadget](http://selectorgadget.com/), make sure to read `vignette("selectorgadget")` to learn about it.

-   Extract components with `html_tag()` (the name of the tag), `html_text()` (all text inside the tag), `html_attr()` (contents of a single attribute) and `html_attrs()` (all attributes).

-   (You can also use rvest with XML files: parse with `xml()`, then extract components using `xml_node()`, `xml_attr()`, `xml_attrs()`, `xml_text()` and `xml_tag()`.)

-   Parse tables into data frames with `html_table()`.

-   Extract, modify and submit forms with `html_form()`, `set_values()` and `submit_form()`.

-   Detect and repair encoding problems with `guess_encoding()` and `repair_encoding()`.

-   Navigate around a website as if you're in a browser with `html_session()`, `jump_to()`, `follow_link()`, `back()`, `forward()`, `submit_form()` and so on. (This is still a work in progress, so I'd love your feedback.)

To see examples of these function in use, check out the demos.

Installation
------------

Install the release version from CRAN:

``` r
install.packages("rvest")
```

Or the development version from github

``` r
# install.packages("devtools")
devtools::install_github("hadley/rvest")
```

Inspirations
------------

-   Python: [Robobrowser](http://robobrowser.readthedocs.org/en/latest/readme.html), [beautiful soup](http://www.crummy.com/software/BeautifulSoup/).
