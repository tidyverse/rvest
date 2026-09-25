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

# read_html_live() checks timeout

    Code
      read_html_live("https://example.com", timeout = "x")
    Condition
      Error in `read_html_live()`:
      ! `timeout` must be a number, not the string "x".

