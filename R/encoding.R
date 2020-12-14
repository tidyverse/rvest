#' Guess faulty character encoding
#'
#' `html_encoding_guess()` helps you handle web pages that declare an incorrect
#' encoding. Use `html_encoding_guess()` to generate a list of possible
#' encodings, then try each out by using `encoding` argument of `read_html()`.
#' `html_encoding_guess()` replaces the deprecated `guess_encoding()`.
#'
#' @param x A character vector.
#' @export
#' @examples
#' # A file with bad encoding included in the package
#' path <- system.file("html-ex", "bad-encoding.html", package = "rvest")
#' x <- read_html(path)
#' x %>% html_nodes("p") %>% html_text()
#'
#' html_encoding_guess(x)
#' # Two valid encodings, only one of which is correct
#' read_html(path, encoding = "ISO-8859-1") %>% html_nodes("p") %>% html_text()
#' read_html(path, encoding = "ISO-8859-2") %>% html_nodes("p") %>% html_text()
html_encoding_guess <- function(x) {
  if (!requireNamespace("stringi", quietly = TRUE)) {
    stop("stringi package required for encoding operations")
  }

  guess <- stringi::stri_enc_detect(paste(x, collapse = ""))

  df <- as.data.frame(guess[[1]], stringsAsFactors = FALSE)
  names(df) <- tolower(names(df))
  df
}

#' @export
#' @rdname html_encoding_guess
#' @usage NULL
guess_encoding <- function(x) {
  lifecycle::deprecate_warn("1.0.0", "guess_encoding()", "html_encoding_guess()")
  html_encoding_guess(x)
}

#' Repair faulty encoding
#'
#' `r lifecycle::badge("deprecated")`
#' This function has been deprecated because it doesn't work. Instead
#' re-read the HTML file with correct `encoding` argument.
#'
#' @export
#' @keywords internal
#' @param from The encoding that the string is actually in. If `NULL`,
#'   `guess_encoding` will be used.
repair_encoding <- function(x, from = NULL) {
  lifecycle::deprecate_warn("1.0.0", "html_encoding_repair()",
    details = "Instead, re-load using the `encoding` argument of `read_html()`"
  )

  if (!requireNamespace("stringi", quietly = TRUE)) {
    stop("stringi package required for encoding operations")
  }

  if (is.null(from)) {
    best_guess <- html_encoding_guess(x)[1, , drop = FALSE]
    from <- best_guess$encoding
    conf <- best_guess$confidence * 100
    if (conf < 50) {
      stop("No guess has more than 50% confidence", call. = FALSE)
    }

    inform(paste0("Best guess: ", from, " (", conf, "% confident)"))
  }

  stringi::stri_conv(x, from)
}

#' Deprecated encoding functions
#'
#' `r lifecycle::badge("deprecated")`
#' These functions have been replaced by [html_encoding_guess()] and
#' [html_encoding_repair()].
#'
