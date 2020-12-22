# basic session process works as expected

    Code
      s <- html_session("http://hadley.nz/")
    Code
      s
    Output
      <session> http://hadley.nz/
        Status: 200
        Type:   text/html
        Size:   9090
    Code
      expect_true(is.session(s))
    Code
      s <- follow_link(s, css = "p a")
    Message <message>
      Navigating to http://rstudio.com
    Code
      session_history(s)
    Output
        http://hadley.nz/
      - https://rstudio.com/

# errors if try to access HTML from non-HTML page

    Code
      s <- html_session("https://rvest.tidyverse.org/logo.png")
    Code
      read_html(s)
    Error <rlang_error>
      Page doesn't appear to be html.

# informative errors for bad inputs

    `form` must be produced by html_form()

---

    `x` must be produced by html_session()

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

# useful feedback on invalid forms

    Code
      submission_build(form, NULL, base_url = "http://")
    Error <rlang_error>
      `form` doesn't contain a `action` attribute

---

    Code
      x <- submission_build(form, NULL, base_url = "http://")
    Warning <warning>
      Invalid method (FOO), defaulting to GET

# handles multiple buttons

    Code
      vals <- submission_build_values(form, NULL)
    Message <message>
      Submitting with 'one'

---

    Code
      submission_build_values(form, 3L)
    Error <rlang_error>
      Numeric `submit` out of range

---

    Code
      submission_build_values(form, "three")
    Error <rlang_error>
      No <input> found with name 'three'.
      i Possible values: one, two

---

    Code
      submission_build_values(form, TRUE)
    Error <rlang_error>
      `submit` must be NULL, a string, or a number.

# can submit using three primary techniques

    Code
      show_response(session_submit(session, form))
    Output
      GET 
      Query string: x=1&x=2&y=3
      
    Code
      # deprecated but still works
    Code
      show_response(submit_form(session, form))
    Warning <lifecycle_warning_deprecated>
      `submit_form()` is deprecated as of rvest 1.0.0.
      Please use `session_submit()` instead.
    Output
      GET 
      Query string: x=1&x=2&y=3
      
    Code
      form$method <- "POST"
    Code
      show_response(session_submit(session, form))
    Output
      POST application/x-www-form-urlencoded
      Query string: 
      x=1&x=2&y=3
    Code
      form$enctype <- "multipart"
    Code
      show_response(session_submit(session, form))
    Output
      POST multipart/form-data; boundary=---<divider>
      Query string: 
      ---<divider>
      Content-Disposition: form-data; name="x"
      
      1
      ---<divider>
      Content-Disposition: form-data; name="x"
      
      2
      ---<divider>
      Content-Disposition: form-data; name="y"
      
      3
      ---<divider>--
      

