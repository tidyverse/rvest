parse <- function(x, parser, ..., encoding = NULL) UseMethod("parse")

#' @export
parse.character <- function(x, parser, ..., encoding = NULL) {
  if (grepl("^http", x)) {
    r <- httr::GET(x, ...)
    parse(r, parser, encoding = encoding)
  } else if (grepl("<|>", x)) {
    parser(x, asText = TRUE, encoding = encoding)
  } else {
    parser(x, asText = FALSE, encoding = encoding)
  }
}

#' @export
parse.response <- function(x, parser, ..., encoding = NULL) {
  httr::stop_for_status(x)

  text <- httr::content(x, "text")
  encoding <- encoding %||% default_encoding(x)

  xml <- parser(text, asText = TRUE, encoding = encoding)
  XML::docName(xml) <- x$url
  xml
}

#' @export
parse.XMLAbstractDocument <- function(x, parser, ..., encoding = NULL) {
  x
}

#' @export
parse.session <- function(x, parser, ..., encoding = NULL) {
  if (exists("cached", envir = x$html)) {
    return(x$html$cached)
  }

  if (!is_html(x)) {
    stop("Current page doesn't appear to be html.", call. = FALSE)
  }

  x$html$cached <- parse(x$response, parser, encoding = encoding)
  x$html$cached
}


default_encoding <- function(x) {
  type <- httr::headers(x)$`Content-Type`
  if (is.null(type)) return(NULL)

  media <- httr::parse_media(type)
  media$params$charset
}
