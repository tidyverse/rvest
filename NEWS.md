# rvest 0.3.4

* Remove unneeded `read_xml.response()` method (#242).

# rvest 0.3.3

* Fix `R CMD check` failure

* `submit_request()` now checks for empty form-field-types to select the
   correct submit fields (@rentrop, #159)

# rvest 0.3.2

* Fixes to `follow_link()` and `back()` to correctly manage session history.

* If you're using xml2 1.0.0, `html_node()` will now return a "missing node".

* Parse rowspans and colspans effectively by filling using repetition from 
  left to right (for colspan) and top to bottom (rowspan) (#111)

* Updated a few examples and demos where the website structure has
  changed.

* Made compatible with both xml2 0.1.2 and 1.0.0.

# rvest 0.3.1

* Fix invalid link for SSA example.

* Parse `<options>` that don't have value attribute (#85).

* Remove all remaining uses of `html()` in favor of `read_html()` 
  (@jimhester, #113).

# rvest 0.3.0

* rvest has been rewritten to take advantage of the new xml2 package. xml2 
  provides a fresh binding to libxml2, avoiding many of the work-arounds 
  previously needed for the XML package. Now rvest depends on the xml2 
  package, so all the xml functions are available, and rvest adds a thin 
  wrapper for html. 
  
* A number of functions have change names. The old versions still work,
  but are deprecated and will be removed in rvest 0.4.0.
  
  * `html_tag()` -> `html_name()`
  * `html()` -> `read_html()`

* `html_node()` now throws an error if there are no matches, and a warning
  if there's more than one match. I think this should make it more likely to
  fail clearly when the structure of the page changes.

* `xml_structure()` has been moved to xml2. New `html_structure()` (also in 
  xml2) highlights id and class attributes (#78).

* `submit_form()` now works with forms that use GET (#66).

* `submit_request()` (and hence `submit_form()`) is now case-insensitive, 
  and so will find `<input type=SUBMIT>` as well as`<input type="submit">`.
  
* `submit_request()` (and hence `submit_form()`) recognizes forms with 
  `<input type="image">` as a valid form submission button.
  
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

* `submit_form()` converts relative paths to absolute URLs (#52).
  It also deals better with 0-length inputs (#29).
