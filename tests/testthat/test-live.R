test_that("has print method", {
  skip_if_no_chromote()

  bullets <- read_html_live(html_test_path("bullets"))
  expect_snapshot(bullets)
})

test_that("can find multiple elements", {
  skip_if_no_chromote()

  bullets <- read_html_live(html_test_path("bullets"))
  # can extract from page
  ul <- bullets %>% html_elements("ul")
  expect_length(ul, 1)

  # or with xpath
  ul <- bullets %>% html_elements(xpath = ".//ul")
  expect_length(ul, 1)

  # can extract from other elements
  li <- ul %>% html_elements("li")
  expect_length(li, 4)
})

test_that("can extract tables", {
  skip_if_no_chromote()

  page <- read_html_live(html_test_path("table"))
  table <- page %>% html_table() %>% .[[1]]
  expect_equal(dim(table), c(2, 3))
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

test_that("can find elements after click that navigates", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("navigate1"))
  sess$click("a", wait_for = "load")
  expect_equal(html_text2(html_element(sess, "p")), "Success!")
})

test_that("can scroll in various ways", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("scroll"))
  expect_equal(sess$get_scroll_position(), list(x = 0, y = 0))

  sess$scroll_to(500)
  Sys.sleep(0.2)
  expect_equal(sess$get_scroll_position(), list(x = 0, y = 500))

  sess$scroll_by(-250)
  Sys.sleep(0.2)
  expect_equal(sess$get_scroll_position(), list(x = 0, y = 250))

  sess$scroll_into_view("#bottom")
  Sys.sleep(0.2)
  expect_equal(sess$get_scroll_position(), list(x = 0, y = 685))
})

test_that("can type text", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("type"))
  sess$type("#inputText", "hello")
  expect_equal(html_text(html_element(sess, "#replicatedText")), "hello")
})

test_that("can press special keys",{
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("press"))
  sess$press("#inputBox", "ArrowRight")
  expect_equal(html_text(html_element(sess, "#keyInfo")), "ArrowRight/ArrowRight")

  sess$press("#inputBox", "BracketRight")
  expect_equal(html_text(html_element(sess, "#keyInfo")), "]/BracketRight")
})
