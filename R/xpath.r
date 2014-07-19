
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
sel <- function(x) xpath(css_to_xpath(x, prefix = "//"))

#' @export
"[.HTMLInternalDocument" <- function(x, i, ...) {
  if (inherits(i, "xpath")) {
    xpathApply(x, i)
  } else {
    NextMethod()
  }
}

