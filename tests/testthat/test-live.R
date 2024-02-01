test_that("has print method", {
  skip_if_no_chromote()

  sess <- read_html_live("https://rvest.tidyverse.org/articles/starwars.html")
  expect_snapshot({
    sess
  })
})

test_that("can find multiple elements", {
  skip_if_no_chromote()
  sess <- read_html_live("https://rvest.tidyverse.org/articles/starwars.html")

  # can extract from page
  sections <- sess %>% html_elements("#main section")
  expect_length(sections, 7)

  # can extract from other elements
  p <- sections %>% html_elements("p")
  expect_length(p, 33)
})

test_that("can find single element", {
  skip_if_no_chromote()
  dynamic <- read_html_live("https://rvest.tidyverse.org/articles/starwars.html")
  static <- read_html("https://rvest.tidyverse.org/articles/starwars.html")

  expect_equal(html_element(dynamic, "p"), html_element(static, "p"))
  expect_equal(html_element(dynamic, "xyz"), html_element(static, "xyz"))
})

test_that("can click a button", {
  skip_if_no_chromote()
  sess <- read_html_live(html_test_path("click"))
  sess$click("button")
  expect_equal(html_text(html_element(sess, "p")), "clicked")

  sess$click("button", 2)
  expect_equal(html_text(html_element(sess, "p")), "double clicked")
})
