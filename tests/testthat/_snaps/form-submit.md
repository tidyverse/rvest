# can set values of inputs

    Code
      form <- form_set(form, hidden = "abc")
    Warning <warning>
      Setting value of hidden field 'hidden'.

# has informative errors

    Code
      form_set(form, text = "x")
    Error <rlang_error>
      Can't change value of input with type submit: 'text'.

---

    Code
      form_set(form, missing = "x")
    Error <rlang_error>
      Can't set value of fields that don't exist: ' missing '

# set_values() is deprecated

    Code
      set_values(form, text = "abc")
    Warning <lifecycle_warning_deprecated>
      `set_values()` is deprecated as of rvest 1.0.0.
      Please use `form_set()` instead.
    Output
      <form> '<unnamed>' (GET )
        <field> (text) text: abc

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
      show_response(form_submit(form, session))
    Output
      GET 
      Query string: x=1&x=2&y=3
      
    Code
      # deprecated but still works
    Code
      show_response(submit_form(session, form))
    Warning <lifecycle_warning_deprecated>
      `submit_form()` is deprecated as of rvest 1.0.0.
      Please use `form_submit()` instead.
    Output
      GET 
      Query string: x=1&x=2&y=3
      
    Code
      form$method <- "POST"
    Code
      show_response(form_submit(form, session))
    Output
      POST application/x-www-form-urlencoded
      Query string: 
      x=1&x=2&y=3
    Code
      form$enctype <- "multipart"
    Code
      show_response(form_submit(form, session))
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
      

