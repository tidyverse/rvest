chromote_session <- function(url) {
  session <- chromote::ChromoteSession$new()

  p <- session$Page$loadEventFired(wait_ = FALSE)
  session$Page$navigate(url, wait_ = FALSE)
  session$wait_for(p)

  new_chromote_elements(
    session = session,
    nodes = root_id(session)
  )
}

new_chromote_elements <- function(session, nodes) {
  structure(
    list(session = session, nodes = nodes),
    class = "rvest_chromote_elements"
  )
}

#' @export
print.rvest_chromote_elements <- function(x, ...) {



  html <- map_element_chr(x, function(session, node_id) {
    json <- eval_method(session, node_id, ".outerHTML")
    json$result$value
  })

  cli::cat_line("<rvest_chromote_elements>")
  print(str_trunc(html, getOption("width") - 10), quote = FALSE)

  invisible(x)
}

#' @export
html_elements.rvest_chromote_elements <- function(x, css, xpath) {
  nodes <- map_element(x, function(session, node_id) {
    session$DOM$querySelectorAll(node_id, css)$nodeIds
  })
  x <- new_chromote_elements(x$session, unlist(nodes))

  elements <- map_element_chr(x, function(session, node_id) {
    json <- eval_method(session, node_id, ".outerHTML")
    json$result$value
  })
  html <- paste0("<html>", paste0(elements, collapse = "\n"), "</html>")
  xml2::xml_children(xml2::xml_children(xml2::read_html(html)))
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

map_element <- function(x, fn, ..., .default = NULL) {
  lapply(x$nodes, function(node_id) {
    if (node_id == 0) {
      .default
    } else {
      fn(x$session, node_id, ...)
    }
  })
}
map_element_chr <- function(x, fn, ..., .default = NA_character_) {
  vapply(x$nodes, function(node_id) {
    if (node_id == 0) {
      .default
    } else {
      fn(x$session, node_id, ...)
    }
  }, character(1))
}
map_element_int <- function(x, fn, ..., .default = NA_integer_) {
  vapply(x$nodes, function(node_id) {
    if (node_id == 0) {
      .default
    } else {
      fn(x$session, node_id, ...)
    }
  }, integer(1))
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
    skip("chromote not available")
  }

  env_cache(the, "test_session", {
    session <- chromote::ChromoteSession$new()

    p <- session$Page$loadEventFired(wait_ = FALSE)
    session$Page$navigate("https://rvest.tidyverse.org/articles/starwars.html", wait_ = FALSE)
    session$wait_for(p)

    session
  })
}
