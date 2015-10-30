#' Guess and repair faulty character encoding.
#'
#' These functions help you respond to web pages that declare incorrect
#' encodings. You can use \code{guess_encoding} to figure out what
#' the real encoding is (and then supply that to the \code{encoding} argument of
#' html), or use \code{repair_encoding} to fix character vectors after the
#' fact.
#'
#' @section stringi:
#'
#' These function are wrappers around tools from the fantastic stringi
#' package, so you'll need to make sure to have that installed.
#'
#' @param x A character vector.
#' @param from The encoding that the string is actually in. If \code{NULL},
#' @name encoding
#' @examples
#' \donttest{
#' # This page claims to be in iso-8859-1:
#' url <- 'http://www.elections.ca/content.aspx?section=res&dir=cir/list&document=index&lang=e#list'
#' elections <- read_html(url)
#' x <- elections %>% html_nodes("table") %>% .[[2]] %>% html_table() %>% .$TO
#' # But something looks wrong:
#' x
#'
#' # It's acutally UTF-8!
#' guess_encoding(x)
#'
#' # We can repair this vector:
#' repair_encoding(x)
#'
#' # But it's better to start from scratch with correctly encoded file
#' elections <- read_html(url, encoding = "UTF-8")
#' elections %>% html_nodes("table") %>% .[[2]] %>% html_table() %>% .$TO
#' }
NULL

#' @rdname encoding
#' @export
guess_encoding <- function(x) {
  if (!requireNamespace("stringi", quietly = TRUE)) {
    stop("stringi package required for encoding operations")
  }

  guess <- stringi::stri_enc_detect(paste(x, collapse = ""))

  df <- as.data.frame(guess[[1]], stringsAsFactors = FALSE)
  names(df) <- tolower(names(df))
  df
}

#' @rdname encoding
#' @export
repair_encoding <- function(x, from = NULL) {
  if (!requireNamespace("stringi", quietly = TRUE)) {
    stop("stringi package required for encoding operations")
  }

  if (is.null(from)) {
    best_guess <- guess_encoding(x)[1, , drop = FALSE]
    from <- best_guess$encoding
    conf <- best_guess$confidence * 100
    if (conf < 50) {
      stop("No guess has more than 50% confidence", call. = FALSE)
    }

    message("Best guess: ", from, " (", conf, "% confident)")
  }

  stringi::stri_conv(x, from = from)
}
