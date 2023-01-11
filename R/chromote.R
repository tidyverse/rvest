#' Dynamic web scraping with chromote
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [read_html()] operates of the HTML source code downloaded from the server.
#' This works for most websites but can fail if the site uses javascript to
#' generate the HTML. `chromote_session()` provides an alternative interface
#' that runs a real webserver in the background. This allows you to access
#' elements of the HTML page that are generated dynamically by javascript,
#' and to interact to (e.g.) click on buttons or fill in forms.
#'
#' Behind the scenes, this function uses the
#' [chromote](https://rstudio.github.io/chromote) package, which requires that
#' you have a copy of [Google Chrome](https://www.google.com/chrome/) installed
#' on your machine.
#'
#' @param url Website url to read from.
#' @export
#' @examples
#' sess <- chromote_session("https://hadley.nz")
#' sess |> html_elements("p")
#' sess |> html_element("xyz")
#' sess |> html_element("p")
#'
#' \dontshow{
#' # Hack to avoid R CMD check error
#' closeAllConnections()
#' }
chromote_session <- function(url) {
  session <- chromote::ChromoteSession$new()

  p <- session$Page$loadEventFired(wait_ = FALSE)
  session$Page$navigate(url, wait_ = FALSE)
  session$wait_for(p)

  structure(
    list(
      session = session,
      root = root_id(session)
    ),
    class = "rvest_chromote_session"
  )
}

#' @export
html_elements.rvest_chromote_session <- function(x, css, xpath) {
  check_no_xpath(xpath)
  nodes <- x$session$DOM$querySelectorAll(x$root, css)$nodeIds

  elements <- map_chr(nodes, function(node_id) {
    json <- eval_method(x$session, node_id, ".outerHTML")
    json$result$value
  })
  html <- paste0("<html>", paste0(elements, collapse = "\n"), "</html>")
  xml2::xml_children(xml2::xml_children(xml2::read_html(html)))
}

#' @export
html_element.rvest_chromote_session <- function(x, css, xpath) {
  check_no_xpath(xpath)

  out <- html_elements(x, css)
  if (length(out) == 0) {
    xml2::xml_missing()
  } else {
    out[[1]]
  }
}

#' @export
print.rvest_chromote_session <- function(x, ...) {
  print(html_elements(x, "html"))
  invisible()
}

# helpers -----------------------------------------------------------------

root_id <- function(x) {
  x$DOM$getDocument()$root$nodeId
}

check_no_xpath <- function(xpath) {
  if (!is_missing(xpath)) {
    cli::cli_abort("{.arg xpath} is not supported by <ChromoteSession>.")
  }
}

# Inspired by https://github.com/rstudio/shinytest2/blob/v1/R/chromote-methods.R
eval_method <- function(session, node_id, method, ..., .default = NULL) {
  js_fun <- paste0("function() { return this", method, "}")

  # https://chromedevtools.github.io/devtools-protocol/tot/DOM/#method-resolveNode
  obj_id <- session$DOM$resolveNode(node_id)$object$objectId
  # https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-callFunctionOn
  session$Runtime$callFunctionOn(js_fun, objectId = obj_id, ...)
}

has_chromote <- function() {
  tryCatch(
    {
      default <- chromote::default_chromote_object()
      local_bindings(default_timeout = 5, .env = default)
      startup <- default$new_session(wait_ = FALSE)
      default$wait_for(startup)
      TRUE
    },
    error = function(cnd) {
      FALSE
    }
  )
}

test_session <- function() {
  if (!is_interactive()) testthat::skip_on_cran()

  # We try twice because in particular Windows on GHA seems to need it,
  # but it doesn't otherwise hurt. More details at
  # https://github.com/rstudio/shinytest2/issues/209
  if (!has_chromote() && !has_chromote()) {
    testthat::skip("chromote not available")
  }

  env_cache(the, "test_session", {
    chromote_session("https://rvest.tidyverse.org/articles/starwars.html")
  })
}
