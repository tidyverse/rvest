#' Parse an HTML page.
#'
#' @param x A url, a local path, a string containing html, or a response from
#'   an httr request.
#' @param encoding Specify encoding of document. See \code{\link{iconvlist}()}
#'   for complete list. If you have problems determining the correct encoding,
#'   try \code{\link[stringi]{stri_enc_detect}}
#' @param ... Further arguments to be passed to subsequent functions.
#'   In particular:
#'   \itemize{
#'      \item{\code{\link[httr]{GET}}}
#'   }
#' @export
#' @examples
#' # From a url:
#' google <- html("http://google.com")
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
# html <- function(x, encoding = NULL, httr_config = list(), ...) UseMethod("html")
html <- function(x, encoding = NULL, ...) UseMethod("html")

#' @export
html.character <- function(x, encoding = NULL, ...) {
  if (grepl("^http", x)) {
    r <- httr::GET(x, ...)
    html(r, encoding = encoding)
  } else if (grepl("<|>", x)) {
    XML::htmlParse(x, asText = TRUE, encoding = encoding)
  } else {
    XML::htmlParse(x, asText = FALSE, encoding = encoding)
  }
}
# html.character <- function(x, encoding = NULL, httr_config = list()) {
#   if (grepl("^http", x)) {
#     r <- httr::GET(x, config = httr_config)
#     html(r, encoding = encoding)
#   } else if (grepl("<|>", x)) {
#     XML::htmlParse(x, asText = TRUE, encoding = encoding)
#   } else {
#     XML::htmlParse(x, asText = FALSE, encoding = encoding)
#   }
# }

#' @export
html.response <- function(x, encoding = NULL) {
  httr::stop_for_status(x)

  text <- httr::content(x, "text")
  xml <- XML::htmlParse(text, asText = TRUE,
    encoding = encoding %||% default_encoding(x))
  XML::docName(xml) <- x$url
  xml
}

default_encoding <- function(x) {
  type <- httr::headers(x)$`Content-Type`
  if (is.null(type)) return(NULL)

  media <- httr::parse_media(type)
  media$params$charset
}

#' @export
html.XMLAbstractDocument <- function(x, encoding = NULL) {
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
html_attrs <- function(x) {
  xml_apply(x, XML::xmlAttrs)
}

#' @rdname html_text
#' @param default A string used as a default value when the attribute does
#'   not exist in every node.
#' @export
html_attr <- function(x, name, default = NA_character_) {
  xml_apply(x, xml_attr, name, default = default, .type = character(1))
}

xml_attr <- function(x, name, default) {
  attr <- XML::xmlAttrs(x)
  if (name %in% names(attr)) {
    attr[[name]]
  } else {
    default
  }
}
