#' @noRd
LiveSessionMouse <- R6::R6Class(
  "LiveSessionMouse",
  inherit = LiveSessionHelper,
  public = list(
    #' @description Simulate a click on an HTML element.
    #' @param node Node to click.
    #' @param n_clicks Number of clicks.
    #' @param is_async Is the subsequent operation asynchronous?
    click = function(node, n_clicks = 1, is_async = FALSE) {
      check_number_whole(n_clicks, min = 1)
      private$session$DOM$scrollIntoViewIfNeeded(node)

      center <- private$get_element_center(node)
      private$dispatch_click_sequence(center, n_clicks, is_async)
    },

    #' @description Get the current scroll position.
    get_scroll_position = function() {
      out <- private$session$Runtime$evaluate(
        '({ x: window.scrollX, y: window.scrollY })',
        returnByValue = TRUE
      )
      out$result$value
    },

    #' @description Scroll selected element into view.
    #' @param node Node to scroll into view.
    scroll_into_view = function(node) {
      private$session$DOM$scrollIntoViewIfNeeded(node)
    },

    #' @description Scroll to specified location
    #' @param top,left Number of pixels from top/left respectively.
    scroll_to = function(top = 0, left = 0) {
      check_number_whole(top)
      check_number_whole(left)
      # https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollTo
      private$call_node_method(
        private$get_root_id(),
        paste0(".documentElement.scrollTo(", left, ", ", top, ")")
      )
    },

    #' @description Scroll by the specified amount
    #' @param top,left Number of pixels to scroll up/down and left/right.
    scroll_by = function(top = 0, left = 0) {
      check_number_whole(top)
      check_number_whole(left)
      private$dispatch_mouse_event(
        type = "mouseWheel",
        x = 0,
        y = 0,
        deltaX = left,
        deltaY = top
      )
    }
  ),
  private = list(
    dispatch_mouse_event = function(...) {
      private$session$Input$dispatchMouseEvent(...)
    },

    get_element_center = function(node) {
      quads <- private$session$DOM$getBoxModel(node)
      content_quad <- as.numeric(quads$model$content)
      list(
        x = mean(content_quad[c(1, 3, 5, 7)]),
        y = mean(content_quad[c(2, 4, 6, 8)])
      )
    },

    dispatch_click_sequence = function(center, n_clicks, is_async) {
      private$dispatch_mouse_event(
        type = "mouseMoved",
        x = center$x,
        y = center$y,
        wait_ = !is_async
      )
      for (i in seq_len(n_clicks)) {
        private$dispatch_mouse_event(
          type = "mousePressed",
          x = center$x,
          y = center$y,
          button = "left",
          clickCount = i,
          wait_ = !is_async
        )
        private$dispatch_mouse_event(
          type = "mouseReleased",
          x = center$x,
          y = center$y,
          clickCount = i,
          button = "left",
          wait_ = !is_async
        )
      }
    }
  )
)
