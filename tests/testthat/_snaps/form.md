# has useful print method

    Code
      html_form(html, base_url = "http://google.com")[[1]]
    Output
      <form> 'test' (POST http://google.com/test-path)
        <field> (select) select: 
        <field> (text) name: Hadley
        <field> (password) name: ******
        <field> (button) clickMe: 
        <field> (textarea) address: ABCDEF

---

    Code
      html_form(html)[[1]]$fields[[2]]
    Output
      <field> (text) name: Hadley

# handles different encoding types

    Code
      convert_enctype("unknown")
    Condition
      Warning:
      Unknown enctype (unknown). Defaulting to form encoded.
    Output
      [1] "form"

# can set values of inputs

    Code
      form <- html_form_set(form, hidden = "abc")
    Condition
      Warning:
      Setting value of hidden field 'hidden'.

# has informative errors

    Code
      html_form_set(form, text = "x")
    Condition
      Error in `html_form_set()`:
      ! Can't change value of input with type submit: 'text'.

---

    Code
      html_form_set(form, missing = "x")
    Condition
      Error in `check_fields()`:
      ! Can't set value of fields that don't exist: ' missing '

# useful feedback on invalid forms

    Code
      submission_build(form, NULL)
    Condition
      Error in `submission_build()`:
      ! `form` doesn't contain a `action` attribute

---

    Code
      x <- submission_build(form, NULL)
    Condition
      Warning:
      Invalid method (FOO), defaulting to GET

# handles multiple buttons

    Code
      vals <- submission_build_values(form, NULL)
    Message
      Submitting with 'one'

---

    Code
      submission_build_values(form, 3L)
    Condition
      Error in `submission_find_submit()`:
      ! Numeric `submit` out of range

---

    Code
      submission_build_values(form, "three")
    Condition
      Error in `submission_find_submit()`:
      ! No <input> found with name 'three'.
      i Possible values: one, two

---

    Code
      submission_build_values(form, TRUE)
    Condition
      Error in `submission_find_submit()`:
      ! `submit` must be NULL, a string, or a number.

# can submit using three primary techniques

    Code
      show_response(html_form_submit(form))
    Output
      GET 
      Query string: x=1&x=2&y=3
      
    Code
      form$method <- "POST"
      show_response(html_form_submit(form))
    Output
      POST application/x-www-form-urlencoded
      Query string: 
      x=1&x=2&y=3
    Code
      form$enctype <- "multipart"
      show_response(html_form_submit(form))
    Output
      POST multipart/form-data; boundary=---{divider}
      Query string: 
      ---{divider}
      Content-Disposition: form-data; name="x"
      
      1
      ---{divider}
      Content-Disposition: form-data; name="x"
      
      2
      ---{divider}
      Content-Disposition: form-data; name="y"
      
      3
      ---{divider}
      

