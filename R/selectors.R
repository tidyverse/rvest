#' Select elements from an HTML document
#'
#' `html_element()` and `html_elements()` find HTML element using CSS selectors
#' or XPath expressions. CSS selectors are particularly useful in conjunction
#' with <https://selectorgadget.com/>, which makes it very easy to discover the
#' selector you need.
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
#' @param css,xpath Elements to select. Supply one of `css` or `xpath`
#'   depending on whether you want to use a CSS selector or XPath 1.0
#'   expression.
#' @returns `html_element()` returns a nodeset the same length as the input.
#'   `html_elements()` flattens the output so there's no direct way to map
#'   the output to the input.
#' @export
#' @examples
#' html <- minimal_html("
#'   <h1>This is a heading</h1>
#'   <p id='first'>This is a paragraph</p>
#'   <p class='important'>This is an important paragraph</p>
#' ")
#'
#' html %>% html_element("h1")
#' html %>% html_elements("p")
#' html %>% html_elements(".important")
#' html %>% html_elements("#first")
#'
#' # html_element() vs html_elements() --------------------------------------
#' html <- minimal_html("
#'   <ul>
#'     <li><b>C-3PO</b> is a <i>droid</i> that weighs <span class='weight'>167 kg</span></li>
#'     <li><b>R2-D2</b> is a <i>droid</i> that weighs <span class='weight'>96 kg</span></li>
#'     <li><b>Yoda</b> weighs <span class='weight'>66 kg</span></li>
#'     <li><b>R4-P17</b> is a <i>droid</i></li>
#'   </ul>
#' ")
#' li <- html %>% html_elements("li")
#'
#' # When applied to a node set, html_elements() returns all matching elements
#' # beneath any of the inputs, flattening results into a new node set.
#' li %>% html_elements("i")
#'
#' # When applied to a node set, html_element() always returns a vector the
#' # same length as the input, using a "missing" element where needed.
#' li %>% html_element("i")
#' # and html_text() and html_attr() will return NA
#' li %>% html_element("i") %>% html_text2()
#' li %>% html_element("span") %>% html_attr("class")
html_element <- function(x, css, xpath) {
  UseMethod("html_element")
}

#' @export
#' @rdname html_element
html_elements <- function(x, css, xpath) {
  UseMethod("html_elements")
}

#' @export
html_elements.default <- function(x, css, xpath) {
  xml2::xml_find_all(x, make_selector(css, xpath))
}

#' @export
html_element.default <- function(x, css, xpath) {
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

