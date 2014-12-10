context("additional args")

test_that("additional args for httr::GET", {
  expect_error(html("https://www.aldi-sued.de/"))
  expect_is(res <- html("https://www.aldi-sued.de/", encoding = NULL,
    httr::user_agent("Mozilla/5.0")), "HTMLInternalDocument")
})
