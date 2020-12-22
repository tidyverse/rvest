# has useful print method

    Code
      html_form(html)[[1]]
    Output
      <form> 'test' (POST /test-path)
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
    Warning <warning>
      Unknown enctype (unknown). Defaulting to form encoded.
    Output
      [1] "form"

# can set values of inputs

    Code
      form <- html_form_set(form, hidden = "abc")
    Warning <warning>
      Setting value of hidden field 'hidden'.

# has informative errors

    Code
      html_form_set(form, text = "x")
    Error <rlang_error>
      Can't change value of input with type submit: 'text'.

---

    Code
      html_form_set(form, missing = "x")
    Error <rlang_error>
      Can't set value of fields that don't exist: ' missing '

