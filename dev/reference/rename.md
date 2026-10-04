# Functions renamed in rvest 1.0.0

**\[superseded\]**

rvest 1.0.0 renamed a number of functions to ensure that every function
has a common prefix, matching tidyverse conventions that emerged since
rvest was first created. Most of the renamed functions have now been
removed, but `html_node()` and `html_nodes()` are still superseded
(rather than removed) because they're so widely used:

- `html_node()` -\>
  [`html_element()`](https://rvest.tidyverse.org/dev/reference/html_element.md)

- `html_nodes()` -\>
  [`html_elements()`](https://rvest.tidyverse.org/dev/reference/html_element.md)

## Usage

``` r
html_nodes(...)

html_node(...)
```
