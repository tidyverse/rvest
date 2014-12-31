#' Parse an HTML page.
#'
#' @param x A url, a local path, a string containing html, or a response from
#'   an httr request.
#' @param ... If \code{x} is a URL, additional arguments are passed on to
#'   \code{\link[httr]{GET}()}.
#' @param encoding Specify encoding of document. See \code{\link{iconvlist}()}
#'   for complete list. If you have problems determining the correct encoding,
#'   try \code{\link[stringi]{stri_enc_detect}}
#' @export
#' @examples
#' # From a url:
#' google <- html("http://google.com")
#' google %>% xml_structure()
#' google %>% html_nodes("p")
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
html <- function(x, ..., encoding = NULL) {
  parse(x, XML::htmlParse, ..., encoding = encoding)
}

#' Extract attributes, text and tag name from html.
#'
#' @param x Either a complete document (XMLInternalDocument),
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
#' cast <- html_nodes(movie, "#titleCast span.itemprop")
#' html_text(cast)
#' html_tag(cast)
#' html_attrs(cast)
#' html_attr(cast, "class")
#' html_attr(cast, "itemprop")
#'
#' basic <- html("<p class='a'><b>Bold text</b></p>")
#' p <- html_node(basic, "p")
#' p
#' # Can subset with numbers to extract children
#' p[[1]]
#' # Use html_attr to get attributes
#' html_attr(p, "class")
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
html_children <- function(x) {
  xml_apply(x, XML::xmlChildren)
}

#' @rdname html_text
#' @export
html_attrs <- function(x) {
  xml_apply(x, XML::xmlAttrs)
}

#' @rdname html_text
#' @param default A string used as a default value when the attribute does
#'   not exist in every node.
#' @export
html_attr <- function(x, name, default = NA_character_) {
  xml_attr <- function(x, name, default) {
    if (is.null(x)) return(default)

    attr <- XML::xmlAttrs(x)
    if (name %in% names(attr)) {
      attr[[name]]
    } else {
      default
    }
  }

  xml_apply(x, xml_attr, name, default = default, .type = character(1))
}
