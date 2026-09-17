# Parse an html table into a data frame

The algorithm mimics what a browser does, but repeats the values of
merged cells in every cell that cover.

## Usage

``` r
html_table(
  x,
  header = NA,
  trim = TRUE,
  fill = deprecated(),
  dec = ".",
  na.strings = "NA",
  convert = TRUE
)
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

- header:

  Use first row as header? If `NA`, will use first row if it consists of
  `<th>` tags.

  If `TRUE`, column names are left exactly as they are in the source
  document, which may require post-processing to generate a valid data
  frame.

- trim:

  Remove leading and trailing whitespace within each cell?

- fill:

  Deprecated - missing cells in tables are now always automatically
  filled with `NA`.

- dec:

  The character used as decimal place marker.

- na.strings:

  Character vector of values that will be converted to `NA` if `convert`
  is `TRUE`.

- convert:

  If `TRUE`, will run
  [`type.convert()`](https://rdrr.io/r/utils/type.convert.html) to
  interpret texts as integer, double, or `NA`.

## Value

When applied to a single element, `html_table()` returns a single
tibble. When applied to multiple elements or a document, `html_table()`
returns a list of tibbles.

## Examples

``` r
sample1 <- minimal_html("<table>
  <tr><th>Col A</th><th>Col B</th></tr>
  <tr><td>1</td><td>x</td></tr>
  <tr><td>4</td><td>y</td></tr>
  <tr><td>10</td><td>z</td></tr>
</table>")
sample1 |>
  html_element("table") |>
  html_table()
#> # A tibble: 3 × 2
#>   `Col A` `Col B`
#>     <int> <chr>  
#> 1       1 x      
#> 2       4 y      
#> 3      10 z      

# Values in merged cells will be duplicated
sample2 <- minimal_html("<table>
  <tr><th>A</th><th>B</th><th>C</th></tr>
  <tr><td>1</td><td>2</td><td>3</td></tr>
  <tr><td colspan='2'>4</td><td>5</td></tr>
  <tr><td>6</td><td colspan='2'>7</td></tr>
</table>")
sample2 |>
  html_element("table") |>
  html_table()
#> # A tibble: 3 × 3
#>       A     B     C
#>   <int> <int> <int>
#> 1     1     2     3
#> 2     4     4     5
#> 3     6     7     7

# If a row is missing cells, they'll be filled with NAs
sample3 <- minimal_html("<table>
  <tr><th>A</th><th>B</th><th>C</th></tr>
  <tr><td colspan='2'>1</td><td>2</td></tr>
  <tr><td colspan='2'>3</td></tr>
  <tr><td>4</td></tr>
</table>")
sample3 |>
  html_element("table") |>
  html_table()
#> # A tibble: 3 × 3
#>       A     B     C
#>   <int> <int> <int>
#> 1     1     1     2
#> 2     3     3    NA
#> 3     4    NA    NA
```
