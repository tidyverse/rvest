# validates inputs

    Code
      html_attr(html, 1)
    Condition
      Error in `html_attr()`:
      ! `name` must be a single string, not the number 1.
    Code
      html_attr(html, "id", 1)
    Condition
      Error in `html_attr()`:
      ! `default` must be a single string or `NA`, not the number 1.

