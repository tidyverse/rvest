#' XML selectors.
#'
#' More easily extract pieces out of HTML documents using XPath and css
#' selectors. CSS selectors are particularly useful in conjunction with
#' \url{http://selectorgadget.com/}: it makes it easy to find exactly
#' which selector you should be using.
#'
#' @section CSS selector support:
#'
#' CSS selectors are translated to XPath selectors by the \pkg{selectr}
#' package, which is a port of the python \pkg{cssselect} library,
#' \url{https://pythonhosted.org/cssselect/}.
#'
#' It implements the majority of CSS3 selectors, as described in
#' \url{http://www.w3.org/TR/2011/REC-css3-selectors-20110929/}. The
#' exceptions are listed below:
#'
#' \itemize{
#' \item Pseudo selectors that require interactivity are ignored:
#'   \code{:hover}, \code{:active}, \code{:focus}, \code{:target},
#'   \code{:visited}
#' \item The following pseudo classes don't work with the wild card element, *:
#'   \code{*:first-of-type}, \code{*:last-of-type}, \code{*:nth-of-type},
#'   \code{*:nth-last-of-type}, \code{*:only-of-type}
#' \item It supports \code{:contains(text)}
#' \item You can use !=, \code{[foo!=bar]} is the same as \code{:not([foo=bar])}
#' \item \code{:not()} accepts a sequence of simple selectors, not just single
#'   simple selector.
#' }
#'
#' @param x XPath or css selector.
#' @examples
#' # CSS selectors ----------------------------------------------
#' ateam <- html("http://www.boxofficemojo.com/movies/?id=ateam.htm")
#' ateam[sel("center")]
#' ateam[sel("center font")]
#' ateam[sel("center font b")]
#'
#' # You can chain subsetting:
#' ateam[sel("center")][sel("td")]
#' ateam[sel("center")][sel("font")]
#' ateam[sel("table")][[1]][sel("img")]
#'
#' # Find all images contained in the first two tables
#' ateam[sel("table")][1:2][sel("img")]
#'
#' # XPath selectors ---------------------------------------------
#' # chaining with XPath is a little trickier - you may need to vary
#' # the prefix you're using - // always selects from the root noot
#' # regardless of where you currently are in the doc
#' boxoffice <- ateam[xpath("//center//font//b")]
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
  html_extract_n(x, i, prefix = "//")
}

#' @export
`[.XMLNodeSet` <- function(x, i, ...) {
  if (is.numeric(i)) {
    out <- .subset(x, i)
  } else {
    nodes <- lapply(x, html_extract_n, i, prefix = "descendant::")
    out <- unlist(nodes, recursive = FALSE)
  }

  class(out) <- "XMLNodeSet"
  out
}

#' @export
`[.XMLInternalElementNode` <- function(x, i, ...) {
  html_extract_n(x, i, prefix = "descendant::")
}

html_extract_1 <- function(node, i) {
  if (is.numeric(i)) {
    out <- XML::xmlChildren(node, addNames = FALSE)[[i]]
  } else if (is.character(i)) {
    out <- XML::xmlAttrs(node)[[i]]
  } else {
    stop("Don't know how to subset HTML with object of class ",
      paste(class(i), collapse = ", "), call. = FALSE)
  }
  out
}

html_extract_n <- function(node, i, prefix) {
  if (is.numeric(i)) {
    out <- XML::xmlChildren(node, addNames = FALSE)[i]
  } else if (inherits(i, "css_selector")) {
    xpath <- selectr::css_to_xpath(i, prefix = prefix)
    out <- XML::getNodeSet(node, xpath)
  } else if (inherits(i, "xpath_selector")) {
    out <- XML::getNodeSet(node, i)
  } else if (is.character(i)) {
    out <- XML::xmlAttrs(node)[i]
  } else {
    stop("Don't know how to subset HTML with object of class ",
      paste(class(i), collapse = ", "), call. = FALSE)
  }
  class(out) <- "XMLNodeSet"
  out
}

# Print methods ------------------------
