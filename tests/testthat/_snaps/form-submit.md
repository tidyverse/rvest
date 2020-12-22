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
      

