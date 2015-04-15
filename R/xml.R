#' Work with xml.
#'
#' Deprecated. Please use just xm2 directly
#'
#' @export
#' @keywords internal
#' @inheritParams html
#' @inheritParams html_tag
#' @inheritParams html_node
xml <- function(x, ..., encoding = "") {
  .Deprecated("read_xml")
  xml2::read_xml(x, ..., encoding = encoding)
}

#' @export
#' @rdname xml
xml_tag <- html_tag
#' @export
#' @rdname xml
xml_node <- html_node
#' @export
#' @rdname xml
xml_nodes <- html_nodes
