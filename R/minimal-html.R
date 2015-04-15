#' Generate a minimal html5 page.
#'
#' See \url{http://www.brucelawson.co.uk/2010/a-minimal-html5-document/} for
#' details.
#'
#' @param title Page title
#' @param html Other html to insert into page.
#' @keywords internal
#' @export
#' @examples
#' minimal_html("test")
minimal_html <- function(title, html = "") {
  xml2::read_html(paste0(
    "<!doctype html>\n",
    "<meta charset=utf-8>\n",
    "<title>", title, "</title>\n",
    html
  ))
}
