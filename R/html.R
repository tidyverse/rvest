#' Extract attributes, text, or tag name
#'
#' `html_text()` extracts text inside a node, `html_attr()` extract a
#' single attribute, `html_attr()` extract all attributes, and `html_tag()`
#' gives the tag name.
#'
#' @inheritParams xml2::xml_text
#' @return A character vector (for `html_attr()`, `html_tag()`, and
#'   `html_text()`) or list (`html_attrs()`) the same length as `x`
#' @export
#' @examples
#' url <- "https://en.wikipedia.org/wiki/The_Lego_Movie"
#' movie <- read_html(url)
#' cast <- html_nodes(movie, "tr:nth-child(8) .plainlist a")
#'
#' html_text(cast)
#' html_name(cast)
#' html_attrs(cast)
#' html_attr(cast, "href")
#'
#' # If needed, use url_absolute() to convert to complete urls
#' url_absolute(html_attr(cast, "href"), url)
html_text <- function(x, trim = FALSE) {
  xml2::xml_text(x, trim = trim)
}

#' @rdname html_text
#' @export
html_name <- function(x) {
  xml2::xml_name(x)
}

#' @rdname html_text
#' @export
html_attrs <- function(x) {
  xml2::xml_attrs(x)
}

#' @rdname html_text
#' @param name Name of attribute to retrieve.
#' @param default A string used as a default value when the attribute does
#'   not exist in every node.
#' @export
html_attr <- function(x, name, default = NA_character_) {
  xml2::xml_attr(x, name, default = default)
}


#' Find all child elements
#'
#' @export
#' @examples
#' html <- minimal_html("A list", "<ul><li>1<li>2<li>3</ul>")
#' ul <- html_nodes(html, "ul")
#' html_children(ul)
#'
#' html <- minimal_html("A paragraph", "<p>Hello <b>Hadley</b><i>!</i>")
#' p <- html_nodes(html, "p")
#' html_children(p)
html_children <- function(x) {
  xml2::xml_children(x)
}
