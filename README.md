# rvest

[![Build Status](https://travis-ci.org/hadley/rvest.png?branch=master)](https://travis-ci.org/hadley/rvest)

rvest helps you scrape information from web pages. It currently provides two main features:

* Select parts of a document using css selectors: `doc[sel("table td")]`

* Extract important components of html tags with `html_tag()`, `html_text()`,
  `html_attr()` and `html_attrs()`.

* Parse tables into data frames with `html_table()`.

* Extract, modify and submit forms with `parse_forms()`, `set_values()` and
  `submit_form()`

# Inspirations

* Python: [Robobrowser](http://robobrowser.readthedocs.org/en/latest/readme.html)
