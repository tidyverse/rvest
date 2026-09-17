# Create an HTML document from inline HTML

Create an HTML document from inline HTML

## Usage

``` r
minimal_html(html, title = "")
```

## Arguments

- html:

  HTML contents of page.

- title:

  Page title (required by HTML spec).

## Examples

``` r
minimal_html("<p>test</p>")
#> {html_document}
#> <html>
#> [1] <head>\n<meta http-equiv="Content-Type" content="text/html; char ...
#> [2] <body><p>test</p></body>
```
