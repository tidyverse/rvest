#' @importFrom xml2 read_xml
#' @export
read_xml.session <- function(x, ..., as_html = FALSE) {
  if (exists("cached", envir = x$html)) {
    return(x$html$cached)
  }

  if (!is_html(x)) {
    stop("Current page doesn't appear to be html.", call. = FALSE)
  }

  read_xml(x$response, ..., as_html = as_html)
}
