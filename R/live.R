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
#' sess$scroll_into_view("svg")
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
#' You construct an LiveHTML object with [read_html_live()] and can interact
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

      self$session$Network$setUserAgentOverride("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36")

      # https://github.com/rstudio/chromote/issues/102
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
    #' @param css CSS selector or xpath expression.
    #' @param n_clicks Number of clicks
    click = function(css, n_clicks = 1) {
      check_number_whole(n_clicks, min = 1)

      # Implementation based on puppeteer as described in
      # https://medium.com/@aslushnikov/automating-clicks-in-chromium-a50e7f01d3fb
      # With code from https://github.com/puppeteer/puppeteer/blob/b53de4e0942e93c/packages/puppeteer-core/src/cdp/Input.ts#L431-L459

      node <- private$wait_for_selector(css)
      self$session$DOM$scrollIntoViewIfNeeded(node)

      # Quad = location of four corners (x1, y1, x2, y2, x3, y3, x4, y4)
      # Relative to viewport
      quads <- self$session$DOM$getBoxModel(node)
      content_quad <- as.numeric(quads$model$content)
      center_x <- mean(content_quad[c(1, 3, 5, 7)])
      center_y <- mean(content_quad[c(2, 4, 6, 8)])

      # https://chromedevtools.github.io/devtools-protocol/1-3/Input/#method-dispatchMouseEvent
      self$session$Input$dispatchMouseEvent(
        type = "mouseMoved",
        x = center_x,
        y = center_y,
      )

      for (i in seq_along(n_clicks)) {
        self$session$Input$dispatchMouseEvent(
          type = "mousePressed",
          x = center_x,
          y = center_y,
          button = "left",
          clickCount = i,
        )
        self$session$Input$dispatchMouseEvent(
          type = "mouseReleased",
          x = center_x,
          y = center_y,
          clickCount = i,
          button = "left"
        )
      }
      invisible(self)
    },

    #' @description Scroll selected element into view.
    #' @param css CSS selector or xpath expression.
    scroll_into_view = function(css) {
      node <- private$wait_for_selector(css)
      self$session$DOM$scrollIntoViewIfNeeded(node)

      invisible(self)
    },

    #' @description Scroll to specified location
    #' @param top,left Number of pixels from top/left respectively.
    scroll_to = function(top = 0, left = 0) {
      check_number_whole(top)
      check_number_whole(left)

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
      check_number_whole(top)
      check_number_whole(left)

      # https://chromedevtools.github.io/devtools-protocol/1-3/Input/#method-dispatchMouseEvent
      self$session$Input$dispatchMouseEvent(
        type = "mouseWheel",
        x = 0,
        y = 0,
        deltaX = left,
        deltaY = top
      )
      invisible(self)
    },

    #' @description Type text in the selected element
    #' @param css CSS selector or xpath expression.
    #' @param text A single string containing the text to type.
    type = function(css, text) {
      check_string(text)

      node <- private$wait_for_selector(css)
      self$session$DOM$focus(node)
      self$session$Input$insertText(text)

      invisible(self)
    },

    #' @description Simulate pressing a single key (including special keys).
    #' @param css CSS selector or xpath expression. Set to `NULL`
    #' @param key_code Name of key. You can see a complete list of known
    #'   keys at <https://pptr.dev/api/puppeteer.keyinput>.
    #' @param modifiers A character vector of modifiers. Must be one or more
    #'   of `"Shift`, `"Control"`, `"Alt"`, or `"Meta"`.
    press = function(css, key_code, modifiers = character()) {
      desc <- as_key_desc(key_code, modifiers)

      node <- private$wait_for_selector(css)
      self$session$DOM$focus(node)

      exec(self$session$Input$dispatchKeyEvent, type = "keyDown", !!!desc)
      exec(self$session$Input$dispatchKeyEvent, type = "keyUp", !!!desc)

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
      cli::cli_abort("Failed to find selector {.str {css}} in {timeout} seconds.")
    },

    find_nodes = function(css, xpath) {
      check_exclusive(css, xpath)
      if (!missing(css)) {
        unlist(self$session$DOM$querySelectorAll(private$root_id, css)$nodeIds)
      } else {
        search <- glue::glue("
          (function() {{
          const xpathResult = document.evaluate('{xpath}', document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
          const nodes = [];
          for (let i = 0; i < xpathResult.snapshotLength; i++) {{
              nodes.push(xpathResult.snapshotItem(i));
          }}
          return(nodes);
          }})();
        ")

        object_id <- self$session$Runtime$evaluate(search)$result$objectId
        props <- self$session$Runtime$getProperties(object_id, ownProperties = TRUE)

        ids <- map_chr(props$result, function(prop) prop$value$objectId %||% NA_character_)
        # Drop non-nodes
        ids <- ids[!is.na(ids)]

        unlist(map(ids, self$session$DOM$requestNode), use.names = FALSE)
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
html_table.LiveHTML <- function(x,
                                    header = NA,
                                    trim = TRUE,
                                    fill = deprecated(),
                                    dec = ".",
                                    na.strings = "NA",
                                    convert = TRUE) {

  tables <- html_elements(x, "table")
  html_table(
    tables,
    header = header,
    trim = trim,
    fill = fill,
    dec = dec,
    na.strings = na.strings,
    convert = convert
  )
}
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
  testthat::skip_on_cran()

  # We try twice because in particular Windows on GHA seems to need it,
  # but it doesn't otherwise hurt. More details at
  # https://github.com/rstudio/shinytest2/issues/209
  if (!has_chromote() && !has_chromote()) {
    testthat::skip("chromote not available")
  }

  env_cache(the, "test_session", {
    read_html_live("https://rvest.tidyverse.org/articles/starwars.html")
  })
}



as_key_desc <- function(key, modifiers = character(), error_call = caller_env()) {
  check_string(key, call = error_call)
  modifiers <- arg_match(
    modifiers,
    values = c("Alt", "Control", "Meta", "Shift"),
    multiple = TRUE,
    error_call = error_call
  )

  if (!has_name(keydefs, key)) {
    cli::cli_abort("No key definition for {.str {key}}.")
  }

  def <- keydefs[[key]]
  desc <- list()

  desc$key <- def$key %||% ""
  if ("shift" %in% modifiers && has_name(def, "shiftKey")) {
    desc$key <- def$shiftKey
  }

  desc$windowsVirtualKeyCode <- def$keyCode %||% 0
  if ("shift" %in% modifiers && has_name(def, "shiftKeyCode")) {
    desc$windowsVirtualKeyCode <- def$shiftKeyCode
  }

  desc$code <- def$code %||% ""
  desc$location <- def$location %||% 0

  desc$text <- if (nchar(desc$key) == 1) def$key else def$text
  # no elements have shiftText field

  #  if any modifiers besides shift are pressed, no text should be sent
  if (any(modifiers != "Shift")) {
    desc$text <- ''
  }

  desc$modifiers <- sum(c(Alt = 1, Control = 2, Meta = 4, Shift = 8)[modifiers])
  desc
}
