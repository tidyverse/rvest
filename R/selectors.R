#' Select nodes from an HTML document
#'
#' More easily extract pieces out of HTML documents using XPath and css
#' selectors. CSS selectors are particularly useful in conjunction with
#' \url{http://selectorgadget.com/}: it makes it easy to find exactly
#' which selector you should be using. If you have't used css selectors
#' before, work your way through the fun tutorial at
#' \url{http://flukeout.github.io/}
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
#' @param x Either a complete document (HTMLInternalDocument),
#'   a list of tags (XMLNodeSet) or a single tag (XMLInternalElementNode).
#' @param css,xpath Nodes to select. Supply one of \code{css} or \code{xpath}
#'   depending on whether you want to use a css or xpath selector.
#' @export
#' @examples
#' # CSS selectors ----------------------------------------------
#' ateam <- html("http://www.boxofficemojo.com/movies/?id=ateam.htm")
#' html_node(ateam, "center")
#' html_node(ateam, "center font")
#' html_node(ateam, "center font b")
#'
#' # But html_node is best used in conjunction with %>% from magrittr
#' # You can chain subsetting:
#' ateam %>% html_node("center") %>% html_node("td")
#' ateam %>% html_node("center") %>% html_node("font")
#'
#' # To pick out an element at specified position, use magrittr::extract2
#' # which is an alias for [[
#' library(magrittr)
#' ateam %>% html_node("table") %>% extract2(1) %>% html_node("img")
#' ateam %>% html_node("table") %>% `[[`(1) %>% html_node("img")
#'
#' # Find all images contained in the first two tables
#' ateam %>% html_node("table") %>% `[`(1:2) %>% html_node("img")
#' ateam %>% html_node("table") %>% extract(1:2) %>% html_node("img")
#'
#' # XPath selectors ---------------------------------------------
#' # chaining with XPath is a little trickier - you may need to vary
#' # the prefix you're using - // always selects from the root noot
#' # regardless of where you currently are in the doc
#' ateam %>%
#'   html_node(xpath = "//center//font//b") %>%
#'   html_node(xpath = "//b")
html_node <- function(x, css, xpath) UseMethod("html_node")

#' @export
html_node.HTMLInternalDocument <- function(x, css, xpath) {
  i <- make_selector(css, xpath)
  html_extract_n(x, i, prefix = "//")
}

#' @export
html_node.XMLNodeSet <- function(x, css, xpath) {
  i <- make_selector(css, xpath)
  nodes <- lapply(x, html_extract_n, i, prefix = "descendant::")

  out <- unlist(nodes, recursive = FALSE)
  class(out) <- "XMLNodeSet"
  out
}

#' @export
html_node.XMLInternalElementNode <- function(x, css, xpath) {
  i <- make_selector(css, xpath)
  html_extract_n(x, i, prefix = "descendant::")
}

make_selector <- function(css, xpath) {
  if (missing(css) && missing(xpath))
    stop("Please supply one of css or xpath", call. = FALSE)
  if (!missing(css) && !missing(xpath))
    stop("Please supply css or xpath, not both", call. = FALSE)

  if (!missing(css)) {
    sel(css)
  } else {
    xpath(xpath)
  }

}

xpath <- function(x) structure(x, class = c("xpath_selector", "selector"))
sel <- function(x) structure(x, class = c("css_selector", "selector"))

is.selector <- function(x) inherits(x, "selector")


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
    # Only option that doesn't return XMLNodeSet
    attr <- as.list(XML::xmlAttrs(node))
    attr[setdiff(i, names(attr))] <- NA_character_
    return(attr[i])
  } else {
    stop("Don't know how to subset HTML with object of class ",
      paste(class(i), collapse = ", "), call. = FALSE)
  }
  class(out) <- "XMLNodeSet"
  out
}

