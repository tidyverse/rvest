#' Guess and repair faulty character encoding.
#'
#' These functions help you respond to web pages that declare incorrect
#' encodings. You can use `guess_encoding` to figure out what
#' the real encoding is (and then supply that to the `encoding` argument of
#' html), or use `repair_encoding` to fix character vectors after the
#' fact.
#'
#' @section stringi:
#'
#' These function are wrappers around tools from the fantastic stringi
#' package, so you'll need to make sure to have that installed.
#'
#' @param x A character vector.
#' @param from The encoding that the string is actually in. If `NULL`,
#'   `guess_encoding` will be used.
#' @name encoding
#' @examples
#' # A file with bad encoding included in the package
#' path <- system.file("html-ex", "bad-encoding.html", package = "rvest")
#' x <- read_html(path)
#' x %>% html_nodes("p") %>% html_text()
#'
#' guess_encoding(x)
#' # Two valid encodings, only one of which is correct
#' read_html(path, encoding = "ISO-8859-1") %>% html_nodes("p") %>% html_text()
#' read_html(path, encoding = "ISO-8859-2") %>% html_nodes("p") %>% html_text()
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

    inform(paste0("Best guess: ", from, " (", conf, "% confident)"))
  }

  stringi::stri_conv(x, from = from)
}
