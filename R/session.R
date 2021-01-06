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
  session_request(session, "GET", url)
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

session_request <- function(x, method, url, ...) {
  if (method == "GET") {
    x$response <- httr::GET(url, x$config, ..., handle = x$handle)
  } else {
    x$response <- httr::POST(url, x$config, ..., handle = x$handle)
  }
  httr::warn_for_status(x$response)
  x$url <- x$response$url

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

  x <- session_request(x, "GET", url, ...)
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

find_href <- function(x, i, css, xpath) {
  if (sum(!missing(i), !missing(css), !missing(xpath)) != 1) {
    abort("Must supply exactly one of `i`, `css`, or `xpath`")
  }

  if (!missing(i)) {
    stopifnot(length(i) == 1)
    a <- html_elements(x, "a")

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
    a <- html_elements(x, css = css, xpath = xpath)
    if (length(a) == 0) {
      abort("No links matched `css`/`xpath`")
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
    abort("Can't go back any further")
  }

  url <- x$back[[1]]
  x$back <- x$back[-1]

  x <- session_request(x, "GET", url)
  x$forward <- c(x$url, x$forward)
  x
}

#' @export
#' @rdname session
session_forward <- function(x) {
  check_session(x)

  if (length(x$forward) == 0) {
    abort("Can't go forward any further")
  }

  url <- x$forward[[1]]

  x <- session_request(x, "GET", url)
  x$forward <- x$forward[-1]
  x$back <- c(x$url, x$backs)
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
#' @param submit Which button should be used?
#'   * `NULL`, the default, uses the first.
#'   * A string selects a button by its name.
#'   * A number selects a button based on it relative position.
#' @rdname session
#' @export
session_submit <- function(x, form, submit = NULL, ...) {
  check_session(x)
  check_form(form)
  request <- submission_build(form, submit)

  if (request$method == "POST") {
    session_request(x,
      method = "POST",
      url = request$action,
      body = request$values,
      encode = request$enctype,
      ...
    )
  } else {
    session_request(x,
      method = "GET",
      url = request$action,
      query = request$values,
      ...
    )
  }
}

submission_build <- function(form, submit) {
  method <- form$method
  if (!(method %in% c("POST", "GET"))) {
    warn(paste0("Invalid method (", method, "), defaulting to GET"))
    method <- "GET"
  }

  if (length(form$action) == 0) {
    abort("`form` doesn't contain a `action` attribute")
  }

  list(
    method = method,
    enctype = form$enctype,
    action = form$action,
    values = submission_build_values(form, submit)
  )
}

submission_build_values <- function(form, submit = NULL) {
  fields <- form$fields
  submit <- submission_find_submit(fields, submit)
  entry_list <- c(Filter(Negate(is_button), fields), list(submit))
  entry_list <- Filter(function(x) !is.null(x$name), entry_list)

  if (length(entry_list) == 0) {
    return(list())
  }

  values <- lapply(entry_list, function(x) as.character(x$value))
  names <- map_chr(entry_list, "[[", "name")

  out <- set_names(unlist(values, use.names = FALSE), rep(names, lengths(values)))
  as.list(out)
}

submission_find_submit <- function(fields, idx) {
  buttons <- Filter(is_button, fields)

  if (is.null(idx)) {
    if (length(buttons) == 0) {
      list()
    } else {
      if (length(buttons) > 1) {
        inform(paste0("Submitting with '", buttons[[1]]$name, "'"))
      }
      buttons[[1]]
    }
  } else if (is.numeric(idx) && length(idx) == 1) {
    if (idx < 1 || idx > length(buttons)) {
      abort("Numeric `submit` out of range")
    }
    buttons[[idx]]
  } else if (is.character(idx) && length(idx) == 1) {
    if (!idx %in% names(buttons)) {
      abort(c(
        paste0("No <input> found with name '", idx, "'."),
        i = paste0("Possible values: ", paste0(names(buttons), collapse = ", "))
      ))
    }
    buttons[[idx]]
  } else {
    abort("`submit` must be NULL, a string, or a number.")
  }
}

is_button <- function(x) {
  tolower(x$type) %in% c("submit", "image", "button")
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
html_form.rvest_session <- function(x, base_url = NULL) {
  html_form(read_html(x), base_url = base_url)
}

#' @export
html_table.rvest_session <- function(x,
                               header = NA,
                               trim = TRUE,
                               fill = deprecated(),
                               dec = ".",
                               na.strings = "NA") {
  html_table(
    read_html(x),
    header = header,
    trim = trim,
    fill = fill,
    dec = dec,
    na.strings = na.strings
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

check_form <- function(x) {
  if (!inherits(x, "rvest_form")) {
    abort("`form` must be produced by html_form()")
  }
}
check_session <- function(x) {
  if (!inherits(x, "rvest_session")) {
    abort("`x` must be produced by session()")
  }
}
