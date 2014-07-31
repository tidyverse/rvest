#' Simulate a session in an html browser.
#'
#' @section Methods:
#' A session object responds to a combination of httr and html methods:
#' use \code{\link[httr]{cookies}()}, \code{\link[httr]{headers}()},
#' and \code{\link[httr]{status_code}()} to access properties of the request;
#' using subsetting with selectors (\code{\link{xpath}()}, \code{\link{sel}()}).
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
#'
#' \dontrun{
#' # Get my united miles
#' united <- html_session("http://www.united.com/", config(http.version = 2L))
#' account <- united %>% follow_link("Account")
#'
#' login <- account[sel("form")][[1]]
#' login <- login %>% html_form() %>%
#'    set_values(
#'     `ctl00$ContentInfo$SignIn$onepass$txtField` = "GY797363",
#'     `ctl00$ContentInfo$SignIn$password$txtPassword` = password
#'   )
#' account %>% submit_form(login, "ctl00$ContentInfo$SignInSecure")
#' }
html_session <- function(url, ...) {
  session <- structure(
    list(
      handle   = httr::handle(url),
      config   = c(..., config(autoreferer = 1L)),
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
  # Some sites redirect a POST request - in that case, the following request
  # should be convert to a GET. This is does not agree with the HTTP spec,
  # but is common in practice (see http://stackoverflow.com/questions/8138137
  # for discussion).
  x$response <- httr::POST(url, x$config, ..., config(followlocation = FALSE),
    handle = x$handle)
  x$html <- new.env(parent = emptyenv(), hash = FALSE)
  x$url <- x$response$url
  x$back <- character() # can't go back after a post

  if (status_code(x) %/% 100 == 3) {
    url <- headers(x)$Location
    request_GET(x, url)
  } else {
    httr::warn_for_status(x$response)
    x

  }

}

show <- function(x) {
  temp <- tempfile()
  writeBin(httr::content(x$response, "raw"), temp)
  browseURL(temp)
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
  request_GET(x, url, ...)
}

#' @param i You can select with: \describe{
#'   \item{an integer}{selects the ith link}
#'   \item{a css or xpath selector}{selects first link that matches selector}
#'   \item{a string}{first link containing that text (case sensitive)}
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

  request_GET(x, url)
}

#' @export
print.history <- function(x, ...) {
  prefix <- rep(c("  ", "- ", "  "), c(length(x$back), 1, length(x$forward)))

  cat(paste0(prefix, unlist(x), collapse = "\n"), "\n", sep = "")
}

# html methods -----------------------------------------------------------------

#' @export
html_form.session <- function(x) html_form(get_html(x))

#' @export
html_table.session <- function(x) html_table(get_html(x))

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
