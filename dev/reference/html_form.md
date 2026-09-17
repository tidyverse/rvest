# Parse forms and set values

Use `html_form()` to extract a form, set values with `html_form_set()`,
and submit it with `html_form_submit()`.

## Usage

``` r
html_form(x, base_url = NULL)

html_form_set(form, ...)

html_form_submit(form, submit = NULL)
```

## Arguments

- x:

  A document (from
  [`read_html()`](https://rvest.tidyverse.org/dev/reference/read_html.md)),
  node set (from
  [`html_elements()`](https://rvest.tidyverse.org/dev/reference/html_element.md)),
  node (from
  [`html_element()`](https://rvest.tidyverse.org/dev/reference/html_element.md)),
  or session (from
  [`session()`](https://rvest.tidyverse.org/dev/reference/session.md)).

- base_url:

  Base url of underlying HTML document. The default, `NULL`, uses the
  url of the HTML document underlying `x`.

- form:

  A form

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  Name-value pairs giving fields to modify.

  Provide a character vector to set multiple checkboxes in a set or
  select multiple values from a multi-select.

- submit:

  Which button should be used to submit the form?

  - `NULL`, the default, uses the first button.

  - A string selects a button by its name.

  - A number selects a button using its relative position.

## Value

- `html_form()` returns as S3 object with class `rvest_form` when
  applied to a single element. It returns a list of `rvest_form` objects
  when applied to multiple elements or a document.

- `html_form_set()` returns an `rvest_form` object.

- `html_form_submit()` submits the form, returning an httr response
  which can be parsed with
  [`read_html()`](https://rvest.tidyverse.org/dev/reference/read_html.md).

## See also

HTML 4.01 form specification:
<https://www.w3.org/TR/html401/interact/forms.html>

## Examples

``` r
html <- read_html("http://www.google.com")
search <- html_form(html)[[1]]

search <- search |> html_form_set(q = "My little pony", hl = "fr")
#> Warning: Setting value of hidden field "hl".

# Or if you have a list of values, use !!!
vals <- list(q = "web scraping", hl = "en")
search <- search |> html_form_set(!!!vals)
#> Warning: Setting value of hidden field "hl".

# To submit and get result:
if (FALSE) { # \dontrun{
resp <- html_form_submit(search)
read_html(resp)
} # }
```
