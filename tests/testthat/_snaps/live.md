# has print method

    Code
      bullets
    Output
      {xml_nodeset (2)}
      [1] <title>Simple Bulleted List</title>
      [2] <ul>\n<li>Item 1</li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n  <li>Item 4 ...

# download_path falls back to suggested filename

    Code
      download_path(list(), dir, "b.txt")
    Condition
      Error:
      ! Download completed but couldn't find the file in '<dir>'.
    Code
      download_path(list(), dir, NULL)
    Condition
      Error:
      ! Download completed but couldn't find the file in '<dir>'.

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

