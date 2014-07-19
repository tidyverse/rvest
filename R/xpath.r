#' Xpath & css selector helpers
#'
#' @examples
#' url <- "http://www.boxofficemojo.com/movies/?id=ateam.htm"
#' html <- content(GET(url), "parsed")
#' html[sel("center")]
#' html[sel("center font")]
#' html[sel("center font b")]
#' @export
xpath <- function(x) structure(x, class = "xpath")

#' @rdname xpath
#' @export
sel <- function(x) structure(x, class = "sel")

#' @export
`[.HTMLInternalDocument` <- function(x, i, ...) {
  if (inherits(i, "sel")) {
    i <- selectr::css_to_xpath(i, prefix = "//")
    XML::getNodeSet(x, i)
  } else if (inherits(i, "xpath")) {
    XML::getNodeSet(x, i)
  } else {
    NextMethod()
  }
}

#' @export
`[.XMLInternalElementNode` <- function(x, i, ...) {
  if (inherits(i, "sel")) {
    i <- selectr::css_to_xpath(i)
    XML::getNodeSet(x, i)
  } else if (inherits(i, "xpath")) {
    XML::getNodeSet(x, i)
  } else {
    NextMethod()
  }
}

#' @export
`[.XMLNodeSet` <- function(x, i, ...) {
  if (!inherits(i, "xpath")) NextMethod()

  l <- unlist(lapply(x, XML::getNodeSet, path = i), recursive = FALSE)
  class(l) <- "XMLNodeSet"
  l
}

