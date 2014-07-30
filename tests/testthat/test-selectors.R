context("Selectors")

test <- XML::htmlParse("test.html")

# XPath ------------------------------------------------------------------------

test_that("xpath with // selects from root", {
  p <- test[xpath("//p")]
  expect_equal(length(p), 4)

  p2 <- p[[1]][xpath("//p")]
  expect_equal(length(p2), 4)

  p3 <- p[[3]][xpath("b")]
  expect_equal(length(p3), 1)

  b <- p[xpath("b")]
  expect_equal(length(b), 2)
})

# CSS --------------------------------------------------------------------------

test_that("css class selects from current value", {
  p <- test[sel("p")]
  expect_equal(length(p), 4)

  p3 <- p[[3]][sel("b")]
  expect_equal(length(p3), 1)

  b <- p[sel("b")]
  expect_equal(length(b), 2)
})

test_that("css selects don't select themselves", {
  p <- test[sel("p")][sel("p")]
  expect_equal(length(p), 0)

  p <- test[sel("p")][[1]][sel("p")]
  expect_equal(length(p), 0)
})

test_that("css selects find all children", {
  b <- test[sel("body")][sel("b")]
  expect_equal(length(b), 3)
})


# Character --------------------------------------------------------------------

test_that("missing attributes yield missing values", {
  test <- html("<p><img src='a' /><img src='b'/><img /></p>")
  p <- test[sel("p")][[1]]

  expect_equal(p[[1]]["src"], list(src = "a"))
  expect_equal(p[[3]]["src"], list(src = NA_character_))
  expect_equal(p[[1]][c("src", "a")], list(src = "a", a = NA_character_))
  expect_equal(p[[3]][c("src", "a")], list(src = NA_character_, a = NA_character_))
})

test_that("character subsetting of node set returns data frame", {
  test <- html("<p><img src='a' /><img src='b'/><img /></p>")
  img <- test[sel("img")]

  expect_equal(img["src"], data.frame(src = c("a", "b", NA), stringsAsFactors = FALSE))
})


