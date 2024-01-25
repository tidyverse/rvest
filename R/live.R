#' Live web scraping (with chromote)
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [read_html()] operates of the HTML source code downloaded from the server.
#' This works for most websites but can fail if the site uses javascript to
#' generate the HTML. `read_html_live()` provides an alternative interface
#' that runs a live web browser in the background. This allows you to access
#' elements of the HTML page that are generated dynamically by javascript
#' and to interact to with the live page by clicking on buttons or typing in
#' forms.
#'
#' Behind the scenes, this function uses the
#' [chromote](https://rstudio.github.io/chromote) package, which requires that
#' you have a copy of [Google Chrome](https://www.google.com/chrome/) installed
#' on your machine.
#'
#' @return `read_html_live()` returns an R6 [LiveHTML] object. You can interact
#'   with it using the usual rvest functions and you can also call methods on
#'   it like `$click()`, `$scroll_to()`, to interact with the live page like
#'   a human would.
#' @param url Website url to read from.
#' @export
#' @examples
#' sess <- read_html_live("https://hadley.nz")
#' sess |> html_elements("p")
#' sess |> html_element("xyz")
#' sess |> html_element("p")
#'
#' \dontrun{
#' sess <- read_html_live("https://www.bodybuilding.com/exercises/finder")
#' sess |> html_elements(".ExResult-row") |> length()
#' sess$click(".ExLoadMore-btn")
#' sess |> html_elements(".ExResult-row") |> length()
#' sess$click(".ExLoadMore-btn")
#' sess |> html_elements(".ExResult-row") |> length()
#'
#' sess <- read_html_live("https://www.forbes.com/top-colleges/")
#' sess$view()
#' sess$scroll_by(1000)
#' sess$scroll_by(1000)
#' sess$scroll_to(0)
#' sess$scroll_to(0)
#' sess$scroll_in_to_view("svg")
#' }
#'
#' \dontshow{
#' # Hack to suppress R CMD check error about connections
#' Sys.setenv("_R_CHECK_CONNECTIONS_LEFT_OPEN_" = "FALSE")
#' }
read_html_live <- function(url) {
  check_installed(c("chromote", "R6"))
  LiveHTML$new(url)
}

#' LiveHTML, an R6 class
#'
#' @description
#' You construct an LiveHTML object with [read_live_html()] and can interact
#' with it using the methods described below. When debugging a scraping script
#' it is particularly useful to use `$view()`, which will open a live preview
#' of the site.
#'
#' @export
LiveHTML <- R6::R6Class(
  "LiveHTML",
  public = list(
    #' @field session Underlying chromote session object. For expert use only.
    session = NULL,

    #' @description initialize the object
    #' @param url URL to page.
    initialize = function(url) {
      check_installed("chromote")
      self$session <- chromote::ChromoteSession$new()

      p <- self$session$Page$loadEventFired(wait_ = FALSE)
      self$session$Page$navigate(url, wait_ = FALSE)
      self$session$wait_for(p)

      private$root_id <- self$session$DOM$getDocument(0)$root$nodeId
    },

    #' @description Called when `print()`ed
    #' @param ... Ignored
    print = function(...) {
      print(html_elements(self, "html"))
      invisible(self)
    },

    #' @description
    #' Display a live view of the site
    view = function() {
      self$session$view()
      invisible(self)
    },

    #' @description
    #' Extract HTML elements from the current page.
    #' @param css,xpath CSS selector or xpath expression.
    html_elements = function(css, xpath) {
      nodes <- private$find_nodes(css, xpath)

      elements <- map_chr(nodes, function(node_id) {
        json <- private$call_node_method(node_id, ".outerHTML")
        json$result$value
      })
      html <- paste0("<html>", paste0(elements, collapse = "\n"), "</html>")
      xml2::xml_children(xml2::xml_children(xml2::read_html(html)))
    },

    #' @description Simulate a click on an HTML element.
    #' @param css,xpath CSS selector or xpath expression.
    click = function(css) {
      private$call_method(css, ".click()")
      invisible(self)
    },

    #' @description Simulate a double click on an HTML element.
    #' @param css,xpath CSS selector or xpath expression.
    double_click = function(css) {
      private$call_method(css, ".dblclick()")
      invisible(self)
    },

    #' @description Scroll selected element into view.
    #' @param css,xpath CSS selector or xpath expression.
    #' @param edge Scroll to top or bottom of element?
    scroll_in_to_view = function(css, edge = c("top", "bottom")) {
      edge <- arg_match(edge)

      node <- private$wait_for_selector(css)
      # https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollIntoView
      if (edge == "top") {
        private$call_node_method(node, ".scrollIntoView(true)")
      } else {
        private$call_node_method(node, ".scrollIntoView(false)")
      }
      invisible(self)
    },

    #' @description Scroll to specified location
    #' @param top,left Number of pixels from top/left respectively.
    scroll_to = function(top = 0, left = 0) {
      # https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollTo
      private$call_node_method(
        private$root_id,
        paste0(".documentElement.scrollTo(", left, ", ", top, ")")
      )
      invisible(self)
    },

    #' @description Scroll by the specified amount
    #' @param top,left Number of pixels to scroll up/down and left/right
    #'   respectively.
    scroll_by = function(top = 0, left = 0) {
      # https://chromedevtools.github.io/devtools-protocol/1-3/Input/#method-dispatchMouseEvent
      self$session$Input$dispatchMouseEvent(
        type = "mouseWheel",
        x = 0,
        y = 0,
        deltaX = left,
        deltaY = top
      )
      invisible(self)
    }
  ),

  private = list(
    root_id = NULL,

    call_method = function(css, code) {
      nodes <- private$wait_for_selector(css)
      for (node in nodes) {
        private$call_node_method(node, code)
      }
      invisible(self)
    },

    wait_for_selector = function(css, timeout = 5) {
      done <- now() + timeout
      while(now() < done) {
        nodes <- private$find_nodes(css)
        if (length(nodes) > 0) {
          return(nodes)
        }

        Sys.sleep(0.1)
      }
      cli::cli_abort("Failed to find selector {.str css} in {timeout} seconds.")
    },

    find_nodes = function(css, xpath) {
      check_exclusive(css, xpath)
      if (!missing(css)) {
        unlist(self$session$DOM$querySelectorAll(private$root_id, css)$nodeIds)
      } else {
        cli::cli_abort("{.arg xpath} is not supported by <ChromoteSession>.")
      }
    },

    # Inspired by https://github.com/rstudio/shinytest2/blob/v1/R/chromote-methods.R
    call_node_method = function(node_id, method, ...) {
      js_fun <- paste0("function() { return this", method, "}")
      obj_id <- private$object_id(node_id)
      # https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-callFunctionOn
      self$session$Runtime$callFunctionOn(js_fun, objectId = obj_id, ...)
    },

    object_id = function(node_id) {
      # https://chromedevtools.github.io/devtools-protocol/tot/DOM/#method-resolveNode
      self$session$DOM$resolveNode(node_id)$object$objectId
    }
  )
)

now <- function() proc.time()[[3]]

#' @export
html_elements.LiveHTML <- function(x, css, xpath) {
  x$html_elements(css, xpath)
}

#' @export
html_element.LiveHTML <- function(x, css, xpath) {
  out <- html_elements(x, css, xpath)
  if (length(out) == 0) {
    xml2::xml_missing()
  } else {
    out[[1]]
  }
}

# helpers -----------------------------------------------------------------

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
