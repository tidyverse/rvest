test_that("can truncate strings", {
  expect_equal(str_trunc("abcdef", 10), "abcdef")
  expect_equal(str_trunc("abcdef", 4), "a...")
})
