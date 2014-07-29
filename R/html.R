#' Parse an HTML page.
#'
#' @param x A url, a string containing html, or a a httr response.
#' @export
html <- function(x) UseMethod("html")

#' @export
html.character <- function(x) {
  if (grepl(x, "<|>")) {
    XML::htmlParse(x)
  } else {
    r <- httr::GET(x)
    html(r)
  }
}

#' @export
html.response <- function(x) {
  httr::stop_for_status(x)
  httr::content(x, "parsed")
}

#' @export
html.XMLAbstractDocument <- function(x, ...) {
  x
}

#' Extract attributes, text and tag name from html.
#'
#' @param x Either a complete document (HTMLInternalDocument),
#'   a list of tags (XMLNodeSet) or a single tag (XMLInternalElementNode).
#' @param name Name of attribute to extract.
#' @param ... Other arguments passed onto \code{\link[XML]{xmlValue}()}.
#'   The most useful argument is \code{trim = TRUE} which will remove leading
#'   and trailing whitespace.
#' @return \code{html_attr}, \code{html_tag} and \code{html_text}, a character
#'   vector; \code{html_attrs}, a list.
#' @export
#' @examples
#' movie <- html("http://www.imdb.com/title/tt1490017/")
#' cast <- movie[sel("#titleCast span.itemprop")]
#' html_text(cast)
#' html_tag(cast)
#' html_attrs(cast)
#' html_attr(cast, "class")
#' html_attr(cast, "itemprop")
html_text <- function(x, ...) {
  xml_apply(x, XML::xmlValue, ..., .type = character(1))
}

#' @rdname html_text
#' @export
html_tag <- function(x) {
  xml_apply(x, XML::xmlName, .type = character(1))
}

#' @rdname html_text
#' @export
html_attrs <- function(x) {
  xml_apply(x, XML::xmlAttrs)
}

#' @rdname html_text
#' @export
html_attr <- function(x, name) {
  xml_apply(x, function(x) XML::xmlAttrs(x)[[name]], .type = character(1))
}
