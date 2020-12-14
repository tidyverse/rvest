test_that("can select one or more nodes", {
  html <- minimal_html("test", "<p><p><p>")
  expect_s3_class(html_nodes(html, "p"), "xml_nodeset")
  expect_s3_class(html_node(html, "p"), "xml_node")
})

test_that("xpath with // selects from root", {
  test <- read_html(test_path("test.html"))

  p <- html_nodes(test, xpath = "//p")
  expect_equal(length(p), 4)

  p2 <- html_nodes(p[[1]], xpath = "//p")
  expect_equal(length(p2), 4)

  p3 <- html_nodes(p[[3]], xpath = "b")
  expect_equal(length(p3), 1)

  b <- html_nodes(p, xpath = "b")
  expect_equal(length(b), 2)
})

test_that("css class selects from current value", {
  test <- read_html(test_path("test.html"))

  p <- html_nodes(test, css = "p")
  expect_equal(length(p), 4)

  p3 <- html_nodes(p[[3]], css = "b")
  expect_equal(length(p3), 1)

  b <- html_nodes(p, css = "b")
  expect_equal(length(b), 2)
})

test_that("css selects don't select themselves", {
  test <- read_html(test_path("test.html"))
  p <- test %>% html_nodes("p") %>% html_nodes("p")
  expect_equal(length(p), 0)

  p <- test %>% html_nodes("p") %>% `[[`(1) %>% html_nodes("p")
  expect_equal(length(p), 0)
})

test_that("css selects find all children", {
  test <- read_html(test_path("test.html"))
  b <- test %>% html_nodes("body") %>% html_nodes("b")
  expect_equal(length(b), 3)
})

test_that("empty matches returns empty list", {
  test <- read_html(test_path("test.html"))
  none <- test %>% html_nodes("none")
  expect_equal(length(none), 0)

  expect_equal(none %>% html_node("none") %>% length(), 0)
  expect_equal(none %>% html_nodes("none") %>% length(), 0)
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
