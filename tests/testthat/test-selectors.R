context("Selectors")
library(magrittr)

test <- html("test.html")

# XPath ------------------------------------------------------------------------

test_that("xpath with // selects from root", {
  p <- html_node(test, "//p", xpath = TRUE)
  expect_equal(length(p), 4)

  p2 <- html_node(p[[1]], "//p", xpath = TRUE)
  expect_equal(length(p2), 4)

  p3 <- html_node(p[[3]], "b", xpath = TRUE)
  expect_equal(length(p3), 1)

  b <- html_node(p, "b", xpath = TRUE)
  expect_equal(length(b), 2)
})

# CSS --------------------------------------------------------------------------

test_that("css class selects from current value", {
  p <- html_node(test, "p")
  expect_equal(length(p), 4)

  p3 <- html_node(p[[3]], "b")
  expect_equal(length(p3), 1)

  b <- html_node(p, "b")
  expect_equal(length(b), 2)
})

test_that("css selects don't select themselves", {
  p <- test %>% html_node("p") %>% html_node("p")
  expect_equal(length(p), 0)

  p <- test %>% html_node("p") %>% extract2(1) %>% html_node("p")
  expect_equal(length(p), 0)
})

test_that("css selects find all children", {
  b <- test %>% html_node("body") %>% html_node("b")
  expect_equal(length(b), 3)
})

