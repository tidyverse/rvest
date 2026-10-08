#' @export
read_html.httr2_response <- function(
  x,
  encoding = "UTF-8",
  options = c("RECOVER", "NOERROR", "NOBLANKS"),
  ...
) {
  check_installed("httr2")
  httr2::resp_check_status(x)
  xml2::read_html(
    httr2::resp_body_raw(x),
    encoding = encoding,
    options = options,
    base_url = httr2::resp_url(x),
    ...
  )
}
