#' Get element name
#'
#' @param x A document (from [read_html()]), node set (from [html_elements()]),
#'   node (from [html_element()]), or session (from [session()]).
#' @return A character vector the same length as `x`
#' @export
#' @examples
#' url <- "https://rvest.tidyverse.org/articles/starwars.html"
#' html <- read_html(url)
#'
#' html %>%
#'   html_element("div") %>%
#'   html_children() %>%
#'   html_name()
#' @export
#' @importFrom xml2 xml_name
html_name <- function(x) {
  xml_name(x)
}

#' Get element attributes
#'
#' `html_attr()` gets a single attribute; `html_attr()` gets all attributes.
#'
#' @inheritParams html_name
#' @param name Name of attribute to retrieve.
#' @param default A string used as a default value when the attribute does
#'   not exist in every element.
#' @return A character vector (for `html_attr()`) or list (`html_attrs()`)
#'   the same length as `x`.
#' @examples
#' url <- "https://en.wikipedia.org/w/index.php?title=The_Lego_Movie&oldid=998422565"
#' html <- read_html(url)
#'
#' cast <- html_elements(html, "tr:nth-child(8) .plainlist a")
#' cast %>% html_text2()
#' cast %>% html_attrs()
#' cast %>% html_attr("href")
#'
#' # If needed, use url_absolute() to convert to complete urls
#' url_absolute(html_attr(cast, "href"), url)
#' @export
#' @importFrom xml2 xml_attr
html_attr <- function(x, name, default = NA_character_) {
  xml_attr(x, name, default = default)
}

#' @rdname html_attr
#' @export
#' @importFrom xml2 xml_attrs
html_attrs <- function(x) {
  xml_attrs(x)
}

#' Get element children
#'
#' @inheritParams html_name
#' @examples
#' html <- minimal_html("<ul><li>1<li>2<li>3</ul>")
#' ul <- html_elements(html, "ul")
#' html_children(ul)
#'
#' html <- minimal_html("<p>Hello <b>Hadley</b><i>!</i>")
#' p <- html_elements(html, "p")
#' html_children(p)
#' @importFrom xml2 xml_children
#' @export
html_children <- function(x) {
  xml_children(x)
}
