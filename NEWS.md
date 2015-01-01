# rvest 0.2.0

## New features

* `html()` and `xml()` pass `...` on to `httr::GET()` so you can more
  finely control the request (#48).

* Add xml support: parse with `xml()`, then work with using `xml_node()`,
  `xml_attr()`, `xml_attrs()`, `xml_text()` and `xml_tag()` (#24).

* `xml_structure()`: new function that displays the structure (i.e. tag
  and attribute names) of a xml/html object (#10).

## Bug fixes

* `follow_link()` now accepts css and xpath selectors. (#38, #41, #42)

* `html()` does a better job of dealing with encodings (passing the
  problem on to `XML::parseHTML()`) instead of trying to do it itself 
  (#25, #50).

* `html_attr()` returns default value when input is NULL (#49)

* Add missing `html_node()` method for session.

* `html_nodes()` now returns an empty list if no elements are found (#31).

* `submit_form()` converts relative paths to absolute URLS (#52).
  It also deals better with 0-length inputs (#29).
