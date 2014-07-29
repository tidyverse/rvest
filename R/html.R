#' Parse an HTML page.
#'
#' @param x A url, a string containing html, or a a httr response.
#' @export
parse_html <- function(x) UseMethod("parse_html")

#' @export
parse_html.character <- function(x) {
  if (grepl(x, "<|>")) {
    XML::htmlParse(x)
  } else {
    r <- httr::GET(x)
    parse_html(r)
  }
}

#' @export
parse_html.response <- function(x) {
  httr::stop_for_status(x)
  httr::content(x, "parsed")
}

#' @export
parse_html.XMLAbstractDocument <- function(x, ...) {
  x
}

#' Extract text from html nodes
#'
#' @param x The object to extract text from
#' @param ... Other arguments passed onto \code{\link[XML]{xmlValue}()}.
#'   The most useful argument is \code{trim = TRUE} which will remove leading
#'   and trailing whitespace.
#' @return A character vector
#' @export
html_text <- function(x, ...) UseMethod("html_text")
#' @export
html_text.HTMLInternalDocument <- function(x, ...) {
  XML::xmlValue(x, ...)
}
#' @export
html_text.XMLInternalElementNode <- function(x, ...) {
  XML::xmlValue(x, ...)
}
#' @export
html_text.XMLNodeSet <- function(x, ...) {
  vapply(x, XML::xmlValue, ..., FUN.VALUE = character(1))
}
