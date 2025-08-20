test_that("can select one or more nodes", {
  html <- minimal_html("<p><p><p>")
  expect_s3_class(html_elements(html, "p"), "xml_nodeset")
  expect_s3_class(html_element(html, "p"), "xml_node")
})

test_that("xpath with // selects from root", {
  test <- read_html(test_path("test.html"))

  p <- html_elements(test, xpath = "//p")
  expect_equal(length(p), 4)

  p2 <- html_elements(p[[1]], xpath = "//p")
  expect_equal(length(p2), 4)

  p3 <- html_elements(p[[3]], xpath = "b")
  expect_equal(length(p3), 1)

  b <- html_elements(p, xpath = "b")
  expect_equal(length(b), 2)
})

test_that("css class selects from current value", {
  test <- read_html(test_path("test.html"))

  p <- html_elements(test, css = "p")
  expect_equal(length(p), 4)

  p3 <- html_elements(p[[3]], css = "b")
  expect_equal(length(p3), 1)

  b <- html_elements(p, css = "b")
  expect_equal(length(b), 2)
})

test_that("css selects don't select themselves", {
  test <- read_html(test_path("test.html"))
  p <- test |> html_elements("p") |> html_elements("p")
  expect_equal(length(p), 0)

  ps <- test |> html_elements("p") 
  p <- ps[[1]] |> html_elements("p")
  expect_equal(length(p), 0)
})

test_that("css selects find all children", {
  test <- read_html(test_path("test.html"))
  b <- test |> html_elements("body") |> html_elements("b")
  expect_equal(length(b), 3)
})

test_that("empty matches returns empty list", {
  test <- read_html(test_path("test.html"))
  none <- test |> html_elements("none")
  expect_equal(length(none), 0)

  expect_equal(none |> html_element("none") |> length(), 0)
  expect_equal(none |> html_elements("none") |> length(), 0)
})

# make_selector -----------------------------------------------------------

test_that("validates inputs", {
  expect_snapshot(make_selector(), error = TRUE)
  expect_snapshot(make_selector("a", "b"), error = TRUE)

  expect_snapshot(make_selector(css = 1), error = TRUE)
  expect_snapshot(make_selector(xpath = 1), error = TRUE)
})

test_that("converts css to xpath", {
  expect_equal(make_selector(css = "p"), ".//p")
})

test_that("preserves xpath", {
  expect_equal(make_selector(xpath = ".//p"), ".//p")
})
