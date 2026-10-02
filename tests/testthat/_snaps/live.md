# mode and view are validated

    Code
      read_html_live("https://rvest.tidyverse.org", mode = "invisible")
    Condition
      Error in `read_html_live()`:
      ! `mode` must be one of "headless" or "visible", not "invisible".
      i Did you mean "visible"?
    Code
      read_html_live("https://rvest.tidyverse.org", view = "tablet")
    Condition
      Error in `read_html_live()`:
      ! `view` must be one of "desktop" or "mobile", not "tablet".

# has print method

    Code
      bullets
    Output
      {xml_nodeset (2)}
      [1] <title>Simple Bulleted List</title>
      [2] <ul>\n<li>Item 1</li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n  <li>Item 4 ...

# gracefully errors on bad inputs

    Code
      as_key_desc("xyz")
    Condition
      Error in `as_key_desc()`:
      ! No key definition for "xyz".
    Code
      as_key_desc("X", "Malt")
    Condition
      Error:
      ! `modifiers` must be one of "Alt", "Control", "Meta", or "Shift", not "Malt".
      i Did you mean "Alt"?

