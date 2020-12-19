
#' Pipe operator
#'
#' See [magrittr::%>%] for more details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

pluck <- function(x, i, type) {
  if (missing(type)) {
    lapply(x, .subset2, i)
  } else {
    vapply(x, .subset2, i, FUN.VALUE = type)
  }
}

map_chr <- function(.x, .f, ...) {
  vapply(.x, .f, ..., FUN.VALUE = character(1))
}
map_lgl <- function(.x, .f, ...) {
  vapply(.x, .f, ..., FUN.VALUE = logical(1))
}

map_int <- function(.x, .f, ...) {
  vapply(.x, .f, ..., FUN.VALUE = integer(1))
}

str_trunc <- function(x, width) {
  if (nchar(x) <= width) {
    x
  } else {
    paste0(substr(x, 1, width - 3), "...")
  }
}

#' Make link to google form given id
#'
#' @param x Unique identifier for form
#' @export
#' @keywords internal
#' @examples
#' google_form("1M9B8DsYNFyDjpwSK6ur_bZf8Rv_04ma3rmaaBiveoUI")
google_form <- function(x) {
  xml2::read_html(httr::GET(paste0("https://docs.google.com/forms/d/", x, "/viewform")))
}

cat_line <- function(...) {
  cat(paste0(..., "\n", collapse = ""))
}
