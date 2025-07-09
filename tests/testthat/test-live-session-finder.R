test_that("LiveSessionFinder can find nodes with CSS", {
  mock_session <- mock_session_for_finder()
  get_root_id <- function() { 1 }
  finder <- LiveSessionFinder$new(mock_session, get_root_id)

  css_selector <- CssSelector$new(".found")
  nodes_css <- finder$find_nodes(css_selector)
  expect_equal(nodes_css, c(101, 102))
})

test_that("LiveSessionFinder can find nodes with XPath", {
  mock_session <- mock_session_for_finder()
  get_root_id <- function() { 1 }
  finder <- LiveSessionFinder$new(mock_session, get_root_id)

  xpath_selector <- XpathSelector$new("//p")
  nodes_xpath <- finder$find_nodes(xpath_selector)
  expect_equal(nodes_xpath, c(201, 202))
})

test_that("LiveSessionFinder can get outer HTML", {
  mock_session <- mock_session_for_finder()
  get_root_id <- function() { 1 }
  finder <- LiveSessionFinder$new(mock_session, get_root_id)

  html <- finder$get_outer_html(101)
  expect_equal(html, "<p id='101'>Content</p>")
})

test_that("wait_for_selector times out correctly", {
  mock_session <- mock_session_for_finder()
  get_root_id <- function() { 1 }
  finder <- LiveSessionFinder$new(mock_session, get_root_id)

  selector <- CssSelector$new(".not-found")
  expect_error(
    finder$wait_for_selector(selector, timeout = 0.1),
    "Failed to find selector"
  )
})
