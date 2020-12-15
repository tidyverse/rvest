# can set values of inputs

    Code
      form <- set_values(form, hidden = "abc")
    Warning <simpleWarning>
      Setting value of hidden field 'hidden'.

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

