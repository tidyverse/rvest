
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rvest <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/rvest)](https://cran.r-project.org/package=rvest)
[![R-CMD-check](https://github.com/tidyverse/rvest/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverse/rvest/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/tidyverse/rvest/branch/main/graph/badge.svg)](https://app.codecov.io/gh/tidyverse/rvest?branch=main)
<!-- badges: end -->

## Overview

rvest helps you scrape (or harvest) data from web pages. It is designed
to work with [magrittr](https://github.com/tidyverse/magrittr) to make
it easy to express common web scraping tasks, inspired by libraries like
[beautiful soup](https://www.crummy.com/software/BeautifulSoup/) and
[RoboBrowser](http://robobrowser.readthedocs.io/en/latest/readme.html).

If you’re scraping multiple pages, I highly recommend using rvest in
concert with [polite](https://dmi3kno.github.io/polite/). The polite
package ensures that you’re respecting the
[robots.txt](https://en.wikipedia.org/wiki/Robots_exclusion_standard)
and not hammering the site with too many requests.

## Installation

``` r
# The easiest way to get rvest is to install the whole tidyverse:
install.packages("tidyverse")

# Alternatively, install just rvest:
install.packages("rvest")
```

## Usage

``` r
library(rvest)

# Start by reading a HTML page with read_html():
starwars <- read_html("https://rvest.tidyverse.org/articles/starwars.html")

# Then find elements that match a css selector or XPath expression
# using html_elements(). In this example, each <section> corresponds
# to a different film
films <- starwars %>% html_elements("section")
films
#> {xml_nodeset (7)}
#> [1] <section><h2 data-id="1">\nThe Phantom Menace\n</h2>\n<p>\nReleased: 1999 ...
#> [2] <section><h2 data-id="2">\nAttack of the Clones\n</h2>\n<p>\nReleased: 20 ...
#> [3] <section><h2 data-id="3">\nRevenge of the Sith\n</h2>\n<p>\nReleased: 200 ...
#> [4] <section><h2 data-id="4">\nA New Hope\n</h2>\n<p>\nReleased: 1977-05-25\n ...
#> [5] <section><h2 data-id="5">\nThe Empire Strikes Back\n</h2>\n<p>\nReleased: ...
#> [6] <section><h2 data-id="6">\nReturn of the Jedi\n</h2>\n<p>\nReleased: 1983 ...
#> [7] <section><h2 data-id="7">\nThe Force Awakens\n</h2>\n<p>\nReleased: 2015- ...

# Then use html_element() to extract one element per film. Here
# we the title is given by the text inside <h2>
title <- films %>% 
  html_element("h2") %>% 
  html_text2()
title
#> [1] "The Phantom Menace"      "Attack of the Clones"   
#> [3] "Revenge of the Sith"     "A New Hope"             
#> [5] "The Empire Strikes Back" "Return of the Jedi"     
#> [7] "The Force Awakens"

# Or use html_attr() to get data out of attributes. html_attr() always
# returns a string so we convert it to an integer using a readr function
episode <- films %>% 
  html_element("h2") %>% 
  html_attr("data-id") %>% 
  readr::parse_integer()
episode
#> [1] 1 2 3 4 5 6 7
```

If the page contains tabular data you can convert it directly to a data
frame with `html_table()`:

``` r
html <- read_html("https://en.wikipedia.org/w/index.php?title=The_Lego_Movie&oldid=998422565")

html %>% 
  html_element(".tracklist") %>% 
  html_table()
#> # A tibble: 29 × 4
#>    No.   Title                       `Performer(s)`                       Length
#>    <chr> <chr>                       <chr>                                <chr> 
#>  1 1.    "\"Everything Is Awesome\"" "Tegan and Sara featuring The Lonel… 2:43  
#>  2 2.    "\"Prologue\""              ""                                   2:28  
#>  3 3.    "\"Emmett's Morning\""      ""                                   2:00  
#>  4 4.    "\"Emmett Falls in Love\""  ""                                   1:11  
#>  5 5.    "\"Escape\""                ""                                   3:26  
#>  6 6.    "\"Into the Old West\""     ""                                   1:00  
#>  7 7.    "\"Wyldstyle Explains\""    ""                                   1:21  
#>  8 8.    "\"Emmett's Mind\""         ""                                   2:17  
#>  9 9.    "\"The Transformation\""    ""                                   1:46  
#> 10 10.   "\"Saloons and Wagons\""    ""                                   3:38  
#> # … with 19 more rows
```
