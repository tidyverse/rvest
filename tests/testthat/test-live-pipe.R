test_that("live_click is pipeable and works", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("click"))
  sess2 <- live_click(sess, "button")

  expect_equal(html_text(html_element(sess, "p")), "clicked")
  expect_identical(sess, sess2)
})

test_that("live_get_scroll_position returns value", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("scroll"))
  pos <- live_get_scroll_position(sess)
  expect_equal(pos, list(x = 0, y = 0))
})

test_that("live_scroll_into_view is pipeable and works", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("scroll"))
  sess2 <- live_scroll_into_view(sess, "#bottom")
  Sys.sleep(0.2)
  expect_equal(live_get_scroll_position(sess), list(x = 0, y = 685))
  expect_identical(sess, sess2)
})

test_that("live_scroll_to is pipeable and works", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("scroll"))
  sess2 <- live_scroll_to(sess, 500)
  Sys.sleep(0.2)
  expect_equal(live_get_scroll_position(sess), list(x = 0, y = 500))
  expect_identical(sess, sess2)
})

test_that("live_scroll_by is pipeable and works", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("scroll"))
  sess2 <- live_scroll_by(sess, 250)
  Sys.sleep(0.2)
  expect_equal(live_get_scroll_position(sess), list(x = 0, y = 250))
  expect_identical(sess, sess2)
})

test_that("live_type is pipeable and works", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("type"))
  sess2 <- live_type(sess, "#inputText", "hello")
  expect_equal(html_text(html_element(sess, "#replicatedText")), "hello")
  expect_identical(sess, sess2)
})

test_that("live_press is pipeable and works", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("press"))
  sess2 <- live_press(sess, "#inputBox", "ArrowRight")
  expect_equal(html_text(html_element(sess, "#keyInfo")), "ArrowRight/ArrowRight")
  expect_identical(sess, sess2)
})
