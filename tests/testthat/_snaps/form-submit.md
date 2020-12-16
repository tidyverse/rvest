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
        <input text> 'text': abc

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

