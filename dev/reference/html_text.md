# Get element text

There are two ways to retrieve text from a element: `html_text()` and
`html_text2()`. `html_text()` is a thin wrapper around
[`xml2::xml_text()`](http://xml2.r-lib.org/reference/xml_text.md) which
returns just the raw underlying text. `html_text2()` simulates how text
looks in a browser, using an approach inspired by JavaScript's
[innerText()](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/innerText).
Roughly speaking, it converts `<br />` to `"\n"`, adds blank lines
around `<p>` tags, and lightly formats tabular data.

`html_text2()` is usually what you want, but it is much slower than
`html_text()` so for simple applications where performance is important
you may want to use `html_text()` instead.

## Usage

``` r
html_text(x, trim = FALSE)

html_text2(x, preserve_nbsp = FALSE)
```

## Arguments

- x:

  A document, node, or node set.

- trim:

  If `TRUE` will trim leading and trailing spaces.

- preserve_nbsp:

  Should non-breaking spaces be preserved? By default, `html_text2()`
  converts to ordinary spaces to ease further computation. When
  `preserve_nbsp` is `TRUE`, `&nbsp;` will appear in strings as
  `"\ua0"`. This often causes confusion because it prints the same way
  as `" "`.

## Value

A character vector the same length as `x`

## Examples

``` r
# To understand the difference between html_text() and html_text2()
# take the following html:

html <- minimal_html(
  "<p>This is a paragraph.
    This another sentence.<br>This should start on a new line"
)

# html_text() returns the raw underlying text, which includes whitespace
# that would be ignored by a browser, and ignores the <br>
html |> html_element("p") |> html_text() |> writeLines()
#> This is a paragraph.
#>     This another sentence.This should start on a new line

# html_text2() simulates what a browser would display. Non-significant
# whitespace is collapsed, and <br> is turned into a line break
html |> html_element("p") |> html_text2() |> writeLines()
#> This is a paragraph. This another sentence.
#> This should start on a new line

# By default, html_text2() also converts non-breaking spaces to regular
# spaces:
html <- minimal_html("<p>x&nbsp;y</p>")
x1 <- html |> html_element("p") |> html_text()
x2 <- html |> html_element("p") |> html_text2()

# When printed, non-breaking spaces look exactly like regular spaces
x1
#> [1] "x y"
x2
#> [1] "x y"
# But aren't actually the same:
x1 == x2
#> [1] FALSE
# Which you can confirm by looking at their underlying binary
# representaion:
charToRaw(x1)
#> [1] 78 c2 a0 79
charToRaw(x2)
#> [1] 78 20 79
```
