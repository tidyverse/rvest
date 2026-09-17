# Live web scraping (with chromote)

**\[experimental\]**

[`read_html()`](https://rvest.tidyverse.org/dev/reference/read_html.md)
operates on the HTML source code downloaded from the server. This works
for most websites but can fail if the site uses javascript to generate
the HTML. `read_html_live()` provides an alternative interface that runs
a live web browser (Chrome) in the background. This allows you to access
elements of the HTML page that are generated dynamically by javascript
and to interact with the live page by clicking on buttons or typing in
forms.

Behind the scenes, this function uses the
[chromote](https://rstudio.github.io/chromote/) package, which requires
that you have a copy of [Google Chrome](https://www.google.com/chrome/)
installed on your machine.

## Usage

``` r
read_html_live(url)
```

## Arguments

- url:

  Website url to read from.

## Value

`read_html_live()` returns an R6
[LiveHTML](https://rvest.tidyverse.org/dev/reference/LiveHTML.md)
object. You can interact with this object using the usual rvest
functions, or call its methods, like `$click()`, `$scroll_to()`, and
`$type()` to interact with the live page like a human would.

## Examples

``` r
if (FALSE) { # \dontrun{
# When we retrieve the raw HTML for this site, it doesn't contain the
# data we're interested in:
static <- read_html("https://www.forbes.com/top-colleges/")
static |> html_element("table")

# Instead, we need to run the site in a real web browser, causing it to
# download a JSON file and then dynamically generate the html:
dynamic <- read_html_live("https://www.forbes.com/top-colleges/")
# You may need to click the cookie consent banner if it appears
dynamic$view()

# Now we can find the table
dynamic |> html_element("table")

# And extract data from it
dynamic |> 
  html_element("table") |> 
  html_table()
} # }
```
