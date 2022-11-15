new_chromote_elements <- function(session, nodes) {
  structure(
    list(session = session, nodes = nodes),
    class = "rvest_chromote_elements"
  )
}
#' @export
`[.rvest_chromote_elements` <- function(x, i) {
  new_chromote_elements(x$session, x$nodes[i])
}
#' @export
`[[.rvest_chromote_elements` <- function(x, i) {
  new_chromote_elements(x$session, x$nodes[[i]])
}
#' @export
length.rvest_chromote_elements <- function(x) {
  length(x$nodes)
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
html_elements.ChromoteSession <- function(x, css, xpath) {
  check_no_xpath(xpath)

  nodes <- x$DOM$querySelectorAll(root_id(x), css)
  new_chromote_elements(x, unlist(nodes$nodeIds))
}

#' @export
html_element.ChromoteSession <- function(x, css, xpath) {
  check_no_xpath(xpath)

  node <- x$DOM$querySelector(root_id(x), css)
  new_chromote_elements(x, unlist(node$nodeId))
}

#' @export
html_elements.rvest_chromote_elements <- function(x, css, xpath) {
  check_no_xpath(xpath)

  nodes <- map_element(x, function(session, node_id) {
    session$DOM$querySelectorAll(node_id, css)$nodeIds
  })

  new_chromote_elements(x$session, unlist(nodes))
}

#' @export
html_element.rvest_chromote_elements <- function(x, css, xpath) {
  check_no_xpath(xpath)

  nodes <- map_element_int(x, function(session, node_id) {
    session$DOM$querySelector(node_id, css)$nodeId
  })
  new_chromote_elements(x$session, nodes)
}

#' @export
xml_attrs.rvest_chromote_elements <- function(x) {
  map_element(x, function(session, node_id) {
    # https://chromedevtools.github.io/devtools-protocol/tot/DOM/#method-getAttributes
    attr <- session$DOM$getAttributes(node_id)$attributes
    if (length(attr) > 0) {
      odd <- seq(1, length(attr) - 1, by = 2)
      setNames(unlist(attr[odd + 1]), attr[odd])
    } else {
      character()
    }
  })
}

#' @export
xml_attr.rvest_chromote_elements <- function(x, name, default = NA_character_) {
  attrs <- xml_attrs(x)
  vapply(attrs, function(attrs) {
    if (has_name(attrs, name)) attrs[[name]] else default
  }, character(1))
}

#' @export
xml_text.rvest_chromote_elements <- function(x, trim = TRUE) {
  map_element_chr(x, function(session, node_id) {
    json <- eval_method(session, node_id, ".innerText")
    json$result$value
  })
}
#' @export
html_text2.rvest_chromote_elements <- function(x, preserve_nbsp = TRUE) {
  xml_text.rvest_chromote_elements(x)
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

test_session <- function() {
  if (!is_interactive()) testthat::skip_on_cran()

  env_cache(the, "test_session", {
    session <- chromote::ChromoteSession$new()

    p <- session$Page$loadEventFired(wait_ = FALSE)
    session$Page$navigate("https://rvest.tidyverse.org/articles/starwars.html", wait_ = FALSE)
    session$wait_for(p)

    session
  })
}
