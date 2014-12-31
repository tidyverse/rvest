# rvest 0.1.0.9000

* Add xml support: parse with `xml()`, then work with using `xml_node()`,
  `xml_attr()`, `xml_attrs()`, `xml_text()` and `xml_tag()` (#24).

* `xml_structure()`: new function that displays the structure (i.e. tag
  and attribute names) of a xml/html object (#10).

* `html_nodes()` now returns an empty list if no elements are found (#31).

* `html()` and `xml()` pass `...` on to `httr::GET()` so you can more
  finely control the request (#48).

* `html_attr()` returns default value when input is NULL (#49)
