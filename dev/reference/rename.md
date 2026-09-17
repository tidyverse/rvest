# Functions renamed in rvest 1.0.0

**\[deprecated\]**

rvest 1.0.0 renamed a number of functions to ensure that every function
has a common prefix, matching tidyverse conventions that emerged since
rvest was first created.

- `set_values()` -\>
  [`html_form_set()`](https://rvest.tidyverse.org/dev/reference/html_form.md)

- `submit_form()` -\>
  [`session_submit()`](https://rvest.tidyverse.org/dev/reference/session.md)

- `xml_tag()` -\>
  [`html_name()`](https://rvest.tidyverse.org/dev/reference/html_name.md)

- `xml_node()` & `html_node()` -\>
  [`html_element()`](https://rvest.tidyverse.org/dev/reference/html_element.md)

- `xml_nodes()` & `html_nodes()` -\>
  [`html_elements()`](https://rvest.tidyverse.org/dev/reference/html_element.md)

(`html_node()` and `html_nodes()` are only superseded because they're so
widely used.)

Additionally all session related functions gained a common prefix:

- `html_session()` -\>
  [`session()`](https://rvest.tidyverse.org/dev/reference/session.md)

- `forward()` -\>
  [`session_forward()`](https://rvest.tidyverse.org/dev/reference/session.md)

- `back()` -\>
  [`session_back()`](https://rvest.tidyverse.org/dev/reference/session.md)

- `jump_to()` -\>
  [`session_jump_to()`](https://rvest.tidyverse.org/dev/reference/session.md)

- `follow_link()` -\>
  [`session_follow_link()`](https://rvest.tidyverse.org/dev/reference/session.md)

## Usage

``` r
set_values(form, ...)

submit_form(session, form, submit = NULL, ...)

xml_tag(x)

xml_node(...)

xml_nodes(...)

html_nodes(...)

html_node(...)

back(x)

forward(x)

jump_to(x, url, ...)

follow_link(x, ...)

html_session(url, ...)
```
