context("Selectors")

test <- read_html("test.html")

# XPath ------------------------------------------------------------------------

test_that("xpath with // selects from root", {
  p <- html_nodes(test, xpath = "//p")
  expect_equal(length(p), 4)

  p2 <- html_nodes(p[[1]], xpath = "//p")
  expect_equal(length(p2), 4)

  p3 <- html_nodes(p[[3]], xpath = "b")
  expect_equal(length(p3), 1)

  b <- html_nodes(p, xpath = "b")
  expect_equal(length(b), 2)
})

# CSS --------------------------------------------------------------------------

test_that("css class selects from current value", {
  p <- html_nodes(test, "p")
  expect_equal(length(p), 4)

  p3 <- html_nodes(p[[3]], "b")
  expect_equal(length(p3), 1)

  b <- html_nodes(p, "b")
  expect_equal(length(b), 2)
})

test_that("css selects don't select themselves", {
  p <- test %>% html_nodes("p") %>% html_nodes("p")
  expect_equal(length(p), 0)

  p <- test %>% html_nodes("p") %>% `[[`(1) %>% html_nodes("p")
  expect_equal(length(p), 0)
})

test_that("css selects find all children", {
  b <- test %>% html_nodes("body") %>% html_nodes("b")
  expect_equal(length(b), 3)
})

test_that("empty matches returns empty list", {
  none <- test %>% html_nodes("none")
  expect_equal(length(none), 0)

  expect_equal(none %>% html_node("none") %>% length(), 0)
  expect_equal(none %>% html_nodes("none") %>% length(), 0)
})
