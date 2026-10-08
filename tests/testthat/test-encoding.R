test_that("can guess encoding", {
  skip("currently broken")
  skip_on_os("linux") # some hidden dependency on system library

  path <- system.file("html-ex", "bad-encoding.html", package = "rvest")
  x <- read_html(path)

  expect_snapshot(html_encoding_guess(x))
})
