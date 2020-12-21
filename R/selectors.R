#' Select nodes from an HTML document
#'
#' `html_node()` and `html_nodes()` find HTML tags (nodes) using CSS selectors
#' XPath expressions.
#'
#' CSS selectors are particularly useful in conjunction with
#' <https://selectorgadget.com/>, which makes it very easy to discover the
#' selector you need. If you haven't used CSS selectors before, I'd recommend
#' starting with the the fun tutorial at <http://flukeout.github.io/>.
#'
#' @section CSS selector support:
#'
#' CSS selectors are translated to XPath selectors by the \pkg{selectr}
#' package, which is a port of the python \pkg{cssselect} library,
#' <https://pythonhosted.org/cssselect/>.
#'
#' It implements the majority of CSS3 selectors, as described in
#' <http://www.w3.org/TR/2011/REC-css3-selectors-20110929/>. The
#' exceptions are listed below:
#'
#' * Pseudo selectors that require interactivity are ignored:
#'   `:hover`, `:active`, `:focus`, `:target`, `:visited`.
#' * The following pseudo classes don't work with the wild card element, *:
#'   `*:first-of-type`, `*:last-of-type`, `*:nth-of-type`,
#'   `*:nth-last-of-type`, `*:only-of-type`
#' * It supports `:contains(text)`
#' * You can use !=, `[foo!=bar]` is the same as `:not([foo=bar])`
#' * `:not()` accepts a sequence of simple selectors, not just a single
#'   simple selector.
#'
#' @param x Either a document, a node set or a single node.
#' @param css,xpath Nodes to select. Supply one of `css` or `xpath`
#'   depending on whether you want to use a CSS or XPath 1.0 selector.
#' @returns `html_node()` returns a nodeset the same length as the input.
#'   `html_nodes()` flattens the output so there's no direct way to map
#'   the output to the input.
#' @export
#' @examples
#' url <- paste0(
#'   "https://web.archive.org/web/20190202054736/",
#'   "https://www.boxofficemojo.com/movies/?id=ateam.htm"
#' )
#' ateam <- read_html(url)
#' html_nodes(ateam, "center")
#' html_nodes(ateam, "center font")
#' html_nodes(ateam, "center font b")
#'
#' # html_nodes() well suited to use with the pipe
#' ateam %>% html_nodes("center") %>% html_nodes("td")
#' ateam %>% html_nodes("center") %>% html_nodes("font")
#'
#' td <- ateam %>% html_nodes("center") %>% html_nodes("td")
#' td
#' # When applied to a list of nodes, html_nodes() returns all matching nodes
#' # beneath any of the elements, flattening results into a new nodelist.
#' td %>% html_nodes("font")
#'
#' # html_node() returns the first matching node. If there are no matching
#' # nodes, it returns a "missing" node
#' td %>% html_node("font")
#'
#' # To pick out an element or elements at specified positions, use [[ and [
#' ateam %>% html_nodes("table") %>% .[[1]] %>% html_nodes("img")
#' ateam %>% html_nodes("table") %>% .[1:2] %>% html_nodes("img")
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
  xml2::xml_find_first(x, make_selector(css, xpath))
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

