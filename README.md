# rvest

[![Build Status](https://travis-ci.org/hadley/rvest.png?branch=master)](https://travis-ci.org/hadley/rvest)

rvest helps you scrape information from web pages. It designed to work with [magrittr](https://github.com/smbache/magrittr) to make it easy to express common web scraping tasks, inspired by libraries like [beautiful soup](http://www.crummy.com/software/BeautifulSoup/).

```R
library(rvest)
lego_movie <- html("http://www.imdb.com/title/tt1490017/")

rating <- lego_movie %>% 
  html_node("strong span") %>%
  html_text() %>%
  as.numeric()

cast <- lego_movie %>%
  html_node("#titleCast .itemprop span") %>%
  html_text()

poster <- lego_movie %>%
  html_node("#img_primary img") %>%
  html_attr("src")
```

The most important functions in rvest are:

* Create an html document from a url, a file on disk or a string containing
  html with `html()`.

* Select parts of a document using css selectors: `html_node(doc, "table td")`
  (or if you've a glutton for punishment, use xpath selectors with
  `html_node(doc, xpath = "//table//td")`). If you haven't heard of 
  [selectorgadget](http://selectorgadget.com/), make sure to read
  `vignette("selectorgadget")` to learn about it.

* Extract important components of html tags with `html_tag()` (the name of the
  tag), `html_text()` (all text contained inside the tag), `html_attr()`
  (contents of a single attribute) and `html_attrs()` (all attributes).

* Parse tables into data frames with `html_table()`.

* Extract, modify and submit forms with `html_form()`, `set_values()` and
  `submit_form()`

* Navigate around a website as if you're in a browser with `html_session()`,
  `jump_to()`, `follow_link()`, `back()`, `forward()`, `submit_form()` and
  so on. (This is still a work in progress, so I'd love your feedback.)

To see examples of these function in use, check out the demos.

## Installation

rvest isn't available on CRAN (yet), so download it directly from github with:

```R
# install.packages("devtools")
install_github("hadley/rvest")
```

## Inspirations

* Python: [Robobrowser](http://robobrowser.readthedocs.org/en/latest/readme.html),
  [beautiful soup](http://www.crummy.com/software/BeautifulSoup/).
