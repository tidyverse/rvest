#' Xpath & css selector helpers
#'
#' @examples
#' library(httr)
#' url <- "http://www.boxofficemojo.com/movies/?id=ateam.htm"
#' html <- content(GET(url), "parsed")
#' html[sel("center")]
#' html[sel("center font")]
#' html[sel("center font b")]
#' @export
xpath <- function(x) structure(x, class = c("xpath_selector", "selector"))

#' @rdname xpath
#' @export
sel <- function(x) structure(x, class = c("css_selector", "selector"))

#' @export
print.selector <- function(x, ...) {
  cat("<", class(x)[1], "> ", x, "\n", sep = "")
}

#' @export
`[.HTMLInternalDocument` <- function(x, i, ...) {
  if (!inherits(i, "selector")) NextMethod()

  if (inherits(i, "css_selector")) {
    i <- selectr::css_to_xpath(i, prefix = "//")
  }
  XML::getNodeSet(x, i)
}

#' @export
`[.XMLInternalElementNode` <- function(x, i, ...) {
  if (!inherits(i, "selector")) NextMethod()

  if (inherits(i, "css_selector")) {
    i <- selectr::css_to_xpath(i, prefix = "descendant::")
  }
  XML::getNodeSet(x, i)
}

#' @export
`[.XMLNodeSet` <- function(x, i, ...) {
  if (!inherits(i, "selector")) NextMethod()

  if (inherits(i, "css_selector")) {
    i <- selectr::css_to_xpath(i, prefix = "descendant::")
  }

  nodes <- unlist(lapply(x, XML::getNodeSet, path = i), recursive = FALSE)
  class(nodes) <- "XMLNodeSet"
  nodes
}

