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
#' @examples
#' google_form("1M9B8DsYNFyDjpwSK6ur_bZf8Rv_04ma3rmaaBiveoUI")
google_form <- function(x) {
  xml2::read_html(httr::GET(paste0("https://docs.google.com/forms/d/", x, "/viewform")))
}

#' Generate a minimal html5 page.
#'
#' See <http://www.brucelawson.co.uk/2010/a-minimal-html5-document/> for
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
