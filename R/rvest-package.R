#' @keywords internal
#' @import rlang
#' @importFrom lifecycle deprecated
"_PACKAGE"


#' Static web scraping (with xml2)
#'
#' @description
#' [read_html()] works by performing a HTTP request then parsing the HTML
#' received using the xml2 package. This is "static" scraping because it
#' operates only on the raw HTML file. While this works for most sites,
#' in some cases you will need to use [read_html_live()] if the parts of
#' the page you want to scrape are dynamically generated with javascript.
#'
#' Generally, we recommend using `read_html()` if it works, as it will be
#' faster and more robust, as it has fewer external dependencies (i.e. it
#' doesn't rely on the Chrome web browser installed on your computer.)
#'
#' @inheritParams xml2::read_html
#' @param x Usually a string representing a URL. See [xml2::read_html()] for
#'   other options.
#' @rdname read_html
#' @importFrom xml2 read_html
#' @export
#' @examples
#' # Start by reading a HTML page with read_html():
#' starwars <- read_html("https://rvest.tidyverse.org/articles/starwars.html")
#'
#' # Then find elements that match a css selector or XPath expression
#' # using html_elements(). In this example, each <section> corresponds
#' # to a different film
#' films <- starwars |> html_elements("section")
#' films
#'
#' # Then use html_element() to extract one element per film. Here
#' # we the title is given by the text inside <h2>
#' title <- films |>
#'   html_element("h2") |>
#'   html_text2()
#' title
#'
#' # Or use html_attr() to get data out of attributes. html_attr() always
#' # returns a string so we convert it to an integer using a readr function
#' episode <- films |>
#'   html_element("h2") |>
#'   html_attr("data-id") |>
#'   readr::parse_integer()
#' episode
xml2::read_html

#' @importFrom xml2 url_absolute
#' @export
xml2::url_absolute

#' @export
#' @importFrom magrittr %>%
magrittr::`%>%`

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
#' @importFrom glue glue
## usethis namespace: end
NULL

the <- new_environment()
