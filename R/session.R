#' Simulate a session in an html browser.
#'
#' @param url Location to start session
#' @param ... Any additional httr config to use throughout session.
#' @param x An object to test to see if it's a session.
#' @export
#' @examples
#' # http://stackoverflow.com/questions/15853204
#'
#' s <- html_session("http://had.co.nz")
#' s %>% jump_to("thesis") %>% jump_to("/") %>% history()
#' s %>% jump_to("thesis") %>% back() %>% history()
#'
#' s %>% follow_link("vita")
html_session <- function(url, ...) {
  session <- structure(
    list(
      handle   = httr::handle(url),
      config   = httr::config(..., autoreferer = 1L),
      url      = NULL,
      back     = character(),
      forward  = character(),
      response = NULL,
      html     = new.env(parent = emptyenv(), hash = FALSE)
    ),
    class = "session"
  )
  make_request(session, url)
}

#' @export
print.session <- function(x, ...) {
  cat("<session> ", x$url, "\n", sep = "")
  cat("  Status: ", httr::status_code(x$response), "\n", sep = "")
  cat("  Type:   ", httr::headers(x)$`Content-Type`, "\n", sep = "")
  cat("  Size:   ", length(x$response$content), "\n", sep = "")
}

make_request <- function(x, url, ...) {
  x$url <- url
  x$response <- httr::GET(url, x$config, ..., handle = x$handle)
  httr::warn_for_status(x$response)

  x
}

#' @export
#' @rdname html_session
is.session <- function(x) inherits(x, "session")

#' Navigate to a new url.
#'
#' \code{jump_to()} takes a url (either relative or absolute);
#' \code{follow_link} takes an expression that refers to a link (an \code{<a>}
#' tag) on the current page.
#'
#' @param x A session.
#' @param url A URL, either relative or absolute, to navigate to.
#' @param ... Any additional httr configs to apply to this request.
#' @export
#' @examples
#' s <- html_session("http://had.co.nz")
#' s %>% jump_to("thesis/")
#' s %>% follow_link("vita")
#' s %>% follow_link(3)
#' s %>% follow_link(sel("#footer a"))
jump_to <- function(x, url, ...) {
  stopifnot(is.session(x))

  url <- XML::getRelativeURL(url, x$url)

  x$back <- c(url, x$back)
  x$forward <- character()
  make_request(x, url, ...)
}

#' @param i You can select with: \describe{
#'   \item{an integer}{selects the ith link}
#'   \item{a css or xpath selector}{selects first link that matches selector}
#'   \item{a string}{first link containing that text}
#' }
#' @export
#' @rdname jump_to
follow_link <- function(x, i, ...) {
  stopifnot(is.session(x), length(i) == 1)

  if (is.numeric(i)) {
    a <- x[sel("a")][[i]]
  } else if (is.selector(i)) {
    a <- x[i][[1]]
  } else if (is.character(i)) {
    links <- x[sel("a")]
    text <- vapply(links, XML::xmlValue, character(1))
    match <- grepl(i, text, fixed = TRUE)
    if (!any(match)) {
      stop("No links have text '", i, "'", call. = FALSE)
    }

    a <- links[[which(match)[1]]]
  }

  url <- a["href"][[1]]
  message("Navigating to ", url)
  jump_to(x, url, ...)
}

# History navigation -----------------------------------------------------------

#' History navigation tools
#'
#' @export
#' @param x A session.
history <- function(x) {
  structure(
    list(
      back    = rev(x$back),
      url     = x$url,
      forward = x$forward
    ),
    class = "history"
  )
}

#' @export
#' @rdname history
back <- function(x) {
  stopifnot(is.session(x))

  if (length(x$back) == 0) {
    stop("Can't go back any further", call. = FALSE)
  }

  url <- x$back[[1]]
  x$back <- x$back[-1]
  x$forward <- c(url, x$forward)

  make_request(x, url)
}

#' @export
print.history <- function(x, ...) {
  prefix <- rep(c("  ", "- ", "  "), c(length(x$back), 1, length(x$forward)))

  cat(paste0(prefix, unlist(x), collapse = "\n"), "\n", sep = "")
}



# html methods -----------------------------------------------------------------

#' @export
`[.session` <- function(x, i, ...) {
  get_html(x)[i, ...]
}

get_html <- function(x) {
  if (exists("cached", env = x$html)) {
    return(x$html$cached)
  }

  if (!is_html(x)) {
    stop("Current page doesn't appear to be html", call. = FALSE)
  }

  x$html$cached <- httr::content(x$response, "parsed")
  x$html$cached
}

is_html <- function(x) {
  stopifnot(is.session(x))

  type <- httr::headers(x)$`Content-Type`
  if (is.null(type)) return(FALSE)

  parsed <- httr::parse_media(type)
  parsed$complete %in% c("text/html", "application/xhtml+xml")
}




# httr methods -----------------------------------------------------------------

#' @importFrom httr status_code
#' @export
status_code.session <- function(x) {
  status_code(x$response)
}
#' @importFrom httr headers
#' @export
headers.session <- function(x) {
  headers(x$response)
}
#' @importFrom httr cookies
#' @export
cookies.session <- function(x) {
  cookies(x$response)
}
