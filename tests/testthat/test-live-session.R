test_that("LiveSession orchestrates click", {
  local_mocked_bindings(
    LiveSessionFinder = MockFinder,
    LiveSessionMouse = MockMouse,
    LiveSessionKeyboard = MockKeyboard
  )
  local_mocked_bindings(
    ChromoteSession = MockChromoteSession,
    .package = "chromote"
  )
  live_session <- LiveSession$new("ignored-url")

  live_session$click(".btn")
  expect_true("wait_for_selector" %in% live_session$.__enclos_env__$private$finder$log$calls)
  expect_true("click" %in% live_session$.__enclos_env__$private$mouse$log$calls)
})

test_that("LiveSession orchestrates html_elements with css", {
  local_mocked_bindings(
    LiveSessionFinder = MockFinder,
    LiveSessionMouse = MockMouse,
    LiveSessionKeyboard = MockKeyboard
  )
  local_mocked_bindings(
    ChromoteSession = MockChromoteSession,
    .package = "chromote"
  )
  live_session <- LiveSession$new("ignored-url")

  nodes <- live_session$html_elements(css = "p")
  expect_true("find_nodes" %in% live_session$.__enclos_env__$private$finder$log$calls)
  expect_s3_class(nodes, "xml_nodeset")
  expect_equal(xml2::xml_text(nodes), c("201", "202"))
})

test_that("LiveSession orchestrates html_elements with xpath", {
  local_mocked_bindings(
    LiveSessionFinder = MockFinder,
    LiveSessionMouse = MockMouse,
    LiveSessionKeyboard = MockKeyboard
  )
  local_mocked_bindings(
    ChromoteSession = MockChromoteSession,
    .package = "chromote"
  )
  live_session <- LiveSession$new("ignored-url")

  nodes <- live_session$html_elements(xpath = "//p")
  expect_true("find_nodes" %in% live_session$.__enclos_env__$private$finder$log$calls)
  expect_s3_class(nodes, "xml_nodeset")
  expect_equal(xml2::xml_text(nodes), c("201", "202"))
})


test_that("LiveSession orchestrates type", {
  local_mocked_bindings(
    LiveSessionFinder = MockFinder,
    LiveSessionMouse = MockMouse,
    LiveSessionKeyboard = MockKeyboard
  )
  local_mocked_bindings(
    ChromoteSession = MockChromoteSession,
    .package = "chromote"
  )
  live_session <- LiveSession$new("ignored-url")

  live_session$type("input", "text")
  expect_true("wait_for_selector" %in% live_session$.__enclos_env__$private$finder$log$calls)
  expect_true("type" %in% live_session$.__enclos_env__$private$keyboard$log$calls)
})

test_that("LiveSession orchestrates get_scroll_position", {
  local_mocked_bindings(
    LiveSessionFinder = MockFinder,
    LiveSessionMouse = MockMouse,
    LiveSessionKeyboard = MockKeyboard
  )
  local_mocked_bindings(
    ChromoteSession = MockChromoteSession,
    .package = "chromote"
  )
  live_session <- LiveSession$new("ignored-url")

  pos <- live_session$get_scroll_position()
  expect_true("get_scroll_position" %in% live_session$.__enclos_env__$private$mouse$log$calls)
  expect_equal(pos, list(x = 123, y = 456))
})

test_that("LiveSession orchestrates scroll_into_view", {
  local_mocked_bindings(
    LiveSessionFinder = MockFinder,
    LiveSessionMouse = MockMouse,
    LiveSessionKeyboard = MockKeyboard
  )
  local_mocked_bindings(
    ChromoteSession = MockChromoteSession,
    .package = "chromote"
  )
  live_session <- LiveSession$new("ignored-url")

  live_session$scroll_into_view(css = ".foo")
  expect_true("wait_for_selector" %in% live_session$.__enclos_env__$private$finder$log$calls)
  expect_true("scroll_into_view" %in% live_session$.__enclos_env__$private$mouse$log$calls)
})

test_that("LiveSession orchestrates scroll_to", {
  local_mocked_bindings(
    LiveSessionFinder = MockFinder,
    LiveSessionMouse = MockMouse,
    LiveSessionKeyboard = MockKeyboard
  )
  local_mocked_bindings(
    ChromoteSession = MockChromoteSession,
    .package = "chromote"
  )
  live_session <- LiveSession$new("ignored-url")

  live_session$scroll_to(top = 100)
  expect_true("scroll_to" %in% live_session$.__enclos_env__$private$mouse$log$calls)
})

test_that("LiveSession orchestrates scroll_by", {
  local_mocked_bindings(
    LiveSessionFinder = MockFinder,
    LiveSessionMouse = MockMouse,
    LiveSessionKeyboard = MockKeyboard
  )
  local_mocked_bindings(
    ChromoteSession = MockChromoteSession,
    .package = "chromote"
  )
  live_session <- LiveSession$new("ignored-url")

  live_session$scroll_by(top = 100)
  expect_true("scroll_by" %in% live_session$.__enclos_env__$private$mouse$log$calls)
})

test_that("LiveSession orchestrates press", {
  local_mocked_bindings(
    LiveSessionFinder = MockFinder,
    LiveSessionMouse = MockMouse,
    LiveSessionKeyboard = MockKeyboard
  )
  local_mocked_bindings(
    ChromoteSession = MockChromoteSession,
    .package = "chromote"
  )
  live_session <- LiveSession$new("ignored-url")

  live_session$press(css = ".foo", key_code = "Enter")
  expect_true("wait_for_selector" %in% live_session$.__enclos_env__$private$finder$log$calls)
  expect_true("press" %in% live_session$.__enclos_env__$private$keyboard$log$calls)
})
