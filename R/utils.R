map_chr <- function(.x, .f, ...) {
  vapply(.x, .f, ..., FUN.VALUE = character(1), USE.NAMES = FALSE)
}
map_lgl <- function(.x, .f, ...) {
  vapply(.x, .f, ..., FUN.VALUE = logical(1), USE.NAMES = FALSE)
}

str_trunc <- function(x, width) {
  if (nchar(x) <= width) {
    x
  } else {
    paste0(substr(x, 1, width - 3), "...")
  }
}

#' Make link to google form given id
#'
#' @param x Unique identifier for form
#' @export
#' @keywords internal
google_form <- function(x) {
  xml2::read_html(httr::GET(paste0("https://docs.google.com/forms/d/", x, "/viewform")))
}

#' Create an HTML document from inline HTML
#'
#' @param html HTML contents of page.
#' @param title Page title (required by HTML spec).
#' @keywords internal
#' @export
#' @examples
#' minimal_html("<p>test</p>")
minimal_html <- function(html, title = "") {
  # From http://www.brucelawson.co.uk/2010/a-minimal-html5-document/
  xml2::read_html(paste0(
    "<!doctype html>\n",
    "<meta charset=utf-8>\n",
    "<title>", title, "</title>\n",
    html
  ))
}

cat_line <- function(...) {
  cat(paste0(..., "\n", collapse = ""))
}


env_cache <- function(env, nm, value, inherit = FALSE) {
  if (env_has(env, nm, inherit = inherit)) {
    env_get(env, nm, inherit = TRUE)
  } else {
    env_poke(env, nm, value)
    value
  }
}

inspect <- function(x) {
  path <- tempfile(fileext = ".html")
  writeLines(as.character(x), path)
  utils::browseURL(path)
}
