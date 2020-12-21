#' Functions renamed in rvest 1.0.0
#'
#' `r lifecycle::badge('deprecated')`
#' * `xml_tag()` -> `html_name()`
#' * `xml_node()` -> `html_node()`
#' * `xml_nodes()` -> `html_nodes()`
#'
#' @keywords internal
#' @name rename
NULL

#' @export
#' @rdname rename
xml_tag <- function(x) {
  lifecycle::deprecate_warn("1.0.0", "xml_tag()", "html_name()")
  html_name(x)
}

#' @export
#' @rdname rename
xml_node <- function(...) {
  lifecycle::deprecate_warn("1.0.0", "xml_node()", "html_node()")
  html_node(...)
}

#' @export
#' @rdname rename
xml_nodes <- function(...) {
  lifecycle::deprecate_warn("1.0.0", "xml_nodes()", "html_nodes()")
  html_nodes(...)
}
