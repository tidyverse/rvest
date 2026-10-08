# url is validated

    Code
      read_html_live("")
    Condition
      Error in `read_html_live()`:
      ! `url` must be a single string, not the empty string "".
    Code
      read_html_live(123)
    Condition
      Error in `read_html_live()`:
      ! `url` must be a single string, not the number 123.

# errors when navigation fails

    Code
      read_html_live("https://doeasdfsdafastnexist.com")
    Condition
      Error in `read_html_live()`:
      ! Failed to load <https://doeasdfsdafastnexist.com>
      Caused by error:
      ! net::ERR_NAME_NOT_RESOLVED
    Code
      read_html_live(".//")
    Condition
      Error in `read_html_live()`:
      ! Failed to load <.//>
      Caused by error in `callback()`:
      ! code: -32000
        message: Cannot navigate to invalid URL

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
      [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
      [2] <body>\n\n<ul>\n<li>Item 1</li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n   ...

# wait_for errors when element never appears

    Code
      sess$wait_for("#nope", timeout = 0.2)
    Condition
      Error in `private$wait_for_selector()`:
      ! Failed to find selector "#nope" in 0.2 seconds.

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

# invalid selectors error immediately

    Code
      sess$click("button[")
    Condition
      Error in `sess$click()`:
      ! Invalid selector "button[".

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

# read_html_live() checks timeout

    Code
      read_html_live("https://example.com", timeout = "x")
    Condition
      Error in `read_html_live()`:
      ! `timeout` must be a number, not the string "x".

