#' Deprecated XML functions
#'
#' `r lifecycle::badge('deprecated')`
#'
#' @keywords internal
#' @name xml
NULL

#' @export
#' @rdname xml
xml_tag <- function(x) {
  lifecycle::deprecate_warn("1.0.0", "xml_tag()", "html_name()")
  html_name(x)
}

#' @export
#' @rdname xml
xml_node <- function(...) {
  lifecycle::deprecate_warn("1.0.0", "xml_node()", "html_node()")
  html_node(...)
}

#' @export
#' @rdname xml
xml_nodes <- function(...) {
  lifecycle::deprecate_warn("1.0.0", "xml_nodes()", "html_nodes()")
  html_nodes(...)
}
