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

