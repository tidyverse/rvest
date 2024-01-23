# basic session process works as expected

    Code
      s <- session("http://hadley.nz/")
      s
    Output
      <session> https://hadley.nz/
        Status: 200
        Type:   text/html; charset=utf-8
        Size:   821273
    Code
      expect_true(is.session(s))
      s <- session_follow_link(s, css = "p a")
    Message
      Navigating to http://rstudio.com
    Code
      session_history(s)
    Output
        https://hadley.nz/
      - https://posit.co/

# errors if try to access HTML from non-HTML page

    Code
      s <- session("https://rvest.tidyverse.org/logo.png")
      read_html(s)
    Condition
      Error in `read_html()`:
      ! Page doesn't appear to be html.

# informative errors for bad inputs

    `form` must be a single form produced by `html_form()`.

---

    `x` must be produced by `session()`.

# can navigate back and forward

    Can't go back any further.

---

    Can't go forward any further.

# can find link by position, content, css, or xpath

    Code
      find_href(html, i = 1, css = "a")
    Condition
      Error:
      ! Exactly one of `i`, `css`, or `xpath` must be supplied.
      x `i` and `css` were supplied together.

---

    Code
      find_href(html, i = TRUE)
    Condition
      Error:
      ! `i` must a string or integer

---

    Code
      find_href(html, i = "c")
    Condition
      Error:
      ! No links have text "c".

---

    Code
      find_href(html, css = "p a")
    Condition
      Error:
      ! No links matched `css`/`xpath`

