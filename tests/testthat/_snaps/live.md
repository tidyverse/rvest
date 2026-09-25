# has print method

    Code
      bullets
    Output
      {xml_nodeset (2)}
      [1] <title>Simple Bulleted List</title>
      [2] <ul>\n<li>Item 1</li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n  <li>Item 4 ...

# select errors when no option matches

    Code
      sess$select("select", value = "z")
    Condition
      Error in `sess$select()`:
      ! No option with value "z" in "select".

---

    Code
      sess$select("select", text = "Fig")
    Condition
      Error in `sess$select()`:
      ! No option with text "Fig" in "select".

# select errors when element is not a select

    Code
      sess$select("p", value = "b")
    Condition
      Error in `sess$select()`:
      ! "p" selects a `<p>` element, not a `<select>`.

---

    Code
      sess$select("p", text = "Banana")
    Condition
      Error in `sess$select()`:
      ! "p" selects a `<p>` element, not a `<select>`.

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

