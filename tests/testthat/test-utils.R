test_that("can truncate strings", {
  expect_equal(str_trunc("abcdef", 10), "abcdef")
  expect_equal(str_trunc("abcdef", 4), "a...")
})

test_that("minimal html doesn't change unexpectedly", {
  expect_snapshot(cat(as.character(minimal_html("test", "<p>Hi"))))
})
