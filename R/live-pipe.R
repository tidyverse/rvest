#' Pipeable wrappers for LiveHTML methods
#'
#' @description
#' These functions are pipeable wrappers around the methods of the [LiveHTML]
#' R6 class. They allow you to write scraping code in a more "functional"
#' style, similar to the tidyverse. Each function takes a `LiveHTML` object
#' as its first argument and returns the object invisibly, allowing for
#' chaining with `|>`.
#'
#' @param live_html A `LiveHTML` object, as created by [read_html_live()].
#' @name live-wrappers
#' @family live
NULL

#' @rdname live-wrappers
#' @export
live_view <- function(live_html) { # nocov start
  live_html$view()
  invisible(live_html)
} # nocov end

#' @rdname live-wrappers
#' @param css CSS selector.
#' @param n_clicks Number of clicks.
#' @param wait_for What to wait for after the click.
#' @export
live_click <- function(live_html, css, n_clicks = 1, wait_for = NULL) {
  live_html$click(css = css, n_clicks = n_clicks, wait_for = wait_for)
  invisible(live_html)
}

#' @rdname live-wrappers
#' @export
live_get_scroll_position <- function(live_html) {
  # This function returns a value, so it breaks the chain.
  live_html$get_scroll_position()
}

#' @rdname live-wrappers
#' @export
live_scroll_into_view <- function(live_html, css, wait_for = NULL) {
  live_html$scroll_into_view(css = css, wait_for = wait_for)
  invisible(live_html)
}

#' @rdname live-wrappers
#' @param top,left Number of pixels from top/left respectively.
#' @export
live_scroll_to <- function(live_html, top = 0, left = 0, wait_for = NULL) {
  live_html$scroll_to(top = top, left = left, wait_for = wait_for)
  invisible(live_html)
}

#' @rdname live-wrappers
#' @export
live_scroll_by <- function(live_html, top = 0, left = 0, wait_for = NULL) {
  live_html$scroll_by(top = top, left = left, wait_for = wait_for)
  invisible(live_html)
}

#' @rdname live-wrappers
#' @param text A single string containing the text to type.
#' @export
live_type <- function(live_html, css, text, wait_for = NULL) {
  live_html$type(css = css, text = text, wait_for = wait_for)
  invisible(live_html)
}

#' @rdname live-wrappers
#' @param key_code Name of key.
#' @param modifiers A character vector of modifiers.
#' @export
live_press <- function(live_html, css, key_code, modifiers = character(), wait_for = NULL) {
  live_html$press(css = css, key_code = key_code, modifiers = modifiers, wait_for = wait_for)
  invisible(live_html)
}

#' @rdname live-wrappers
#' @param promise A promise object to wait for.
#' @export
live_wait_for <- function(live_html, promise = NULL) {
  live_html$wait_for(promise = promise)
  invisible(live_html)
}
