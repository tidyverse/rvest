test_that("basic session process works as expected", {
  expect_snapshot({
    s <- session("http://hadley.nz/")
    s
    expect_true(is.session(s))

    s <- session_follow_link(s, css = "p a")
    session_history(s)
  })
})

test_that("session caches xml parsing", {
  s <- session("https://rvest.tidyverse.org/")
  expect_equal(s$cache$html, NULL)

  html <- read_html(s)
  expect_true(rlang::is_reference(s$cache$html, html))
})

test_that("errors if try to access HTML from non-HTML page", {
  expect_snapshot(error = TRUE, {
    s <- session("https://rvest.tidyverse.org/logo.png")
    read_html(s)
  })
})

test_that("session responds to httr and rvest methods", {
  # skip_on_cran()

  s <- session("http://rstudio.com/")
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
  s <- session("http://hadley.nz/")
  expect_equal(s$back, character())
  expect_equal(s$forward, character())
  expect_snapshot_error(session_back(s))
  expect_snapshot_error(session_forward(s))

  s <- session_jump_to(s, "hadley-wickham.jpg")
  expect_equal(s$back, "http://hadley.nz/")
  expect_equal(s$forward, character())

  s <- session_back(s)
  expect_equal(s$back, character())
  expect_equal(s$forward, "http://hadley.nz/")

  s <- session_forward(s)
  expect_equal(s$back, "http://hadley.nz/")
  expect_equal(s$forward, character())
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

# forms ----------------------------------------------------------

test_that("works as expected in simple case", {
  html <- minimal_html('
    <form method="post" action="/test-path">
    <input name="x" value="1">
    <button type="submit" name="clickMe">Click me</button>
    </form>
  ')
  form <- html_form(html, base_url = "http://here.com")[[1]]

  sub <- submission_build(form, "clickMe")
  expect_equal(sub$method, "POST")
  expect_equal(sub$action, "http://here.com/test-path")
  expect_equal(sub$values, list(x = "1"))
})


test_that("useful feedback on invalid forms", {
  html <- minimal_html("<form></form>")
  form <- html_form(html)[[1]]
  expect_snapshot(submission_build(form, NULL), error = TRUE)

  html <- minimal_html("<form action='/' method='foo'></form>")
  form <- html_form(html)[[1]]
  expect_snapshot(x <- submission_build(form, NULL))
})

test_that("can handle multiple values", {
  html <- minimal_html('
    <form method="post" action="/">
    <input type="text" name="x">
    <input type="text" name="y">
    </form>
  ')
  form <- html_form(html)[[1]]
  form <- html_form_set(form, x = c("1", "2", "3"), y = character())

  expect_equal(
    submission_build_values(form),
    list(x = "1", x = "2", x = "3")
  )
})

test_that("handles multiple buttons", {
  html <- minimal_html('
    <form action="/">
    <button type="submit" name="one" value="1">Click me</button>
    <button type="submit" name="two" value="2">Click me</button>
    </form>
  ')
  form <- html_form(html)[[1]]

  # Messages when picking automatically
  expect_snapshot(vals <- submission_build_values(form, NULL))
  expect_equal(vals, list(one = "1"))

  expect_equal(submission_build_values(form, "two"), list(two = "2"))
  expect_equal(submission_build_values(form, 2L), list(two = "2"))

  # Useful failure messages
  expect_snapshot(submission_build_values(form, 3L), error = TRUE)
  expect_snapshot(submission_build_values(form, "three"), error = TRUE)
  expect_snapshot(submission_build_values(form, TRUE), error = TRUE)
})

test_that("handles no buttons", {
  html <- minimal_html('
    <form action="/">
    <input type="text", name="x" value="1">
    </form>
  ')
  form <- html_form(html)[[1]]

  expect_equal(
    submission_build_values(form),
    list(x = "1")
  )
})

test_that("can submit using three primary techniques", {
  app <- webfakes::local_app_process(app_request())

  html <- minimal_html('
    <form action="/">
    <input type="text", name="x" value="1">
    <input type="text", name="x" value="2">
    <input type="text", name="y" value="3">
    </form>
  ')
  form <- html_form(html, base_url = app$url())[[1]]
  session <- session(app$url())

  expect_snapshot({
    show_response(session_submit(session, form))

    "deprecated but still works"
    show_response(submit_form(session, form))

    form$method <- "POST"
    show_response(session_submit(session, form))

    form$enctype <- "multipart"
    show_response(session_submit(session, form))
  })
})
