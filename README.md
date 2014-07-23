# rvest

[![Build Status](https://travis-ci.org/hadley/rvest.png?branch=master)](https://travis-ci.org/hadley/rvest)

rvest helps you scrape information from web pages. It currently provides two main features:

* Easily select parts of a document using css selectors: `doc[sel("table td")]`

* Extract, modify and submit forms with `parse_forms()`, `set_values()` and
  `submit_form()`

# Inspirations

* Python: [Robobrowser](http://robobrowser.readthedocs.org/en/latest/readme.html)
