# can parse simple table

    # A tibble: 2 x 3
          x y     z      
      <int> <chr> <chr>  
    1     1 Eve   Jackson
    2     2 John  Doe    

# can parse with colspan

    # A tibble: 3 x 3
          x     y     z
      <int> <int> <int>
    1     1     1     1
    2     1     1     2
    3     1     2     2

# can parse with rowspan

    # A tibble: 3 x 3
          x     y     z
      <int> <int> <int>
    1     1     2     3
    2     1     2     3
    3     1     2     3

# can handle wobbling rowspan

    # A tibble: 3 x 3
      x     y     z    
      <chr> <chr> <chr>
    1 1a    1b    1c   
    2 1a    2b    1c   
    3 3a    2b    3c   

# can handle trailing rowspans

    # A tibble: 4 x 3
          x     y     z
      <int> <int> <int>
    1     1     2     3
    2    NA     2     3
    3    NA     2    NA
    4    NA     2    NA

# can handle blank colspans

    # A tibble: 2 x 2
          x     y
      <int> <int>
    1     1     2
    2     3     3

# can handle blank rowspans

    # A tibble: 2 x 2
          x     y
      <int> <int>
    1     1     2
    2     3     3

# can handle empty row

    # A tibble: 1 x 1
          x
      <int>
    1     2

# no conversion

    # A tibble: 1 x 2
      x     y    
      <chr> <chr>
    1 001   100.0

# fill = FALSE is deprecated

    Code
      . <- html_table(html, fill = FALSE)
    Warning <lifecycle_warning_deprecated>
      The `fill` argument of `html_table()` is deprecated as of rvest 1.0.0.
      An improved algorithm fills by default so it is no longer needed.
    Code
      . <- html_table(html, fill = TRUE)

