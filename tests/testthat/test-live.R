test_that("url is validated", {
  expect_snapshot(error = TRUE, {
    read_html_live("")
    read_html_live(123)
  })
})

test_that("errors when navigation fails", {
  skip_if_no_chromote()

  expect_snapshot(error = TRUE, {
    read_html_live("https://doeasdfsdafastnexist.com")
    read_html_live(".//")
  })
})

test_that("mode and view are validated", {
  expect_snapshot(error = TRUE, {
    read_html_live("https://rvest.tidyverse.org", mode = "invisible")
    read_html_live("https://rvest.tidyverse.org", view = "tablet")
  })
})

test_that("has print method", {
  skip_if_no_chromote()

  bullets <- read_html_live(html_test_path("bullets"))
  expect_snapshot(bullets)
})

test_that("can find multiple elements", {
  skip_if_no_chromote()

  bullets <- read_html_live(html_test_path("bullets"))
  # can extract from page
  ul <- bullets |> html_elements("ul")
  expect_length(ul, 1)

  # or with xpath
  ul <- bullets |> html_elements(xpath = ".//ul")
  expect_length(ul, 1)

  # can extract from other elements
  li <- ul |> html_elements("li")
  expect_length(li, 4)
})

test_that("can select html, head, and body elements", {
  skip_if_no_chromote()

  bullets <- read_html_live(html_test_path("bullets"))
  expect_equal(html_name(html_elements(bullets, "html > *")), c("head", "body"))
  expect_equal(html_name(html_elements(bullets, "body")), "body")
  expect_equal(html_name(html_elements(bullets, "html")), "html")
  expect_equal(
    html_name(html_elements(bullets, "head, li")),
    c("head", rep("li", 4))
  )
})

test_that("xpath works with single and double quotes", {
  skip_if_no_chromote()

  bullets <- read_html_live(html_test_path("bullets"))
  expect_equal(
    bullets |>
      html_elements(xpath = '//li[contains(text(), "2")]') |>
      html_text(),
    "Item 2"
  )
  expect_equal(
    bullets |>
      html_elements(xpath = "//li[contains(text(), '2')]") |>
      html_text(),
    "Item 2"
  )
})

test_that("js_string escapes for JS string literals", {
  expect_equal(js_string("abc"), '"abc"')
  expect_equal(js_string("a'b"), "\"a'b\"")
  expect_equal(js_string('a"b'), '"a\\"b"')
  expect_equal(js_string("a\\b"), '"a\\\\b"')
  expect_equal(js_string("a\nb"), '"a\\nb"')
})

test_that("can extract tables", {
  skip_if_no_chromote()

  page <- read_html_live(html_test_path("table"))
  tables <- page |> html_table()
  expect_equal(dim(tables[[1]]), c(2, 3))
})

test_that("can find single element", {
  skip_if_no_chromote()
  dynamic <- read_html_live(
    "https://rvest.tidyverse.org/articles/starwars.html"
  )
  static <- read_html("https://rvest.tidyverse.org/articles/starwars.html")

  expect_equal(html_element(dynamic, "p"), html_element(static, "p"))
  expect_equal(html_element(dynamic, "xyz"), html_element(static, "xyz"))
})

test_that("can click a button", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("click"))
  sess$click("#actionButton")
  expect_equal(html_text(html_element(sess, "p")), "clicked")

  sess$click("#actionButton", 2)
  expect_equal(html_text(html_element(sess, "p")), "double clicked")
})

test_that("can click hidden element with js method", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("click"))
  sess$click("#hiddenButton", method = "js")
  expect_equal(html_text(html_element(sess, "p")), "hidden clicked")
})

test_that("mouse click on hidden element errors helpfully", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("click"))
  expect_snapshot(
    sess$click("#hiddenButton"),
    error = TRUE
  )
  expect_snapshot(
    sess$click("#hiddenButton", n_clicks = 2, method = "js"),
    error = TRUE
  )
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
  expect_equal(sess$get_scroll_position(), list(x = 0, y = 1208))
})

test_that("can type text", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("type"))
  sess$type("#inputText", "hello")
  expect_equal(html_text(html_element(sess, "#replicatedText")), "hello")
})

test_that("can select an option", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("select"))
  sess$select("select", value = "b")
  expect_equal(html_text(html_element(sess, "p")), "b")

  sess$select("select", text = "Cherry")
  expect_equal(html_text(html_element(sess, "p")), "c")
})

test_that("select errors when no option matches", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("select"))
  expect_snapshot(error = TRUE, sess$select("select", value = "z"))
  expect_snapshot(error = TRUE, sess$select("select", text = "Fig"))
})

test_that("select errors when element is not a select", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("select"))
  expect_snapshot(error = TRUE, sess$select("p", value = "b"))
  expect_snapshot(error = TRUE, sess$select("p", text = "Banana"))
})

test_that("can press special keys", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("press"))
  sess$press("#inputBox", "ArrowRight")
  expect_equal(
    html_text(html_element(sess, "#keyInfo")),
    "ArrowRight/ArrowRight"
  )

  sess$press("#inputBox", "BracketRight")
  expect_equal(html_text(html_element(sess, "#keyInfo")), "]/BracketRight")
})

test_that("can find elements after click that navigates", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("navigate1"))
  sess$click("a")
  expect_equal(html_text2(html_element(sess, "p")), "Success!")
})

test_that("hides automated browser tells", {
  skip_if_no_chromote()

  sess <- read_html_live(html_test_path("bullets"))
  expect_false(eval_js(sess$session, "navigator.webdriver"))
  expect_true(eval_js(sess$session, "navigator.languages.length") > 0)
  expect_true(eval_js(sess$session, "navigator.plugins.length") > 0)
  expect_false(grepl(
    "HeadlessChrome",
    eval_js(sess$session, "navigator.userAgent")
  ))
})

test_that("view controls viewport size", {
  skip_if_no_chromote()

  inner_width <- function(sess) eval_js(sess$session, "window.innerWidth")
  desktop <- read_html_live(html_test_path("bullets"), view = "desktop")
  expect_equal(inner_width(desktop), 1280)

  mobile <- read_html_live(html_test_path("bullets"), view = "mobile")
  # Without a viewport meta tag, mobile Chrome lays out at a 980px fallback
  expect_equal(inner_width(mobile), 980)
})

# as_key_desc -------------------------------------------------------------

test_that("gracefully errors on bad inputs", {
  expect_snapshot(error = TRUE, {
    as_key_desc("xyz")
    as_key_desc("X", "Malt")
  })
})

test_that("automatically adjusts for shift key", {
  # str(Filter(\(x) has_name(x, "shiftKey"), keydefs))
  expect_equal(as_key_desc("KeyA")$key, "a")
  expect_equal(as_key_desc("KeyA", "Shift")$key, "A")

  # str(Filter(\(x) has_name(x, "shiftKeyCode"), keydefs))
  expect_equal(as_key_desc("Numpad0")$windowsVirtualKeyCode, 45)
  expect_equal(as_key_desc("Numpad0", "Shift")$windowsVirtualKeyCode, 96)
})

test_that("don't send text if modifier pushed", {
  expect_equal(as_key_desc("KeyA")$text, "a")
  expect_equal(as_key_desc("KeyA", "Shift")$text, "a")
  expect_equal(as_key_desc("KeyA", "Alt")$text, "")
  expect_equal(as_key_desc("KeyA", "Meta")$text, "")
  expect_equal(as_key_desc("KeyA", "Control")$text, "")
})

test_that("modifiers are bitflag", {
  expect_equal(as_key_desc("KeyA", "Shift")$modifiers, 8)
  expect_equal(as_key_desc("KeyA", c("Alt", "Control"))$modifiers, 3)
})
