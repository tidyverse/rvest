test_that("can guess encoding", {
  path <- system.file("html-ex", "bad-encoding.html", package = "rvest")
  x <- read_html(path)

  expect_snapshot(html_encoding_guess(x))
  # deprecated
  expect_snapshot(guess_encoding(x))
})

test_that("encoding repair is deprecated", {
  path <- system.file("html-ex", "bad-encoding.html", package = "rvest")
  x <- read_html(path)
  text <- html_text(html_element(x, "p"))

  expect_snapshot(repair_encoding(text), error = TRUE)
  expect_snapshot(repair_encoding(text, "ISO-8859-1"))
})
