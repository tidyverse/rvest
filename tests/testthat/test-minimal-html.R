test_that("minimal html doesn't change unexpected", {
  expect_snapshot(cat(as.character(minimal_html("test", "<p>Hi"))))
})
