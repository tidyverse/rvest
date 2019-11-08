#' Select nodes from an HTML document
#'
#' More easily extract pieces out of HTML documents using XPath and CSS
#' selectors. CSS selectors are particularly useful in conjunction with
#' <http://selectorgadget.com/>: it makes it easy to find exactly
#' which selector you should be using. If you haven't used CSS selectors
#' before, work your way through the fun tutorial at
#' <http://flukeout.github.io/>
#'
#' @section `html_node` vs `html_nodes`:
#' `html_node` is like `[[` it always extracts exactly one
#' element. When given a list of nodes, `html_node` will always return
#' a list of the same length, the length of `html_nodes` might be longer
#' or shorter.
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
#' \itemize{
#' \item Pseudo selectors that require interactivity are ignored:
#'   `:hover`, `:active`, `:focus`, `:target`,
#'   `:visited`
#' \item The following pseudo classes don't work with the wild card element, *:
#'   `*:first-of-type`, `*:last-of-type`, `*:nth-of-type`,
#'   `*:nth-last-of-type`, `*:only-of-type`
#' \item It supports `:contains(text)`
#' \item You can use !=, `[foo!=bar]` is the same as `:not([foo=bar])`
#' \item `:not()` accepts a sequence of simple selectors, not just single
#'   simple selector.
#' }
#'
#' @param x Either a document, a node set or a single node.
#' @param css,xpath Nodes to select. Supply one of `css` or `xpath`
#'   depending on whether you want to use a CSS or XPath 1.0 selector.
#' @export
#' @examples
#' # CSS selectors ----------------------------------------------
#' url <- paste0(
#'   "https://web.archive.org/web/20190202054736/",
#'   "https://www.boxofficemojo.com/movies/?id=ateam.htm"
#' )
#' ateam <- read_html(url)
#' html_nodes(ateam, "center")
#' html_nodes(ateam, "center font")
#' html_nodes(ateam, "center font b")
#'
#' # But html_node is best used in conjunction with %>% from magrittr
#' # You can chain subsetting:
#' ateam %>% html_nodes("center") %>% html_nodes("td")
#' ateam %>% html_nodes("center") %>% html_nodes("font")
#'
#' td <- ateam %>% html_nodes("center") %>% html_nodes("td")
#' td
#' # When applied to a list of nodes, html_nodes() returns all nodes,
#' # collapsing results into a new nodelist.
#' td %>% html_nodes("font")
#' # html_node() returns the first matching node. If there are no matching
#' # nodes, it returns a "missing" node
#' if (utils::packageVersion("xml2") > "0.1.2") {
#'   td %>% html_node("font")
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
#' # the prefix you're using - // always selects from the root node
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
  if (utils::packageVersion("xml2") > "0.1.2") {
    xml2::xml_find_first(x, make_selector(css, xpath))
  } else {
    xml2::xml_find_one(x, make_selector(css, xpath))
  }
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

