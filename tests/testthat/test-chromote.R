test_that("has print method", {
  expect_snapshot({
    test_session()
  })
})

test_that("can find multiple elements", {
  session <- test_session()

  # can extract from page
  sections <- session %>% html_elements("#main section")
  expect_length(sections, 7)

  # can extract from other elements
  p <- sections %>% html_elements("p")
  expect_length(p, 33)
})

test_that("can find single element", {
  dynamic <- test_session()
  static <- read_html("https://rvest.tidyverse.org/articles/starwars.html")

  expect_equal(html_element(dynamic, "p"), html_element(static, "p"))
  expect_equal(html_element(dynamic, "xyz"), html_element(static, "xyz"))
})

