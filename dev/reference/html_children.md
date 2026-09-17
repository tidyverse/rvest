# Get element children

Get element children

## Usage

``` r
html_children(x)
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

## Examples

``` r
html <- minimal_html("<ul><li>1<li>2<li>3</ul>")
ul <- html_elements(html, "ul")
html_children(ul)
#> {xml_nodeset (3)}
#> [1] <li>1</li>\n
#> [2] <li>2</li>\n
#> [3] <li>3</li>

html <- minimal_html("<p>Hello <b>Hadley</b><i>!</i>")
p <- html_elements(html, "p")
html_children(p)
#> {xml_nodeset (2)}
#> [1] <b>Hadley</b>
#> [2] <i>!</i>
```
