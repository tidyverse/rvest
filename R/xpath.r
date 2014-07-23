#' XPath & css selector helpers
#'
#' More easily extract pieces out of HTML documents using XPath and css
#' selectors. CSS selectors are particularly useful in conjunction with
#' \url{http://selectorgadget.com/}: it makes it easy to find exactly
#' which selector you should be using.
#'
#' @param x XPath or css selector.
#' @examples
#' # CSS selectors ----------------------------------------------
#' library(httr)
#' url <- "http://www.boxofficemojo.com/movies/?id=ateam.htm"
#' html <- content(GET(url), "parsed")
#' html[sel("center")]
#' html[sel("center font")]
#' html[sel("center font b")]
#'
#' # You can also chain subsetting:
#' html[sel("center")][sel("td")]
#' html[sel("center")][sel("font")]
#' html[sel("table")][[1]][sel("img")]
#'
#' # XPath selectors ---------------------------------------------
#' # chaining with XPath is a little trickier - you may need to vary
#' # the prefix you're using - // always selects from the root noot
#' # regardless of where you currently are in the doc
#' boxoffice <- html[sel("center font b")]
#' boxoffice[xpath("//b")]
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

