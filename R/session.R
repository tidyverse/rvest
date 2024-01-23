#' Simulate a session in web browser
#'
#' @description
#' This set of functions allows you to simulate a user interacting with a
#' website, using forms and navigating from page to page.
#'
#' * Create a session with `session(url)`
#' * Navigate to a specified url with `session_jump_to()`, or follow a link on the
#'   page with `session_follow_link()`.
#' * Submit an [html_form] with `session_submit()`.
#' * View the history with `session_history()` and navigate back and forward
#'   with `session_back()` and `session_forward()`.
#' * Extract page contents with [html_element()] and [html_elements()], or get the
#'   complete HTML document with [read_html()].
#' * Inspect the HTTP response with [httr::cookies()], [httr::headers()],
#'   and [httr::status_code()].
#'
#' @param url For `session()` location to start, for `session_jump_to()`
#'   location to go to next.
#' @param ... Any additional httr config to use throughout the session.
#' @param x An object to test to see if it's a session.
#' @export
#' @examples
#' s <- session("http://hadley.nz")
#' s %>%
#'   session_jump_to("hadley-wickham.jpg") %>%
#'   session_jump_to("/") %>%
#'   session_history()
#'
#' s %>%
#'   session_jump_to("hadley-wickham.jpg") %>%
#'   session_back() %>%
#'   session_history()
#'
#' \donttest{
#' s %>%
#'   session_follow_link(css = "p a") %>%
#'   html_elements("p")
#' }
session <- function(url, ...) {
  session <-   structure(
    list(
      handle   = httr::handle(url),
      config   = c(..., httr::config(autoreferer = 1L)),
      response = NULL,
      url      = NULL,
      back     = character(),
      forward  = character(),
      cache    = new_environment()
    ),
    class = "rvest_session"
  )
  session_get(session, url)
}

#' @export
#' @rdname session
is.session <- function(x) inherits(x, "rvest_session")

#' @export
print.rvest_session <- function(x, ...) {
  cat("<session> ", x$url, "\n", sep = "")
  cat("  Status: ", httr::status_code(x), "\n", sep = "")
  cat("  Type:   ", httr::headers(x)$`Content-Type`, "\n", sep = "")
  cat("  Size:   ", length(x$response$content), "\n", sep = "")
  invisible(x)
}

session_get <- function(x, url, ...) {
  resp <- httr::GET(url, x$config, ..., handle = x$handle)
  session_set_response(x, resp)
}

session_set_response <- function(x, response) {
  httr::warn_for_status(response)

  x$response <- response
  x$url <- response$url
  x$cache <- new_environment()
  x
}

#' @param x A session.
#' @param url A URL, either relative or absolute, to navigate to.
#' @export
#' @rdname session
session_jump_to <- function(x, url, ...) {
  check_session(x)
  url <- xml2::url_absolute(url, x$url)
  last_url <- x$url

  x <- session_get(x, url, ...)
  x$back <- c(last_url, x$back)
  x$forward <- character()
  x
}

#' @param i A integer to select the ith link or a string to match the
#'  first link containing that text (case sensitive).
#' @inheritParams html_element
#' @export
#' @rdname session
session_follow_link <- function(x, i, css, xpath, ...) {
  check_session(x)

  url <- find_href(x, i = i, css = css, xpath = xpath)
  inform(paste0("Navigating to ", url))
  session_jump_to(x, url, ...)
}

find_href <- function(x, i, css, xpath, error_call = caller_env()) {
  check_exclusive(i, css, xpath, .call = error_call)

  if (!missing(i)) {
    stopifnot(length(i) == 1)
    a <- html_elements(x, "a")

    if (is.numeric(i)) {
      out <- a[[i]]
    } else if (is.character(i)) {
      text <- html_text(a)
      match <- grepl(i, text, fixed = TRUE)
      if (!any(match)) {
        cli::cli_abort("No links have text {.str {i}}.", call = error_call)
      }

      out <- a[[which(match)[[1]]]]
    } else {
      cli::cli_abort("`i` must a string or integer", call = error_call)
    }
  } else {
    a <- html_elements(x, css = css, xpath = xpath)
    if (length(a) == 0) {
      cli::cli_abort("No links matched `css`/`xpath`", call = error_call)
    }
    out <- a[[1]]
  }

  html_attr(out, "href")
}

#' @export
#' @rdname session
session_back <- function(x) {
  check_session(x)

  if (length(x$back) == 0) {
    cli::cli_abort("Can't go back any further.")
  }

  url <- x$back[[1]]
  x$back <- x$back[-1]
  old_url <- x$url

  x <- session_get(x, url)
  x$forward <- c(old_url, x$forward)
  x
}

#' @export
#' @rdname session
session_forward <- function(x) {
  check_session(x)

  if (length(x$forward) == 0) {
    cli::cli_abort("Can't go forward any further.")
  }

  url <- x$forward[[1]]
  old_url <- x$url

  x <- session_get(x, url)
  x$forward <- x$forward[-1]
  x$back <- c(old_url, x$back)
  x
}

#' @export
#' @rdname session
session_history <- function(x) {
  check_session(x)

  urls <- c(rev(x$back), x$url, x$forward)
  prefix <- rep(c("  ", "- ", "  "), c(length(x$back), 1, length(x$forward)))
  cat_line(prefix, urls)
}

# form --------------------------------------------------------------------

#' @param form An [html_form] to submit
#' @inheritParams html_form_submit
#' @rdname session
#' @export
session_submit <- function(x, form, submit = NULL, ...) {
  check_session(x)
  check_form(form)

  subm <- submission_build(form, submit)
  resp <- submission_submit(subm, x$config, ..., handle = x$handle)
  session_set_response(x, resp)
}

# xml2 methods ------------------------------------------------------------

#' @importFrom xml2 read_html
#' @export
read_html.rvest_session <- function(x, ...) {
  if (!is_html(x$response)) {
    cli::cli_abort("Page doesn't appear to be html.")
  }

  env_cache(x$cache, "html", read_html(x$response, ..., base_url = x$url))
}

is_html <- function(x) {
  type <- httr::headers(x)$`Content-Type`
  if (is.null(type)) return(FALSE)

  parsed <- httr::parse_media(type)
  parsed$complete %in% c("text/html", "application/xhtml+xml")
}

# rvest methods -----------------------------------------------------------------

#' @export
html_form.rvest_session <- function(x, base_url = NULL) {
  html_form(read_html(x), base_url = base_url)
}

#' @export
html_table.rvest_session <- function(x,
                               header = NA,
                               trim = TRUE,
                               fill = deprecated(),
                               dec = ".",
                               na.strings = "NA",
                               convert = TRUE) {
  html_table(
    read_html(x),
    header = header,
    trim = trim,
    fill = fill,
    dec = dec,
    na.strings = na.strings,
    convert = convert
  )
}

#' @export
html_element.rvest_session <- function(x, css, xpath) {
  html_element(read_html(x), css, xpath)
}

#' @export
html_elements.rvest_session <- function(x, css, xpath) {
  html_elements(read_html(x), css, xpath)
}

# httr methods -----------------------------------------------------------------

#' @importFrom httr status_code
#' @export
status_code.rvest_session <- function(x) {
  status_code(x$response)
}

#' @importFrom httr headers
#' @export
headers.rvest_session <- function(x) {
  headers(x$response)
}

#' @importFrom httr cookies
#' @export
cookies.rvest_session <- function(x) {
  cookies(x$response)
}

# helpers -----------------------------------------------------------------

check_form <- function(x, call = caller_env()) {
  if (!inherits(x, "rvest_form")) {
    cli::cli_abort(
      "{.arg form} must be a single form produced by {.fn html_form}.",
      call = call
    )
  }
}
check_session <- function(x, call = caller_env()) {
  if (!inherits(x, "rvest_session")) {
    cli::cli_abort("{.arg x} must be produced by {.fn session}.", call = call)
  }
}
