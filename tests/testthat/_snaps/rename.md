# xml functions are deprecated

    Code
      . <- xml_tag(x)
    Warning <lifecycle_warning_deprecated>
      `xml_tag()` is deprecated as of rvest 1.0.0.
      Please use `html_name()` instead.

---

    Code
      . <- xml_node(x, "p")
    Warning <lifecycle_warning_deprecated>
      `xml_node()` is deprecated as of rvest 1.0.0.
      Please use `html_element()` instead.

---

    Code
      . <- xml_nodes(x, "p")
    Warning <lifecycle_warning_deprecated>
      `xml_nodes()` is deprecated as of rvest 1.0.0.
      Please use `html_elements()` instead.

# set_values() is deprecated

    Code
      set_values(form, text = "abc")
    Warning <lifecycle_warning_deprecated>
      `set_values()` is deprecated as of rvest 1.0.0.
      Please use `html_form_set()` instead.
    Output
      <form> '<unnamed>' (GET )
        <field> (text) text: abc

