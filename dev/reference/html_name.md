# Get element name

Get element name

## Usage

``` r
html_name(x)
```

## Arguments

- x:

  A document (from
  [`read_html()`](https://rvest.tidyverse.org/dev/reference/read_html.md)),
  node set (from
  [`html_elements()`](https://rvest.tidyverse.org/dev/reference/html_element.md)),
  node (from
  [`html_element()`](https://rvest.tidyverse.org/dev/reference/html_element.md)),
  or session (from
  [`session()`](https://rvest.tidyverse.org/dev/reference/session.md)).

## Value

A character vector the same length as `x`

## Examples

``` r
url <- "https://rvest.tidyverse.org/articles/starwars.html"
html <- read_html(url)

html |>
  html_element("div") |>
  html_children() |>
  html_name()
#> [1] "a"      "small"  "button" "div"   
```
