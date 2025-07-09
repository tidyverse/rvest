#' @noRd
LiveSessionFinder <- R6::R6Class(
  "LiveSessionFinder",
  inherit = LiveSessionHelper,
  public = list(
    #' @description
    #' Wait for a selector to appear on the page.
    #' @param selector A Selector object.
    #' @param timeout Time to wait in seconds.
    wait_for_selector = function(selector, timeout = 5) {
      selector$wait_for(private$session, private$get_root_id(), timeout)
    },

    #' @description
    #' Find nodes using a given selector object.
    #' @param selector A Selector object.
    find_nodes = function(selector) {
      selector$find(private$session, private$get_root_id())
    },

    #' @description
    #' Get the outer HTML of a given node.
    #' @param node_id The ID of the node.
    get_outer_html = function(node_id) {
      json <- private$call_node_method(node_id, ".outerHTML")
      json$result$value
    }
  )
)
