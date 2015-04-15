#' Select nodes from an HTML document
#'
#' More easily extract pieces out of HTML documents using XPath and css
#' selectors. CSS selectors are particularly useful in conjunction with
#' \url{http://selectorgadget.com/}: it makes it easy to find exactly
#' which selector you should be using. If you have't used css selectors
#' before, work your way through the fun tutorial at
#' \url{http://flukeout.github.io/}
#'
#' @section \code{html_node} vs \code{html_nodes}:
#' \code{html_node} is like \code{[[} it always extracts exactly one
#' element. When given a list of nodes, \code{html_node} will always return
#' a list of the same length, the length of \code{html_nodes} might be longer
#' or shorter.
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
#' @param x Either a document, a node set or a single node.
#' @param css,xpath Nodes to select. Supply one of \code{css} or \code{xpath}
#'   depending on whether you want to use a css or xpath selector.
#' @export
#' @examples
#' # CSS selectors ----------------------------------------------
#' ateam <- read_html("http://www.boxofficemojo.com/movies/?id=ateam.htm")
#' html_nodes(ateam, "center")
#' html_nodes(ateam, "center font")
#' html_nodes(ateam, "center font b")
#'
#' # But html_node is best used in conjunction with %>% from magrittr
#' # You can chain subsetting:
#' ateam %>% html_nodes("center") %>% html_nodes("td")
#' ateam %>% html_nodes("center") %>% html_nodes("font")
#'
#' # When applied to a list of nodes, html_nodes() collapses output
#' # html_node() throws an error
#' td <- ateam %>% html_nodes("center") %>% html_nodes("td")
#' td %>% html_nodes("font")
#' \dontrun{
#' td %>% html_node("font")
#' }
#'
#' # To pick out an element at specified position, use magrittr::extract2
#' # which is an alias for [[
#' library(magrittr)
#' ateam %>% html_nodes("table") %>% extract2(1) %>% html_nodes("img")
#' ateam %>% html_nodes("table") %>% `[[`(1) %>% html_nodes("img")
#'
#' # Find all images contained in the first two tables
#' ateam %>% html_nodes("table") %>% `[`(1:2) %>% html_nodes("img")
#' ateam %>% html_nodes("table") %>% extract(1:2) %>% html_nodes("img")
#'
#' # XPath selectors ---------------------------------------------
#' # chaining with XPath is a little trickier - you may need to vary
#' # the prefix you're using - // always selects from the root noot
#' # regardless of where you currently are in the doc
#' ateam %>%
#'   html_nodes(xpath = "//center//font//b") %>%
#'   html_nodes(xpath = "//b")
html_nodes <- function(x, css, xpath) {
  UseMethod("html_nodes")
}

#' @export
html_nodes.default <- function(x, css, xpath) {
  xml2::xml_find_all(x, make_selector(css, xpath))
}

#' @export
#' @rdname html_nodes
html_node <- function(x, css, xpath) {
  UseMethod("html_node")
}

#' @export
html_node.default <- function(x, css, xpath) {
  xml2::xml_find_one(x, make_selector(css, xpath))
}

make_selector <- function(css, xpath) {
  if (missing(css) && missing(xpath))
    stop("Please supply one of css or xpath", call. = FALSE)
  if (!missing(css) && !missing(xpath))
    stop("Please supply css or xpath, not both", call. = FALSE)

  if (!missing(css)) {
    if (!is.character(css) && length(css) == 1)
      stop("`css` must be a string")

    selectr::css_to_xpath(css, prefix = ".//")
  } else {
    if (!is.character(xpath) && length(xpath) == 1)
      stop("`xpath` must be a string")

    xpath
  }
}

