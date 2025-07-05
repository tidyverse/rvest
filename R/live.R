#' Live web scraping (with chromote)
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [read_html()] operates on the HTML source code downloaded from the server.
#' This works for most websites but can fail if the site uses javascript to
#' generate the HTML. `read_html_live()` provides an alternative interface
#' that runs a live web browser (Chrome) in the background. This allows you to
#' access elements of the HTML page that are generated dynamically by javascript
#' and to interact with the live page by clicking on buttons or typing in
#' forms.
#'
#' Behind the scenes, this function uses the
#' [chromote](https://rstudio.github.io/chromote/) package, which requires that
#' you have a copy of [Google Chrome](https://www.google.com/chrome/) installed
#' on your machine.
#'
#' @return `read_html_live()` returns an R6 [LiveHTML] object. You can interact
#'   with this object using the usual rvest functions, or call its methods,
#'   like `$click()`, `$scroll_to()`, and `$type()` to interact with the live
#'   page like a human would.
#' @param url Website url to read from.
#' @export
#' @examples
#' \dontrun{
#' # When we retrieve the raw HTML for this site, it doesn't contain the
#' # data we're interested in:
#' static <- read_html("https://www.forbes.com/top-colleges/")
#' static %>% html_elements(".TopColleges2023_tableRow__BYOSU")
#'
#' # Instead, we need to run the site in a real web browser, causing it to
#' # download a JSON file and then dynamically generate the html:
#'
#' sess <- read_html_live("https://www.forbes.com/top-colleges/")
#' sess$view()
#' rows <- sess %>% html_elements(".TopColleges2023_tableRow__BYOSU")
#' rows %>% html_element(".TopColleges2023_organizationName__J1lEV") %>% html_text()
#' rows %>% html_element(".grant-aid") %>% html_text()
#' }
read_html_live <- function(url) {
  check_installed(c("chromote", "R6"))
  LiveHTML$new(url)
}

#' Interact with a live web page
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' You construct an LiveHTML object with [read_html_live()] and then interact,
#' like you're a human, using the methods described below. When debugging a
#' scraping script it is particularly useful to use `$view()`, which will open
#' a live preview of the site, and you can actually see each of the operations
#' performed on the real site.
#'
#' rvest provides relatively simple methods for scrolling, typing, and
#' clicking. For richer interaction, you probably want to use a package
#' that exposes a more powerful user interface, like
#' [selendir](https://ashbythorpe.github.io/selenider/).
#'
#' @export
#' @examples
#' \dontrun{
#' # To retrieve data for this paginated site, we need to repeatedly push
#' # the "Load More" button
#' sess <- read_html_live("https://www.bodybuilding.com/exercises/finder")
#' sess$view()
#'
#' sess %>% html_elements(".ExResult-row") %>% length()
#' sess$click(".ExLoadMore-btn")
#' sess %>% html_elements(".ExResult-row") %>% length()
#' sess$click(".ExLoadMore-btn")
#' sess %>% html_elements(".ExResult-row") %>% length()
#' }
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
      self$session$go_to(url)
      private$refresh_root()
    },

    #' @description Called when `print()`ed
    #' @param ... Ignored
    print = function(...) {
      print(self$html_elements("html > *"))
      invisible(self)
    },

    #' @description
    #' Display a live view of the site
    view = function() {
      private$check_active()
      self$session$view()
      invisible(self)
    },

    #' @description
    #' Extract HTML elements from the current page.
    #' @param css,xpath CSS selector or xpath expression.
    html_elements = function(css, xpath) {
      private$check_active()
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
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    click = function(css, n_clicks = 1, wait_for = NULL) {
      private$check_active()
      check_number_whole(n_clicks, min = 1)

      node <- private$wait_for_selector(css)
      self$session$DOM$scrollIntoViewIfNeeded(node)

      quads <- self$session$DOM$getBoxModel(node)
      content_quad <- as.numeric(quads$model$content)
      center_x <- mean(content_quad[c(1, 3, 5, 7)])
      center_y <- mean(content_quad[c(2, 4, 6, 8)])

      p_wait <- private$expand_promise(wait_for)
      is_async <- !is.null(p_wait)

      self$session$Input$dispatchMouseEvent(
        type = "mouseMoved",
        x = center_x,
        y = center_y,
        wait_ = !is_async
      )
      for (i in seq_len(n_clicks)) {
        self$session$Input$dispatchMouseEvent(
          type = "mousePressed",
          x = center_x,
          y = center_y,
          button = "left",
          clickCount = i,
          wait_ = !is_async
        )
        self$session$Input$dispatchMouseEvent(
          type = "mouseReleased",
          x = center_x,
          y = center_y,
          clickCount = i,
          button = "left",
          wait_ = !is_async
        )
      }

      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Get the current scroll position.
    get_scroll_position = function() {
      private$check_active()
      out <- self$session$Runtime$evaluate(
        '({ x: window.scrollX, y: window.scrollY })',
        returnByValue = TRUE
      )
      out$result$value
    },

    #' @description Scroll selected element into view.
    #' @param css CSS selector or xpath expression.
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    scroll_into_view = function(css, wait_for = NULL) {
      private$check_active()
      node <- private$wait_for_selector(css)
      p_wait <- private$expand_promise(wait_for)
      self$session$DOM$scrollIntoViewIfNeeded(node)
      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Scroll to specified location
    #' @param top,left Number of pixels from top/left respectively.
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    scroll_to = function(top = 0, left = 0, wait_for = NULL) {
      private$check_active()
      check_number_whole(top)
      check_number_whole(left)
      p_wait <- private$expand_promise(wait_for)
      # https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollTo
      private$call_node_method(
        private$root_id,
        paste0(".documentElement.scrollTo(", left, ", ", top, ")")
      )
      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Scroll by the specified amount
    #' @param top,left Number of pixels to scroll up/down and left/right
    #'   respectively.
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    scroll_by = function(top = 0, left = 0, wait_for = NULL) {
      private$check_active()
      check_number_whole(top)
      check_number_whole(left)
      p_wait <- private$expand_promise(wait_for)
      # https://chromedevtools.github.io/devtools-protocol/1-3/Input/#method-dispatchMouseEvent
      self$session$Input$dispatchMouseEvent(
        type = "mouseWheel",
        x = 0,
        y = 0,
        deltaX = left,
        deltaY = top
      )
      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Type text in the selected element
    #' @param css CSS selector or xpath expression.
    #' @param text A single string containing the text to type.
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    type = function(css, text, wait_for = NULL) {
      private$check_active()
      check_string(text)
      node <- private$wait_for_selector(css)
      p_wait <- private$expand_promise(wait_for)
      self$session$DOM$focus(node)
      self$session$Input$insertText(text)
      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Simulate pressing a single key (including special keys).
    #' @param css CSS selector or xpath expression. Set to `NULL`
    #' @param key_code Name of key. You can see a complete list of known
    #'   keys at <https://pptr.dev/api/puppeteer.keyinput/>.
    #' @param modifiers A character vector of modifiers. Must be one or more
    #'   of `"Shift`, `"Control"`, `"Alt"`, or `"Meta"`.
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    press = function(css, key_code, modifiers = character(), wait_for = NULL) {
      private$check_active()
      desc <- as_key_desc(key_code, modifiers)
      node <- private$wait_for_selector(css)
      p_wait <- private$expand_promise(wait_for)
      self$session$DOM$focus(node)
      exec(self$session$Input$dispatchKeyEvent, type = "keyDown", !!!desc)
      exec(self$session$Input$dispatchKeyEvent, type = "keyUp", !!!desc)
      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Wait for a promise to resolve and then sync the session
    #' @param promise A promise object to wait for. If `NULL`, the method
    #'   returns immediately.
    wait_for = function(promise = NULL) {
      if (promises::is.promise(promise)) {
        self$session$wait_for(promise)
        private$refresh_root()
      }
      invisible(self)
    }
  ),

  private = list(
    root_id = NULL,

    finalize = function() {
      self$session$close()
    },

    check_active = function() {
      if (new_chromote && !self$session$is_active()) {
        suppressMessages({
          self$session <- self$session$respawn()
          private$refresh_root()
        })
      }
    },

    wait_for_selector = function(css, timeout = 5) {
      done <- now() + timeout
      while (now() < done) {
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
        private$find_nodes_css(css)
      } else {
        private$find_nodes_xpath(xpath)
      }
    },

    find_nodes_css = function(css, retry = TRUE) {
      try_fetch(
        unlist(self$session$DOM$querySelectorAll(private$root_id, css)$nodeIds),
        error = function(cnd) {
          if (retry) {
            Sys.sleep(0.1)
            private$refresh_root()
            private$find_nodes_css(css, retry = FALSE)
          } else {
            cli::cli_abort(
              c(
                "Failed to find selector.",
                "i" = "The page may have changed after your last action.",
                "*" = "Try using `wait_for = \"load\"` in the action that caused the navigation."
              ),
              parent = cnd
            )
          }
        }
      )
    },

    find_nodes_xpath = function(xpath, retry = TRUE) {
      try_fetch(
        {
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
        },
        error = function(cnd) {
          if (retry) {
            Sys.sleep(0.1)
            private$refresh_root()
            private$find_nodes_xpath(xpath, retry = FALSE)
          } else {
            cli::cli_abort(
              c(
                "Failed to find xpath.",
                "i" = "The page may have changed after your last action.",
                "*" = "Try using `wait_for = \"load\"` in the action that caused the navigation."
              ),
              parent = cnd
            )
          }
        }
      )
    },

    # To support more `wait_for` keywords, add them here.
    expand_promise = function(wait_for = NULL) {
      if (identical(wait_for, "load")) {
        self$session$Page$loadEventFired(wait_ = FALSE)
      } else if (promises::is.promise(wait_for)) {
        wait_for
      } else {
        NULL
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
    },

    refresh_root = function(...) {
      private$root_id <- self$session$DOM$getDocument(0)$root$nodeId
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
  if ("Shift" %in% modifiers && has_name(def, "shiftKey")) {
    desc$key <- def$shiftKey
  }

  desc$windowsVirtualKeyCode <- def$keyCode %||% 0
  if ("Shift" %in% modifiers && has_name(def, "shiftKeyCode")) {
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
