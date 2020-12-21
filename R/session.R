#' Simulate a session in web browser
#'
#' @description
#' This set of functions allows you to simulate a user interacting with a
#' website, using forms and navigating from page to page.
#'
#' * Create a session with `html_session(url)`
#' * Navigate to a specified url with `jump_to()`, or follow a link on the
#'   page with `follow_link()`.
#' * Submit a form with [form_submit()].
#' * View the history with `session_history()` and return to the previous page
#'   with `back()`
#' * Extract page contents with [html_node()] and [html_nodes()], or get the
#'   complete HTML document with [read_html()].
#' * Inspect the HTTP response with [httr::cookies()], [httr::headers()],
#'   and [httr::status_code()].
#'
#' @param url For `html_session()` location to start, for `jump_to()` location
#'   to go to next.
#' @param ... Any additional httr config to use throughout the session.
#' @param x An object to test to see if it's a session.
#' @export
#' @examples
#' s <- html_session("http://hadley.nz")
#' s %>%
#'   jump_to("hadley-wickham.jpg") %>%
#'   jump_to("/") %>%
#'   session_history()
#'
#' s %>%
#'   jump_to("hadley-wickham.jpg") %>%
#'   back() %>%
#'   session_history()
#'
#' \donttest{
#' s %>%
#'   follow_link(css = "p a") %>%
#'   html_nodes("p")
#' }
html_session <- function(url, ...) {
  session <-   structure(
    list(
      handle   = httr::handle(url),
      config   = c(..., httr::config(autoreferer = 1L)),
      response = NULL,
      url      = NULL,
      back     = NULL,
      forward  = NULL,
      cache    = new_environment()
    ),
    class = "rvest_session"
  )
  session_request(session, "GET", url)
}

#' @export
#' @rdname html_session
is.session <- function(x) inherits(x, "rvest_session")

#' @export
print.rvest_session <- function(x, ...) {
  cat("<session> ", x$url, "\n", sep = "")
  cat("  Status: ", httr::status_code(x), "\n", sep = "")
  cat("  Type:   ", httr::headers(x)$`Content-Type`, "\n", sep = "")
  cat("  Size:   ", length(x$response$content), "\n", sep = "")
}

session_request <- function(x, method, url, ...) {
  if (method == "GET") {
    x$response <- httr::GET(url, x$config, ..., handle = x$handle)
  } else {
    x$response <- httr::POST(url, x$config, ..., handle = x$handle)
  }
  httr::warn_for_status(x$response)

  x$back <- c(x$url, x$back)
  x$forward <- character()
  x$url <- x$response$url

  x$cache <- new_environment()

  x
}

#' @param x A session.
#' @param url A URL, either relative or absolute, to navigate to.
#' @export
#' @rdname html_session
jump_to <- function(x, url, ...) {
  stopifnot(is.session(x))
  url <- xml2::url_absolute(url, x$url)
  session_request(x, "GET", url, ...)
}

#' @param i A integer to select the ith link or a string to match the
#'  first link containing that text (case sensitive).
#' @inheritParams html_node
#' @export
#' @rdname html_session
follow_link <- function(x, i, css, xpath, ...) {
  stopifnot(is.session(x))

  url <- find_href(x, i = i, css = css, xpath = xpath)
  inform(paste0("Navigating to ", url))
  jump_to(x, url, ...)
}

find_href <- function(x, i, css, xpath) {
  if (sum(!missing(i), !missing(css), !missing(xpath)) != 1) {
    abort("Must supply exactly one of `i`, `css`, or `xpath`")
  }

  if (!missing(i)) {
    stopifnot(length(i) == 1)
    a <- html_nodes(x, "a")

    if (is.numeric(i)) {
      out <- a[[i]]
    } else if (is.character(i)) {
      text <- html_text(a)
      match <- grepl(i, text, fixed = TRUE)
      if (!any(match)) {
        stop("No links have text '", i, "'", call. = FALSE)
      }

      out <- a[[which(match)[[1]]]]
    } else {
      abort("`i` must a string or integer")
    }
  } else {
    a <- html_nodes(x, css = css, xpath = xpath)
    if (length(a) == 0) {
      abort("No links matched `css`/`xpath`")
    }
    out <- a[[1]]
  }

  html_attr(out, "href")
}

#' @export
#' @rdname html_session
back <- function(x) {
  stopifnot(is.session(x))

  if (length(x$back) == 0) {
    abort()
    stop("Can't go back any further", call. = FALSE)
  }

  url <- x$back[[1]]
  x$back <- x$back[-1]
  x$forward <- c(x$url, x$forward)

  session_request(x, "GET", url)
}

#' @export
#' @rdname html_session
session_history <- function(x) {
  urls <- c(rev(x$back), x$url, x$forward)
  prefix <- rep(c("  ", "- ", "  "), c(length(x$back), 1, length(x$forward)))
  cat_line(prefix, urls)
}

# xml2 methods ------------------------------------------------------------

#' @importFrom xml2 read_html
#' @export
read_html.rvest_session <- function(x, ...) {
  if (!is_html(x)) {
    abort("Page doesn't appear to be html.")
  }
  env_cache(x$cache, "html", read_html(x$response, ...))
}

is_html <- function(x) {
  stopifnot(is.session(x))

  type <- httr::headers(x)$`Content-Type`
  if (is.null(type)) return(FALSE)

  parsed <- httr::parse_media(type)
  parsed$complete %in% c("text/html", "application/xhtml+xml")
}

# rvest methods -----------------------------------------------------------------

#' @export
html_form.rvest_session <- function(x) {
  html_form(read_html(x))
}

#' @export
html_table.rvest_session <- function(x,
                               header = NA,
                               trim = TRUE,
                               fill = deprecated(),
                               dec = ".") {
  html_table(read_html(x), header = header, trim = trim, fill = fill, dec = dec)
}

#' @export
html_node.rvest_session <- function(x, css, xpath) {
  html_node(read_html(x), css, xpath)
}

#' @export
html_nodes.rvest_session <- function(x, css, xpath) {
  html_nodes(read_html(x), css, xpath)
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
