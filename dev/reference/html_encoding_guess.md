# Guess faulty character encoding

`html_encoding_guess()` helps you handle web pages that declare an
incorrect encoding. Use `html_encoding_guess()` to generate a list of
possible encodings, then try each out by using `encoding` argument of
[`read_html()`](https://rvest.tidyverse.org/dev/reference/read_html.md).
`html_encoding_guess()` replaces the deprecated `guess_encoding()`.

## Usage

``` r
html_encoding_guess(x)
```

## Arguments

- x:

  A character vector.

## Examples

``` r
# A file with bad encoding included in the package
path <- system.file("html-ex", "bad-encoding.html", package = "rvest")
x <- read_html(path)
x |> html_elements("p") |> html_text()
#> [1] "Émigré cause célèbre déjà vu."

html_encoding_guess(x)
#>        encoding language confidence
#> 1         UTF-8                1.00
#> 2  windows-1252       fr       0.31
#> 3  windows-1250       ro       0.22
#> 4      UTF-16BE                0.10
#> 5      UTF-16LE                0.10
#> 6       GB18030       zh       0.10
#> 7          Big5       zh       0.10
#> 8  windows-1254       tr       0.06
#> 9    IBM424_rtl       he       0.01
#> 10   IBM424_ltr       he       0.01
# Two valid encodings, only one of which is correct
read_html(path, encoding = "ISO-8859-1") |> html_elements("p") |> html_text()
#> [1] "Émigré cause célèbre déjà vu."
read_html(path, encoding = "ISO-8859-2") |> html_elements("p") |> html_text()
#> [1] "Émigré cause célčbre déjŕ vu."
```
