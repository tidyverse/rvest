# xml functions are deprecated

    Code
      . <- xml_tag(x)
    Warning <lifecycle_warning_deprecated>
      `xml_tag()` was deprecated in rvest 1.0.0.
      Please use `html_name()` instead.

---

    Code
      . <- xml_node(x, "p")
    Warning <lifecycle_warning_deprecated>
      `xml_node()` was deprecated in rvest 1.0.0.
      Please use `html_element()` instead.

---

    Code
      . <- xml_nodes(x, "p")
    Warning <lifecycle_warning_deprecated>
      `xml_nodes()` was deprecated in rvest 1.0.0.
      Please use `html_elements()` instead.

# set_values() is deprecated

    Code
      set_values(form, text = "abc")
    Warning <lifecycle_warning_deprecated>
      `set_values()` was deprecated in rvest 1.0.0.
      Please use `html_form_set()` instead.
    Output
      <form> '<unnamed>' (GET )
        <field> (text) text: abc

# prefixless session functions are deprecated

    Code
      s <- html_session("http://rvest.tidyverse.org/")
    Warning <lifecycle_warning_deprecated>
      `html_session()` was deprecated in rvest 1.0.0.
      Please use `session()` instead.
    Code
      . <- follow_link(s, i = 1)
    Warning <lifecycle_warning_deprecated>
      `follow_link()` was deprecated in rvest 1.0.0.
      Please use `session_follow_link()` instead.
    Message <message>
      Navigating to index.html
    Code
      s <- jump_to(s, "https://rvest.tidyverse.org/reference/index.html")
    Warning <lifecycle_warning_deprecated>
      `jump_to()` was deprecated in rvest 1.0.0.
      Please use `session_jump_to()` instead.
    Code
      s <- back(s)
    Warning <lifecycle_warning_deprecated>
      `back()` was deprecated in rvest 1.0.0.
      Please use `session_back()` instead.
    Code
      s <- forward(s)
    Warning <lifecycle_warning_deprecated>
      `forward()` was deprecated in rvest 1.0.0.
      Please use `session_forward()` instead.

