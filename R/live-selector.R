#' Selector Classes
#'
#' These R6 classes encapsulate the logic for finding elements using a specific
#' strategy (e.g., CSS selectors or XPath expressions). This is an internal
#' implementation of the "Strategy" design pattern.
#'
#' @field selector A character string holding the selector (e.g., ".foo" or
#'   "//p").
#' @noRd
Selector <- R6::R6Class(
  "Selector",
  public = list(
    selector = NULL,
    initialize = function(selector) {
      self$selector <- selector
    },
    #' @description Find nodes using the specific strategy.
    #' @param session A chromote session object.
    #' @param root_id The root node ID to search from.
    find = function(session, root_id) {
      cli::cli_abort(
        "This method must be implemented by a subclass.",
        class = "interface_not_implemented"
      )
    },
    #' @description Wait for nodes to appear on the page.
    #' @param session A chromote session object.
    #' @param root_id The root node ID to search from.
    #' @param timeout Time to wait in seconds.
    wait_for = function(session, root_id, timeout = 5) {
      done <- now() + timeout
      while (now() < done) {
        nodes <- self$find(session, root_id)
        if (length(nodes) > 0) {
          return(nodes)
        }
        Sys.sleep(0.1)
      }
      cli::cli_abort("Failed to find selector {.str {self$selector}} in {timeout} seconds.")
    }
  )
)

CssSelector <- R6::R6Class(
  "CssSelector",
  inherit = Selector,
  public = list(
    find = function(session, root_id, retry = TRUE) {
      try_fetch(
        unlist(session$DOM$querySelectorAll(root_id, self$selector)$nodeIds),
        error = function(cnd) {
          if (retry) {
            Sys.sleep(0.1)
            # The parent session is responsible for refreshing the root
            self$find(session, root_id, retry = FALSE)
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
    }
  )
)

XpathSelector <- R6::R6Class(
  "XpathSelector",
  inherit = Selector,
  public = list(
    find = function(session, root_id, retry = TRUE) {
      try_fetch(
        {
          search <- create_xpath_finder_js(self$selector)
          object_id <- session$Runtime$evaluate(search)$result$objectId
          props <- session$Runtime$getProperties(object_id, ownProperties = TRUE)

          ids <- map_chr(props$result, function(prop) prop$value$objectId %||% NA_character_)
          ids <- ids[!is.na(ids)]

          unlist(map(ids, session$DOM$requestNode), use.names = FALSE)
        },
        error = function(cnd) {
          if (retry) {
            Sys.sleep(0.1)
            # The parent session is responsible for refreshing the root
            self$find(session, root_id, retry = FALSE)
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
    }
  )
)
