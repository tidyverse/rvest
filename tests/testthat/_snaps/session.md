# basic session process works as expected

    Code
      s <- session("http://hadley.nz/")
      s
    Output
      <session> http://hadley.nz/
        Status: 200
        Type:   text/html
        Size:   9090
    Code
      expect_true(is.session(s))
      s <- session_follow_link(s, css = "p a")
    Message <message>
      Navigating to http://rstudio.com
    Code
      session_history(s)
    Output
        http://hadley.nz/
      - https://rstudio.com/

# errors if try to access HTML from non-HTML page

    Code
      s <- session("https://rvest.tidyverse.org/logo.png")
      read_html(s)
    Error <rlang_error>
      Page doesn't appear to be html.

# informative errors for bad inputs

    `form` must be a single form produced by html_form()

---

    `x` must be produced by session()

# can navigate back and forward

    Can't go back any further

---

    Can't go forward any further

# can find link by position, content, css, or xpath

    Code
      find_href(html, i = 1, css = "a")
    Error <rlang_error>
      Must supply exactly one of `i`, `css`, or `xpath`

---

    Code
      find_href(html, i = TRUE)
    Error <rlang_error>
      `i` must a string or integer

---

    Code
      find_href(html, i = "c")
    Error <simpleError>
      No links have text 'c'

---

    Code
      find_href(html, css = "p a")
    Error <rlang_error>
      No links matched `css`/`xpath`

