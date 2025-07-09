test_that("parse_html_fragments handles a single element", {
  single_el <- c("<div><p>Hello</p></div>")
  nodeset_single <- parse_html_fragments(single_el)
  expect_s3_class(nodeset_single, "xml_nodeset")
  expect_equal(length(nodeset_single), 1)
  expect_equal(xml2::xml_text(nodeset_single), "Hello")
})

test_that("parse_html_fragments handles multiple elements", {
  multi_el <- c("<p>One</p>", "<p>Two</p>")
  nodeset_multi <- parse_html_fragments(multi_el)
  expect_s3_class(nodeset_multi, "xml_nodeset")
  expect_equal(length(nodeset_multi), 2)
  expect_equal(xml2::xml_text(nodeset_multi), c("One", "Two"))
})

test_that("parse_html_fragments handles empty input", {
  empty_el <- character()
  nodeset_empty <- parse_html_fragments(empty_el)
  expect_s3_class(nodeset_empty, "xml_nodeset")
  expect_equal(length(nodeset_empty), 0)
})

test_that("create_xpath_finder_js generates correct JavaScript", {
  xpath <- "//a[@id='test']"
  expect_snapshot({
    create_xpath_finder_js(xpath)
  })
})

test_that("create_xpath_finder_js escapes special characters", {
  xpath_escape <- "//a[text()=\"it's a `test`\"]"
  expect_snapshot({
    create_xpath_finder_js(xpath_escape)
  })
})

test_that("as_key_desc gracefully errors on bad inputs", {
  expect_snapshot(error = TRUE, {
    as_key_desc("xyz")
    as_key_desc("X", "Malt")
  })
})

test_that("as_key_desc automatically adjusts for shift key", {
  # str(Filter(\(x) has_name(x, "shiftKey"), keydefs))
  expect_equal(as_key_desc("KeyA")$key, "a")
  expect_equal(as_key_desc("KeyA", "Shift")$key, "A")

  # str(Filter(\(x) has_name(x, "shiftKeyCode"), keydefs))
  expect_equal(as_key_desc("Numpad0")$windowsVirtualKeyCode, 45)
  expect_equal(as_key_desc("Numpad0", "Shift")$windowsVirtualKeyCode, 96)
})

test_that("as_key_desc doesn't send text if modifier pushed", {
  expect_equal(as_key_desc("KeyA")$text, "a")
  expect_equal(as_key_desc("KeyA", "Shift")$text, "a")
  expect_equal(as_key_desc("KeyA", "Alt")$text, "")
  expect_equal(as_key_desc("KeyA", "Meta")$text, "")
  expect_equal(as_key_desc("KeyA", "Control")$text, "")
})

test_that("as_key_desc modifiers are bitflag", {
  expect_equal(as_key_desc("KeyA", "Shift")$modifiers, 8)
  expect_equal(as_key_desc("KeyA", c("Alt", "Control"))$modifiers, 3)
})

test_that("has_chromote() returns TRUE on success", {
  local_mocked_bindings(
    default_chromote_object = function() {
      # Return a mock object that responds to the necessary methods
      env(
        new_session = function(...) TRUE,
        wait_for = function(...) TRUE
      )
    },
    .package = "chromote"
  )
  expect_true(has_chromote())
})

test_that("has_chromote() returns FALSE on failure", {
  local_mocked_bindings(
    default_chromote_object = function() {
      stop("Chromote not found")
    },
    .package = "chromote"
  )
  expect_false(has_chromote())
})
