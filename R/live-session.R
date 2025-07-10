#' @noRd
LiveSession <- R6::R6Class(
  "LiveSession",
  public = list(
    #' @field session Underlying [chromote::ChromoteSession] object. For expert
    #'   use only.
    session = NULL,

    #' @description initialize the object
    #' @param url Website url to read from.
    initialize = function(url) {
      self$session <- chromote::ChromoteSession$new()
      private$finder <- LiveSessionFinder$new(self$session, private$get_root_id)
      private$mouse <- LiveSessionMouse$new(self$session, private$get_root_id)
      private$keyboard <- LiveSessionKeyboard$new(self$session)

      self$session$Network$setUserAgentOverride("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36")
      self$session$go_to(url)
      private$refresh_root()
    },

    #' @description
    #' Display a live view of the site
    view = function() { # nocov start
      private$check_active()
      self$session$view()
      invisible(self)
    }, # nocov end

    #' @description
    #' Extract HTML elements from the current page.
    #' @param css,xpath CSS selector or xpath expression.
    html_elements = function(css, xpath) {
      private$check_active()

      check_exclusive(css, xpath)
      if (!missing(css)) {
        strategy <- CssSelector$new(css)
      } else {
        strategy <- XpathSelector$new(xpath)
      }
      nodes <- private$finder$find_nodes(strategy)

      # Imperative part: get the HTML strings from the browser
      elements <- map_chr(nodes, function(node_id) {
        private$finder$get_outer_html(node_id)
      })

      # Functional part: parse the strings into nodes
      parse_html_fragments(elements)
    },

    #' @description Simulate a click on an HTML element.
    click = function(css, n_clicks = 1, wait_for = NULL) {
      private$check_active()
      strategy <- CssSelector$new(css)
      node <- private$finder$wait_for_selector(strategy)
      p_wait <- private$expand_promise(wait_for)
      is_async <- !is.null(p_wait)

      private$mouse$click(node, n_clicks, is_async = is_async)

      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Get the current scroll position.
    get_scroll_position = function() {
      private$check_active()
      private$mouse$get_scroll_position()
    },

    #' @description Scroll selected element into view.
    scroll_into_view = function(css, wait_for = NULL) {
      private$check_active()
      strategy <- CssSelector$new(css)
      node <- private$finder$wait_for_selector(strategy)
      p_wait <- private$expand_promise(wait_for)
      private$mouse$scroll_into_view(node)
      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Scroll to specified location
    scroll_to = function(top = 0, left = 0, wait_for = NULL) {
      private$check_active()
      p_wait <- private$expand_promise(wait_for)
      private$mouse$scroll_to(top, left)
      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Scroll by the specified amount
    scroll_by = function(top = 0, left = 0, wait_for = NULL) {
      private$check_active()
      p_wait <- private$expand_promise(wait_for)
      private$mouse$scroll_by(top, left)
      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Type text in the selected element
    type = function(css, text, wait_for = NULL) {
      private$check_active()
      strategy <- CssSelector$new(css)
      node <- private$finder$wait_for_selector(strategy)
      p_wait <- private$expand_promise(wait_for)
      private$keyboard$type(node, text)
      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Simulate pressing a single key.
    press = function(css, key_code, modifiers = character(), wait_for = NULL) {
      private$check_active()
      strategy <- CssSelector$new(css)
      node <- private$finder$wait_for_selector(strategy)
      p_wait <- private$expand_promise(wait_for)
      private$keyboard$press(node, key_code, modifiers)
      self$wait_for(p_wait)
      invisible(self)
    },

    #' @description Wait for a promise to resolve and then sync the session
    wait_for = function(promise = NULL) {
      if (promises::is.promise(promise)) {
        self$session$wait_for(promise)
        private$refresh_root()
      }
      invisible(self)
    }
  ),
  private = list(
    finder = NULL,
    mouse = NULL,
    keyboard = NULL,
    root_id = NULL,

    finalize = function() {
      self$session$close() # nocov
    },

    get_root_id = function() {
      private$root_id
    },

    check_active = function() { # nocov start
      if (new_chromote && !self$session$is_active()) {
        suppressMessages({
          self$session <- self$session$respawn()
          private$refresh_root()
        })
      }
    }, # nocov end

    refresh_root = function(...) {
      private$root_id <- self$session$DOM$getDocument(0)$root$nodeId
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
    }
  )
)
