# Simulate a session in web browser

This set of functions allows you to simulate a user interacting with a
website, using forms and navigating from page to page.

- Create a session with `session(url)`

- Navigate to a specified url with `session_jump_to()`, or follow a link
  on the page with `session_follow_link()`.

- Submit an
  [html_form](https://rvest.tidyverse.org/dev/reference/html_form.md)
  with `session_submit()`.

- View the history with `session_history()` and navigate back and
  forward with `session_back()` and `session_forward()`.

- Extract page contents with
  [`html_element()`](https://rvest.tidyverse.org/dev/reference/html_element.md)
  and
  [`html_elements()`](https://rvest.tidyverse.org/dev/reference/html_element.md),
  or get the complete HTML document with
  [`read_html()`](https://rvest.tidyverse.org/dev/reference/read_html.md).

- Inspect the HTTP response with
  [`httr::cookies()`](https://httr.r-lib.org/reference/cookies.html),
  [`httr::headers()`](https://httr.r-lib.org/reference/headers.html),
  and
  [`httr::status_code()`](https://httr.r-lib.org/reference/status_code.html).

## Usage

``` r
session(url, ...)

is.session(x)

session_jump_to(x, url, ...)

session_follow_link(x, i, css, xpath, ...)

session_back(x)

session_forward(x)

session_history(x)

session_submit(x, form, submit = NULL, ...)
```

## Arguments

- url:

  A URL, either relative or absolute, to navigate to.

- ...:

  Any additional httr config to use throughout the session.

- x:

  A session.

- i:

  A integer to select the ith link or a string to match the first link
  containing that text (case sensitive).

- css, xpath:

  Elements to select. Supply one of `css` or `xpath` depending on
  whether you want to use a CSS selector or XPath 1.0 expression.

- form:

  An [html_form](https://rvest.tidyverse.org/dev/reference/html_form.md)
  to submit

- submit:

  Which button should be used to submit the form?

  - `NULL`, the default, uses the first button.

  - A string selects a button by its name.

  - A number selects a button using its relative position.

## Examples

``` r
s <- session("http://hadley.nz")
s |>
  session_jump_to("hadley.jpg") |>
  session_jump_to("/") |>
  session_history()
#>   https://hadley.nz/
#>   https://hadley.nz/hadley.jpg
#> - https://hadley.nz/

s |>
  session_jump_to("hadley.jpg") |>
  session_back() |>
  session_history()
#> - https://hadley.nz/
#>   https://hadley.nz/hadley.jpg

# \donttest{
s |>
  session_follow_link(css = "p a") |>
  html_elements("p")
#> Navigating to <https://posit.co>.
#> {xml_nodeset (14)}
#>  [1] <p class="mb-4 eyebrow dark:!text-white">Trusted by about 1 in  ...
#>  [2] <p>The enterprise platform for the AI era, giving data teams sp ...
#>  [3] <p>Generative AI makes it easy to produce a plausible-looking a ...
#>  [4] <p>Move from question to insight to analysis, model or applicat ...
#>  [5] <p>Introducing an entirely new way to work with data. Posit AI  ...
#>  [6] <p class="eyebrow mb-6">\n            <span>Results</span>\n\n  ...
#>  [7] <p>From faster insights to reduced risk, Posit customers achiev ...
#>  [8] <p dir="ltr"><span>Faster "what-if" analysis delivery at NASA</ ...
#>  [9] <p><span>Reduction in recordable incident rate at Suffolk Const ...
#> [10] <p>Savings on cloud infrastructure costs at TruDiagnostic<br> </p>
#> [11] <p class="eyebrow text-center mb-4 text-blue-300 dark:text-whit ...
#> [12] <p class="eyebrow !text-white mb-18">\n\t\t\t\t\t<span>Our miss ...
#> [13] <p>As a Public Benefit Corporation, we're committed to open sou ...
#> [14] <p class="address" translate="no"><span class="address-line1">2 ...
# }
```
