#' Work with xml.
#'
#' All methods work the same as their HTML equivalents. Currently \code{xml}
#' parses XML files as HTML because I can't find another way to ignore
#' namespaces.
#'
#' @export
#' @inheritParams html
#' @inheritParams html_tag
#' @inheritParams html_node
#' @examples
#' search <- xml("http://stackoverflow.com/feeds")
#'
#' entries <- search %>% xml_nodes("entry")
#' entries[[1]] %>% xml_structure()
#'
#' entries %>% xml_node("author name") %>% xml_text()
#' entries %>% lapply(. %>% xml_nodes("category") %>% xml_attr("term"))
xml <- function(x, ..., encoding = NULL) {
  # xmlParse <- function(x, ...) XML::xmlInternalTreeParse(x, getDTD = FALSE, ...)
  out <- parse(x, XML::htmlParse, ..., encoding = encoding)
  out
}

#' @export
#' @rdname xml
xml_tag <- html_tag
#' @export
#' @rdname xml
xml_attr <- html_attr
#' @export
#' @rdname xml
xml_attrs <- html_attrs
#' @export
#' @rdname xml
xml_node <- html_node
#' @export
#' @rdname xml
xml_nodes <- html_nodes
#' @export
#' @rdname xml
xml_text <- html_text
#' @export
#' @rdname xml
xml_children <- html_children
