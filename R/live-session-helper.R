#' @noRd
LiveSessionHelper <- R6::R6Class(
  "LiveSessionHelper",
  public = list(
    #' @description
    #' Create a new LiveSessionHelper object.
    #' @param session A chromote session object.
    #' @param get_root_id A function to get the root node ID from the parent.
    initialize = function(session, get_root_id) {
      private$session <- session
      private$get_root_id <- get_root_id
    }
  ),
  private = list(
    session = NULL,
    get_root_id = NULL,

    call_node_method = function(node_id, method, ...) {
      js_fun <- paste0("function() { return this", method, "}")
      obj_id <- private$object_id(node_id)
      private$session$Runtime$callFunctionOn(js_fun, objectId = obj_id, ...)
    },

    object_id = function(node_id) {
      private$session$DOM$resolveNode(node_id)$object$objectId
    }
  )
)
