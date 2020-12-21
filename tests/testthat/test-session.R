test_that("basic session process works as expected", {
  expect_snapshot({
    s <- html_session("http://hadley.nz/")
    s
    expect_true(is.session(s))

    s <- follow_link(s, css = "p a")
    session_history(s)
  })
})

test_that("can navigate back and forward", {
  s <- html_session("http://hadley.nz/")
  expect_equal(s$back, character())
  expect_equal(s$forward, character())
  expect_snapshot_error(back(s))
  expect_snapshot_error(forward(s))

  s <- jump_to(s, "hadley-wickham.jpg")
  expect_equal(s$back, "http://hadley.nz/")
  expect_equal(s$forward, character())

  s <- back(s)
  expect_equal(s$back, character())
  expect_equal(s$forward, "http://hadley.nz/")

  s <- forward(s)
  expect_equal(s$back, "http://hadley.nz/")
  expect_equal(s$forward, character())
})


test_that("session caches xml parsing", {
  s <- html_session("https://rvest.tidyverse.org/")
  expect_equal(s$cache$html, NULL)

  html <- read_html(s)
  expect_true(rlang::is_reference(s$cache$html, html))
})

test_that("errors if try to access HTML from non-HTML page", {
  expect_snapshot(error = TRUE, {
    s <- html_session("https://rvest.tidyverse.org/logo.png")
    read_html(s)
  })
})

test_that("session responds to httr and rvest methods", {
  # skip_on_cran()

  s <- html_session("http://rstudio.com/")
  expect_silent(html_form(s))
  expect_silent(html_table(s))
  expect_silent(html_node(s, "body"))
  expect_silent(html_nodes(s, "body"))

  expect_silent(status_code(s))
  expect_silent(headers(s))
  expect_silent(cookies(s))
})

test_that("can find link by position, content, css, or xpath", {
  html <- minimal_html("test", "
    <a href='a'>a</a>
    <a href='b' class='b'>b</a>
  ")

  expect_equal(find_href(html, i = 1), "a")
  expect_equal(find_href(html, i = "b"), "b")
  expect_equal(find_href(html, css = "a.b"), "b")

  # Failure modes
  expect_snapshot(find_href(html, i = 1, css = "a"), error = TRUE)
  expect_snapshot(find_href(html, i = TRUE), error = TRUE)
  expect_snapshot(find_href(html, i = "c"), error = TRUE)
  expect_snapshot(find_href(html, css = "p a"), error = TRUE)
})
