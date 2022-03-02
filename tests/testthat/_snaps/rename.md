# xml functions are deprecated

    Code
      . <- xml_tag(x)
    Condition
      Warning:
      `xml_tag()` was deprecated in rvest 1.0.0.
      Please use `html_name()` instead.

---

    Code
      . <- xml_node(x, "p")
    Condition
      Warning:
      `xml_node()` was deprecated in rvest 1.0.0.
      Please use `html_element()` instead.

---

    Code
      . <- xml_nodes(x, "p")
    Condition
      Warning:
      `xml_nodes()` was deprecated in rvest 1.0.0.
      Please use `html_elements()` instead.

# set_values() is deprecated

    Code
      set_values(form, text = "abc")
    Condition
      Warning:
      `set_values()` was deprecated in rvest 1.0.0.
      Please use `html_form_set()` instead.
    Output
      <form> '<unnamed>' (GET )
        <field> (text) text: abc

# prefixless session functions are deprecated

    Code
      s <- html_session("http://rvest.tidyverse.org/")
    Condition
      Warning:
      `html_session()` was deprecated in rvest 1.0.0.
      Please use `session()` instead.
    Code
      . <- follow_link(s, i = 1)
    Condition
      Warning:
      `follow_link()` was deprecated in rvest 1.0.0.
      Please use `session_follow_link()` instead.
    Message
      Navigating to #container
    Code
      s <- jump_to(s, "https://rvest.tidyverse.org/reference/index.html")
    Condition
      Warning:
      `jump_to()` was deprecated in rvest 1.0.0.
      Please use `session_jump_to()` instead.
    Code
      s <- back(s)
    Condition
      Warning:
      `back()` was deprecated in rvest 1.0.0.
      Please use `session_back()` instead.
    Code
      s <- forward(s)
    Condition
      Warning:
      `forward()` was deprecated in rvest 1.0.0.
      Please use `session_forward()` instead.

