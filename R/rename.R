#' Functions renamed in rvest 1.0.0
#'
#' @description
#' `r lifecycle::badge('superseded')`
#'
#' rvest 1.0.0 renamed a number of functions to ensure that every function
#' has a common prefix, matching tidyverse conventions that emerged since
#' rvest was first created. Most of the renamed functions have now been
#' removed, but `html_node()` and `html_nodes()` are still superseded
#' (rather than removed) because they're so widely used:
#'
#' * `html_node()` -> `html_element()`
#' * `html_nodes()` -> `html_elements()`
#'
#' @keywords internal
#' @name rename
#' @aliases NULL
NULL

#' @export
#' @rdname rename
html_nodes <- function(...) {
  html_elements(...)
}

#' @export
#' @rdname rename
html_node <- function(...) {
  html_element(...)
}
