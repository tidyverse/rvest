# Repair faulty encoding

**\[deprecated\]** This function has been deprecated because it doesn't
work. Instead re-read the HTML file with correct `encoding` argument.

## Usage

``` r
repair_encoding(x, from = NULL)
```

## Arguments

- from:

  The encoding that the string is actually in. If `NULL`,
  `guess_encoding` will be used.
