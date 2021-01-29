#' Functions renamed in rvest 1.0.0
#'
#' @description
#' `r lifecycle::badge('deprecated')`
#'
#' rvest 1.0.0 renamed a number of functions to ensure that every function
#' has a common prefix, matching tidyverse conventions that emerged since
#' rvest was first created.
#'
#' * `set_values()` -> `html_form_set()`
#' * `submit_form()` -> `session_submit()`
#' * `xml_tag()` -> `html_name()`
#' * `xml_node()` & `html_node()` -> `html_element()`
#' * `xml_nodes()` & `html_nodes()` -> `html_elements()`
#'
#' (`html_node()` and `html_nodes()` are only superseded because they're
#' so widely used.)
#'
#' Additionally all session related functions gained a common prefix:
#'
#' * `html_session()` -> `session()`
#' * `forward()` -> `session_forward()`
#' * `back()` -> `session_back()`
#' * `jump_to()` -> `session_jump_to()`
#' * `follow_link()` -> `session_follow_link()`
#'
#' @keywords internal
#' @name rename
#' @aliases NULL
NULL

#' @rdname rename
#' @export
set_values <- function(form, ...) {
  lifecycle::deprecate_warn("1.0.0", "set_values()", "html_form_set()")
  html_form_set(form = form, ...)
}

#' @rdname rename
#' @export
submit_form <- function(session, form, submit = NULL, ...) {
  lifecycle::deprecate_warn("1.0.0", "submit_form()", "session_submit()")
  session_submit(x = session, form = form, submit = submit, ...)
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
  lifecycle::deprecate_warn("1.0.0", "xml_node()", "html_element()")
  html_node(...)
}

#' @export
#' @rdname rename
xml_nodes <- function(...) {
  lifecycle::deprecate_warn("1.0.0", "xml_nodes()", "html_elements()")
  html_nodes(...)
}

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

#' @export
#' @rdname rename
back <- function(x) {
  lifecycle::deprecate_warn("1.0.0", "back()", "session_back()")
  session_back(x)
}

#' @export
#' @rdname rename
forward <- function(x) {
  lifecycle::deprecate_warn("1.0.0", "forward()", "session_forward()")
  session_forward(x)
}

#' @export
#' @rdname rename
jump_to <- function(x, url, ...) {
  lifecycle::deprecate_warn("1.0.0", "jump_to()", "session_jump_to()")
  session_jump_to(x, url, ...)
}

#' @export
#' @rdname rename
follow_link <- function(x, ...) {
  lifecycle::deprecate_warn("1.0.0", "follow_link()", "session_follow_link()")
  session_follow_link(x, ...)
}

#' @export
#' @rdname rename
html_session <- function(url, ...) {
  lifecycle::deprecate_warn("1.0.0", "html_session()", "session()")
  session(url, ...)
}
