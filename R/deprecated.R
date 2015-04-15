#' html_tag
#'
#' Deprecated: please use \code{html_name} instead.
#'
#' @export
#' @keywords internal
html_tag <- function(x) {
  .Deprecated("html_name")
  xml2::xml_name(x)
}

