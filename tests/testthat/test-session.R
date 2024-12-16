test_that("basic session process works as expected", {
  expect_snapshot({
    s <- session("http://hadley.nz/")
    s
    expect_true(is.session(s))

    s <- session_follow_link(s, css = "p a")
    session_history(s)
  })
})

test_that("session caches xml parsing and sets base url", {
  s <- session("https://rvest.tidyverse.org/")
  expect_equal(s@cache$html, NULL)

  html <- read_html(s)
  expect_true(rlang::is_reference(s@cache$html, html))
  expect_equal(xml2::xml_url(html), "https://rvest.tidyverse.org/")
})

test_that("errors if try to access HTML from non-HTML page", {
  expect_snapshot(error = TRUE, {
    s <- session("https://rvest.tidyverse.org/logo.png")
    read_html(s)
  })
})

test_that("session responds to httr and rvest methods", {
  # skip_on_cran()

  s <- session("http://hadley.nz/")
  expect_silent(html_form(s))
  expect_silent(html_table(s))
  expect_silent(html_element(s, "body"))
  expect_silent(html_element(s, "body"))

  expect_silent(status_code(s))
  expect_silent(headers(s))
  expect_silent(cookies(s))
})

test_that("informative errors for bad inputs", {
  expect_snapshot_error(check_form(1))
  expect_snapshot_error(check_session(1))
})

# navigation --------------------------------------------------------------

test_that("can navigate back and forward", {
  s <- session("https://hadley.nz/")
  expect_equal(s@back, character())
  expect_equal(s@forward, character())
  expect_snapshot_error(session_back(s))
  expect_snapshot_error(session_forward(s))

  s <- session_jump_to(s, "https://r4ds.hadley.nz/")
  expect_equal(s@back, "https://hadley.nz/")
  expect_equal(s@forward, character())

  expect_equal(session_forward(session_back(s))@url, s@url)

  s <- session_back(s)
  expect_equal(s@back, character())
  expect_equal(s@forward, "https://r4ds.hadley.nz/")

  s <- session_forward(s)
  expect_equal(s@back, "https://hadley.nz/")
  expect_equal(s@forward, character())
})

test_that("can find link by position, content, css, or xpath", {
  html <- minimal_html("
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

test_that("can submit a form", {
  app <- local_test_app()

  html <- minimal_html('
    <form action="/">
    <input type="text", name="x" value="1">
    <input type="text", name="y" value="2">
    </form>
  ')
  form <- html_form(html, base_url = app$url())[[1]]

  s <- session("http://hadley.nz/")
  s <- session_submit(s, form)
  expect_true(S7_inherits(s, rvest_session))

  resp <- httr::content(s@response)
  expect_equal(resp$query, "x=1&y=2")
})
