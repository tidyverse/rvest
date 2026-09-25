# has print method

    Code
      bullets
    Output
      {xml_nodeset (2)}
      [1] <title>Simple Bulleted List</title>
      [2] <ul>\n<li>Item 1</li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n  <li>Item 4 ...

# mouse click on hidden element errors helpfully

    Code
      sess$click("#hiddenButton")
    Condition
      Error in `sess$click()`:
      ! Element "#hiddenButton" can't be clicked with the mouse.
      i It may be hidden or zero-sized.
      i Try `method = 'js'` to fire a JavaScript click event instead.
      Caused by error in `callback()`:
      ! code: -32000
        message: Node does not have a layout object

---

    Code
      sess$click("#hiddenButton", n_clicks = 2, method = "js")
    Condition
      Error in `sess$click()`:
      ! `n_clicks` is not supported when `method = 'js'`.

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

