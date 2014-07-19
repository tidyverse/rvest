context("Selectors")

test <- XML::htmlParse("test.html")

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


