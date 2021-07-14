# rvest (development version)

* `html_table()` correctly handles tables with cells that contain blank values 
  for `rowspan` and/or `colspan`, so that e.g. `<td rowspan="">` is parsed as 
  `<td rowspan=1>` (@epiben, #323).

# rvest 1.0.0
(to be released as rvest 1.0.0)

## New features

* New `html_text2()` provides a more natural rendering of HTML nodes into text,
  converting `<br>` into "\n", and removing non-significant whitespace (#175). 
  By default, it also converts `&nbsp;` into regular spaces, which you can 
  suppress with `preserve_nbsp = TRUE` (#284).

* `html_table()` has been re-written from scratch to more closely mimic the
  algorithm that browsers use for parsing tables. This should mean that there
  are far fewer tables for which it fails to produce some output (#63, #204,
  #215). The `fill` argument has been deprecated since it is no longer needed.
  `html_table()` now returns a tibble rather than a data frame to be compatible
  with the rest of the tidyverse (#199). Its performance has been considerably
  improved (#237). It also gains a `na.strings` argument to control what values 
  are converted to `NA` (#107), and a `convert` argument to control whether to
  run the conversion (#311).

* New `html_form_submit()` allows you to submit a form directly, without 
  needing to create a session (#300).

* rvest is now licensed as MIT (#287).

## API changes

Since this is the 1.0.0 release, I included a large number of API changes to make rvest more compatible with current tidyverse conventions. Older functions have been deprecated, so existing code will continue to work (albeit with a few new warnings).

* rvest now imports xml2 rather than depending on it. This is cleaner because
  it avoids attaching all the xml2 functions that you're less likely to use.
  To reduce the change of breakages, rvest re-exports xml2 functions 
  `read_html()` and `url_absolute()`, but your code may now need an explicit
  `library(xml2)`.

* `html_form()` now returns an object with class `rvest_form` (instead of form).
   Fields within a form now have class `rvest_field`, instead of a
  variety of classes that were lacking the `rvest_` prefix. All functions for
  working with forms have a common `html_form_` prefix: `set_values()` became
  `html_form_set()`. `submit_form()` was renamed to `session_submit()` because
  it returns a session.

* `html_node()` and `html_nodes()` have been superseded in favor of
  `html_element()`  and `html_elements()` since they (almost) always return 
  elements, not nodes (#298). 

* `html_session()` is now `session()` and returns an object of class 
  `rvest_session` (instead of `session`). All functions that work with session
  objects now have a common `session_` prefix. 

* Long deprecated `html()`, `html_tag()`, `xml()` functions have been removed. 

* `minimal_html()` (which doesn't appear to be used by any other package)
  has had its arguments flipped to make it more intuitive.

* `guess_encoding()` has been renamed to `html_encoding_guess()` to avoid
  a clash with `stringr::guess_encoding()` (#209). `repair_encoding()` has 
  been deprecated because it doesn't appear to work.

* `pluck()` is no longer exported to avoid a clash with `purrr::pluck()`; 
  if you need it use `purrr::map_chr()` and friends instead (#209).

* `xml_tag()`, `xml_node()`, and `xml_nodes()` have been formally deprecated
  in favor of their `html_` equivalents.

## Minor improvements and bug fixes

* The "harvesting the web" vignette has been rewritten to focus more on basics 
  rvest, eliminating the screenshots to keep the installed package as svelte as 
  possible. It's also been renamed to `vignette("rvest")` since it's the 
  vignette that you should read first.

* The SelectorGadget vignette is now a web-only article,
  <https://rvest.tidyverse.org/articles/articles/selectorgadget.html>,
  so we can be more generous with screenshots since they're no longer bundled 
  with every install of the package. Together with the rewrite of the other
  vignette, this means that rvest is now ~90 Kb instead of ~1.1 Mb.

* All uses of IMDB have been eliminated since the site explicitly prohibits
  scraping (#195).

* `session_submit()` errors if `form` doesn't have a `url` (#288).

* New `session_forward()` function to complement `session_back()`.
  It now allows you to pick the submission button by position (#156). 
  The `...` argument is deprecated; please use `config` instead.

* `html_form_set()` can now accept character vectors allowing you to select
  multiple checkboxes in a set or select multiple values from a multi-`<select>`
  (#127, with help from @juba). It also uses dynamic dots so that you can use 
  `!!!` if you have a list of values (#189).

# rvest 0.3.6

* Remove failing example

# rvest 0.3.5

* Use web archive to fix broken example.

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
