# Get element attributes

`html_attr()` gets a single attribute; `html_attrs()` gets all
attributes.

## Usage

``` r
html_attr(x, name, default = NA_character_)

html_attrs(x)
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

- name:

  Name of attribute to retrieve.

- default:

  A string used as a default value when the attribute does not exist in
  every element.

## Value

A character vector (for `html_attr()`) or list (`html_attrs()`) the same
length as `x`.

## Examples

``` r
html <- minimal_html('<ul>
  <li><a href="https://a.com" class="important">a</a></li>
  <li class="active"><a href="https://c.com">b</a></li>
  <li><a href="https://c.com">b</a></li>
  </ul>')

html |> html_elements("a") |> html_attrs()
#> [[1]]
#>            href           class 
#> "https://a.com"     "important" 
#> 
#> [[2]]
#>            href 
#> "https://c.com" 
#> 
#> [[3]]
#>            href 
#> "https://c.com" 
#> 

html |> html_elements("a") |> html_attr("href")
#> [1] "https://a.com" "https://c.com" "https://c.com"
html |> html_elements("li") |> html_attr("class")
#> [1] NA       "active" NA      
html |> html_elements("li") |> html_attr("class", default = "inactive")
#> [1] "inactive" "active"   "inactive"
```
