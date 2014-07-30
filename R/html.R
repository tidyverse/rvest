#' Parse an HTML page.
#'
#' @param x A url, a string containing html, or a response from an httr request.
#' @export
#' @examples
#' # From a url:
#' google <- html("http://google.com")
#' google[sel("p")]
#'
#' # From a string: (minimal html 5 document)
#' # http://www.brucelawson.co.uk/2010/a-minimal-html5-document/
#' minimal <- html("<!doctype html>
#'   <meta charset=utf-8>
#'  <title>blah</title>
#'  <p>I'm the content")
#' minimal
#'
#' # From an httr request
#' google2 <- html(httr::GET("http://google.com"))
html <- function(x) UseMethod("html")

#' @export
html.character <- function(x) {
  if (grepl("<|>", x) && !(grepl("^http", x))) {
    XML::htmlParse(x)
  } else {
    r <- httr::GET(x)
    html(r)
  }
}

#' @export
html.response <- function(x) {
  httr::stop_for_status(x)
  xml <- httr::content(x, "parsed")
  XML::docName(xml) <- x$url
  xml
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
#'
#' basic <- html("<p class='a'><b>Bold text</b></p>")
#' # See sel()/xpath() for CSS selector and xpath selectors
#' p <- basic[sel("p")][[1]]
#' p
#' # Can subset with numbers to extract children
#' p[[1]]
#' # Or with strings to extract attributes
#' p["class"]
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
