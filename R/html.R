#' Get name and attributes from nodes
#'
#' `html_name()` gets the tag name, `html_attr()` gets a single attribute,
#' and `html_attr()` gets all attributes.
#'
#' @param x A document, node, or node set.
#' @return A character vector (for `html_attr()` and `html_tag()`) or
#'   a list (`html_attrs()`) the same length as `x`
#' @export
#' @examples
#' url <- "https://en.wikipedia.org/wiki/The_Lego_Movie"
#' movie <- read_html(url)
#' cast <- html_nodes(movie, "tr:nth-child(8) .plainlist a")
#'
#' html_name(cast)
#' html_attrs(cast)
#' html_attr(cast, "href")
#'
#' # If needed, use url_absolute() to convert to complete urls
#' url_absolute(html_attr(cast, "href"), url)
#' @export
#' @importFrom xml2 xml_name
html_name <- function(x) {
  xml_name(x)
}

#' @rdname html_name
#' @param name Name of attribute to retrieve.
#' @param default A string used as a default value when the attribute does
#'   not exist in every node.
#' @export
#' @importFrom xml2 xml_attr
html_attr <- function(x, name, default = NA_character_) {
  xml_attr(x, name, default = default)
}

#' @rdname html_name
#' @export
#' @importFrom xml2 xml_attrs
html_attrs <- function(x) {
  xml_attrs(x)
}

#' Find all child elements
#'
#' @export
#' @inheritParams xml2::xml_text
#' @examples
#' html <- minimal_html("<ul><li>1<li>2<li>3</ul>")
#' ul <- html_nodes(html, "ul")
#' html_children(ul)
#'
#' html <- minimal_html("<p>Hello <b>Hadley</b><i>!</i>")
#' p <- html_nodes(html, "p")
#' html_children(p)
#' @importFrom xml2 xml_children
html_children <- function(x) {
  xml_children(x)
}
