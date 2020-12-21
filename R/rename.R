#' Functions renamed in rvest 1.0.0
#'
#' @description
#' `r lifecycle::badge('deprecated')`
#'
#' rvest 1.0.0 renamed a number of functions to ensure that every function
#' has a common prefix, matching tidyverse conventions that emerged since
#' rvest was first created.
#'
#' * `set_values()` -> `form_set()`
#' * `submit_form(session, form)` -> `form_submit(form, session)`
#' * `xml_tag()` -> `html_name()`
#' * `xml_node()` -> `html_node()`
#' * `xml_nodes()` -> `html_nodes()`
#'
#' @keywords internal
#' @name rename
#' @aliases NULL
NULL

#' @rdname rename
#' @export
set_values <- function(form, ...) {
  lifecycle::deprecate_warn("1.0.0", "set_values()", "form_set()")
  form_set(form = form, ...)
}

#' @rdname rename
#' @export
submit_form <- function(session, form, submit = NULL, ...) {
  lifecycle::deprecate_warn("1.0.0", "submit_form()", "form_submit()")
  form_submit(form = form, session = session, submit = submit, ...)
}

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
