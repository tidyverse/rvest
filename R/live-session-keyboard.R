#' @noRd
LiveSessionKeyboard <- R6::R6Class(
  "LiveSessionKeyboard",
  public = list(
    #' @description
    #' Create a new LiveSessionKeyboard object.
    #' @param session A chromote session object.
    initialize = function(session) {
      private$session <- session
    },

    #' @description Type text in the selected element
    #' @param node Node to type in.
    #' @param text A single string containing the text to type.
    type = function(node, text) {
      check_string(text)
      private$session$DOM$focus(node)
      private$session$Input$insertText(text)
    },

    #' @description Simulate pressing a single key (including special keys).
    #' @param node Node to focus.
    #' @param key_code Name of key.
    #' @param modifiers A character vector of modifiers.
    press = function(node, key_code, modifiers = character()) {
      desc <- as_key_desc(key_code, modifiers)
      private$session$DOM$focus(node)
      exec(private$session$Input$dispatchKeyEvent, type = "keyDown", !!!desc)
      exec(private$session$Input$dispatchKeyEvent, type = "keyUp", !!!desc)
    }
  ),
  private = list(
    session = NULL
  )
)
