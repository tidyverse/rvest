session_stub <- function() {
  list(
    DOM = list(
      querySelectorAll = function(rootId, css) {
        if (css == ".found") list(nodeIds = list(101, 102)) else list(nodeIds = list())
      },
      requestNode = function(id) {
        list(nodeId = as.integer(sub("obj-", "", id)))
      }
    ),
    Runtime = list(
      getProperties = function(objectId, ownProperties) {
        if (objectId == "xpath-result") {
          list(result = list(
            list(name = "0", value = list(objectId = "obj-201")),
            list(name = "1", value = list(objectId = "obj-202")),
            list(name = "length", value = list(value = 2))
          ))
        } else {
          list(result = list(list(name = "length", value = list(value = 0))))
        }
      }
    )
  )
}

# live-selector.R
mock_session_for_selectors <- function() {
  mock_session <- session_stub()
  mock_session$Runtime$evaluate <- function(search) {
    if (grepl("class=\\'found\\'", search, fixed = TRUE)) {
      list(result = list(objectId = "xpath-result"))
    } else {
      list(result = list(objectId = "xpath-empty-result"))
    }
  }
  mock_session
}

# live-session-finder.R
mock_session_for_finder <- function() {
  mock_session <- session_stub()
  mock_session$DOM$resolveNode <- function(node_id) {
    list(object = list(objectId = paste0("obj-", node_id)))
  }
  mock_session$Runtime$evaluate <- function(search) {
    list(result = list(objectId = "xpath-result"))
  }
  mock_session$Runtime$callFunctionOn <- function(js_fun, objectId, ...) {
    # Simulate getting outerHTML
    node_id <- sub("obj-", "", objectId)
    list(result = list(value = paste0("<p id='", node_id, "'>Content</p>")))
  }
  mock_session
}

# live-session-keyboard.R
mock_session_for_keyboard <- function() {
  log <- env(events = list())
  list(
    log = log,
    DOM = list(
      focus = function(...) {
        log$events <- c(log$events, list(list(func = "focus", args = list(...))))
      }
    ),
    Input = list(
      insertText = function(...) {
        log$events <- c(log$events, list(list(func = "insertText", args = list(...))))
      },
      dispatchKeyEvent = function(...) {
        log$events <- c(log$events, list(list(func = "dispatchKeyEvent", args = list(...))))
      }
    )
  )
}

# live-session-mouse.R
mock_session_for_mouse <- function() {
  log <- env(events = list())
  list(
    log = log,
    DOM = list(
      scrollIntoViewIfNeeded = function(...) {
        log$events <- c(log$events, list(list(func = "scrollIntoViewIfNeeded", args = list(...))))
      },
      getBoxModel = function(...) {
        # Return a dummy box model for coordinate calculation
        list(model = list(content = c(10, 10, 20, 10, 20, 20, 10, 20)))
      },
      resolveNode = function(node_id) {
        list(object = list(objectId = paste0("obj-", node_id)))
      }
    ),
    Input = list(
      dispatchMouseEvent = function(...) {
        log$events <- c(log$events, list(list(func = "dispatchMouseEvent", args = list(...))))
      }
    ),
    Runtime = list(
      evaluate = function(...) {
        list(result = list(value = list(x = 100, y = 200)))
      },
      callFunctionOn = function(...) {
        log$events <- c(log$events, list(list(func = "callFunctionOn", args = list(...))))
      }
    )
  )
}

# live-session.R
MockFinder <- R6::R6Class(
  "MockFinder",
  public = list(
    log = NULL,
    get_root_id = NULL,
    initialize = function(session, get_root_id) {
      self$log <- env(calls = list())
      self$get_root_id <- get_root_id
    },
    wait_for_selector = function(...) {
      self$get_root_id()
      self$log$calls <- c(self$log$calls, "wait_for_selector")
      101
    },
    find_nodes = function(...) {
      self$get_root_id()
      self$log$calls <- c(self$log$calls, "find_nodes")
      list(201, 202)
    },
    get_outer_html = function(id) {
      paste0("<p>", id, "</p>")
    }
  )
)

MockMouse <- R6::R6Class(
  "MockMouse",
  public = list(
    log = NULL,
    initialize = function(...) {
      self$log <- env(calls = list())
    },
    click = function(...) {
      self$log$calls <- c(self$log$calls, "click")
    },
    get_scroll_position = function() {
      self$log$calls <- c(self$log$calls, "get_scroll_position")
      list(x = 123, y = 456)
    },
    scroll_into_view = function(...) {
      self$log$calls <- c(self$log$calls, "scroll_into_view")
    },
    scroll_to = function(...) {
      self$log$calls <- c(self$log$calls, "scroll_to")
    },
    scroll_by = function(...) {
      self$log$calls <- c(self$log$calls, "scroll_by")
    }
  )
)

MockKeyboard <- R6::R6Class(
  "MockKeyboard",
  public = list(
    log = NULL,
    initialize = function(...) {
      self$log <- env(calls = list())
    },
    type = function(...) {
      self$log$calls <- c(self$log$calls, "type")
    },
    press = function(...) {
      self$log$calls <- c(self$log$calls, "press")
    }
  )
)

MockChromoteSession <- R6::R6Class(
  "MockChromoteSession",
  public = list(
    initialize = function(...) {},
    go_to = function(...) {},
    Network = list(setUserAgentOverride = function(...) {}),
    DOM = list(getDocument = function(...) list(root = list(nodeId = 1))),
    close = function() {},
    is_active = function() TRUE,
    wait_for = function() {},
    Page = list(loadEventFired = function(...) promises::promise(function(resolve, reject) resolve(TRUE)))
  )
)
