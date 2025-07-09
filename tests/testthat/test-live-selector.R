test_that("CssSelector$find() returns nodes on success", {
  mock_session <- mock_session_for_selectors()
  selector <- CssSelector$new(".found")
  nodes <- selector$find(mock_session, root_id = 1)
  expect_equal(nodes, c(101, 102))
})

test_that("CssSelector$find() returns empty list on failure", {
  mock_session <- mock_session_for_selectors()
  selector <- CssSelector$new(".not-found")
  nodes <- selector$find(mock_session, root_id = 1)
  expect_equal(length(nodes), 0)
})

test_that("CssSelector$wait_for() returns nodes on success", {
  mock_session <- mock_session_for_selectors()
  selector <- CssSelector$new(".found")
  nodes <- selector$wait_for(mock_session, root_id = 1, timeout = 0.1)
  expect_equal(nodes, c(101, 102))
})

test_that("CssSelector$wait_for() errors on timeout", {
  mock_session <- mock_session_for_selectors()
  selector <- CssSelector$new(".not-found")
  expect_error(
    selector$wait_for(mock_session, root_id = 1, timeout = 0.1),
    "Failed to find selector"
  )
})

test_that("XpathSelector$find() returns nodes on success", {
  mock_session <- mock_session_for_selectors()
  selector <- XpathSelector$new("//p[class='found']")
  nodes <- selector$find(mock_session, root_id = 1)
  expect_equal(nodes, c(201, 202))
})

test_that("XpathSelector$find() returns empty list on failure", {
  mock_session <- mock_session_for_selectors()
  selector <- XpathSelector$new("//p[class='not-found']")
  nodes <- selector$find(mock_session, root_id = 1)
  expect_equal(length(nodes), 0)
})

test_that("XpathSelector$wait_for() returns nodes on success", {
  mock_session <- mock_session_for_selectors()
  selector <- XpathSelector$new("//p[class='found']")
  nodes <- selector$wait_for(mock_session, root_id = 1, timeout = 0.1)
  expect_equal(nodes, c(201, 202))
})

test_that("XpathSelector$wait_for() errors on timeout", {
  mock_session <- mock_session_for_selectors()
  selector <- XpathSelector$new("//p[class='not-found']")
  expect_error(
    selector$wait_for(mock_session, root_id = 1, timeout = 0.1),
    "Failed to find selector"
  )
})

test_that("Base Selector class throw expected error for find", {
  selector <- Selector$new("test")
  expect_error(
    selector$find(NULL, NULL),
    class = "interface_not_implemented"
  )
})
