#' Simulate a session in an html browser.
#'
#' @section Methods:
#' A session object responds to a combination of httr and html methods:
#' use \code{\link[httr]{cookies}()}, \code{\link[httr]{headers}()},
#' and \code{\link[httr]{status_code}()} to access properties of the request;
#' and \code{\link{html_nodes}} to access the html.
#'
#' @param url Location to start session
#' @param ... Any additional httr config to use throughout session.
#' @param x An object to test to see if it's a session.
#' @export
#' @examples
#' # http://stackoverflow.com/questions/15853204
#'
#' s <- html_session("http://had.co.nz")
#' s %>% jump_to("thesis") %>% jump_to("/") %>% session_history()
#' s %>% jump_to("thesis") %>% back() %>% session_history()
#' \donttest{
#' s %>% follow_link(css = "p a")
#' }
html_session <- function(url, ...) {
  session <- structure(
    list(
      handle   = httr::handle(url),
      config   = c(..., httr::config(autoreferer = 1L)),
      url      = NULL,
      back     = character(),
      forward  = character(),
      response = NULL,
      html     = new.env(parent = emptyenv(), hash = FALSE)
    ),
    class = "session"
  )
  request_GET(session, url)
}

#' @export
print.session <- function(x, ...) {
  cat("<session> ", x$url, "\n", sep = "")
  cat("  Status: ", httr::status_code(x$response), "\n", sep = "")
  cat("  Type:   ", httr::headers(x)$`Content-Type`, "\n", sep = "")
  cat("  Size:   ", length(x$response$content), "\n", sep = "")
}

request_GET <- function(x, url, ...) {
  x$response <- httr::GET(url, x$config, ..., handle = x$handle)
  x$html <- new.env(parent = emptyenv(), hash = FALSE)
  x$url <- x$response$url

  httr::warn_for_status(x$response)

  x
}

request_POST <- function(x, url, ...) {
  x$response <- httr::POST(url, x$config, ..., handle = x$handle)
  x$html <- new.env(parent = emptyenv(), hash = FALSE)
  x$url <- x$response$url
  x$back <- character() # can't go back after a post

  httr::warn_for_status(x$response)
  x
}

show <- function(x) {
  temp <- tempfile()
  writeBin(httr::content(x$response, "raw"), temp)
  utils::browseURL(temp)
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
#' \donttest{
#' s <- html_session("http://had.co.nz")
#' s %>% jump_to("thesis/")
#' s %>% follow_link("vita")
#' s %>% follow_link(3)
#' s %>% follow_link("vita")
#' }
jump_to <- function(x, url, ...) {
  stopifnot(is.session(x))

  url <- xml2::url_absolute(url, x$url)

  x$back <- c(url, x$back)
  x$forward <- character()
  request_GET(x, url, ...)
}

#' @param i You can select with: \describe{
#'   \item{an integer}{selects the ith link}
#'   \item{a string}{first link containing that text (case sensitive)}
#' }
#' @inheritParams html_node
#' @export
#' @rdname jump_to
follow_link <- function(x, i, css, xpath, ...) {
  stopifnot(is.session(x))

  if (!missing(i)) {
    stopifnot(length(i) == 1)
    if (is.numeric(i)) {
      a <- html_nodes(x, "a")[[i]]
    } else if (is.character(i)) {
      links <- html_nodes(x, "a")
      text <- html_text(links)
      match <- grepl(i, text, fixed = TRUE)
      if (!any(match)) {
        stop("No links have text '", i, "'", call. = FALSE)
      }

      a <- links[[which(match)[1]]]
    }
  } else {
    links <- html_nodes(x, css = css, xpath = xpath)
    if (length(links) == 0) {
      stop("No links matched that expression", call. = FALSE)
    }
    a <- links[[1]]
  }

  url <- html_attr(a, "href")
  message("Navigating to ", url)
  jump_to(x, url, ...)
}

# History navigation -----------------------------------------------------------

#' History navigation tools
#'
#' @export
#' @param x A session.
session_history <- function(x) {
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
#' @rdname session_history
back <- function(x) {
  stopifnot(is.session(x))

  if (length(x$back) == 0) {
    stop("Can't go back any further", call. = FALSE)
  }

  url <- x$back[[1]]
  x$back <- x$back[-1]
  x$forward <- c(url, x$forward)

  request_GET(x, url)
}

#' @export
print.history <- function(x, ...) {
  prefix <- rep(c("  ", "- ", "  "), c(length(x$back), 1, length(x$forward)))

  cat(paste0(prefix, unlist(x), collapse = "\n"), "\n", sep = "")
}

# html methods -----------------------------------------------------------------

#' @export
html_form.session <- function(x) html_form(xml2::read_html(x))

#' @export
html_table.session <- function(x, header = NA, trim = TRUE, fill = FALSE,
                               dec = ".") {
  html_table(xml2::read_html(x), header = header, trim = trim, fill = fill, dec = dec)
}

#' @export
html_node.session <- function(x, css, xpath) {
  html_node(xml2::read_html(x), css, xpath)
}

#' @export
html_nodes.session <- function(x, css, xpath) {
  html_nodes(xml2::read_html(x), css, xpath)
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
