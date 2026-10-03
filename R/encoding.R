#' Guess faulty character encoding
#'
#' `html_encoding_guess()` helps you handle web pages that declare an incorrect
#' encoding. Use `html_encoding_guess()` to generate a list of possible
#' encodings, then try each out by using `encoding` argument of `read_html()`.
#'
#' @param x A character vector.
#' @export
#' @examples
#' # A file with bad encoding included in the package
#' path <- system.file("html-ex", "bad-encoding.html", package = "rvest")
#' x <- read_html(path)
#' x |> html_elements("p") |> html_text()
#'
#' html_encoding_guess(x)
#' # Two valid encodings, only one of which is correct
#' read_html(path, encoding = "ISO-8859-1") |> html_elements("p") |> html_text()
#' read_html(path, encoding = "ISO-8859-2") |> html_elements("p") |> html_text()
html_encoding_guess <- function(x) {
  check_installed("stringi")

  guess <- stringi::stri_enc_detect(paste(x, collapse = ""))

  df <- as.data.frame(guess[[1]], stringsAsFactors = FALSE)
  names(df) <- tolower(names(df))
  df
}
