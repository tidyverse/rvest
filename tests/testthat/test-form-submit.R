# set_values --------------------------------------------------------------

test_that("can set values of inputs", {
  html <- minimal_html("test", '
    <form id="test" method="post" action="/test-path">
      <input type="text" name="text" />
      <input type="hidden" name="hidden" />
    </form>
  ')
  form <- html_form(html)[[1]]

  form <- form_set(form, text = "abc")
  expect_equal(form$fields$text$value, "abc")

  # warns that setting hidden field
  expect_snapshot(form <- form_set(form, hidden = "abc"))
  expect_equal(form$fields$hidden$value, "abc")
})

test_that("has informative errors", {
  html <- minimal_html("test", '
    <form id="test" method="post" action="/test-path">
      <input type="submit" name="text" />
    </form>
  ')

  form <- html_form(html)[[1]]
  expect_snapshot(form_set(form, text = "x"), error = TRUE)
  expect_snapshot(form_set(form, missing = "x"), error = TRUE)
})

# submission_build ----------------------------------------------------------

test_that("works as expected in simple case", {
  html <- minimal_html("test", '
    <form method="post" action="/test-path">
    <input name="x" value="1">
    <button type="submit" name="clickMe">Click me</button>
    </form>
  ')
  form <- html_form(html)[[1]]

  sub <- submission_build(form, "clickMe", "http://here.com")
  expect_equal(sub$method, "POST")
  expect_equal(sub$url, "http://here.com/test-path")
  expect_equal(sub$values, list(x = "1"))
})


test_that("useful feedback on invalid forms", {
  html <- minimal_html("test", "<form></form>")
  form <- html_form(html)[[1]]
  expect_snapshot(submission_build(form, NULL, base_url = "http://"), error = TRUE)

  html <- minimal_html("test", "<form action='/' method='foo'></form>")
  form <- html_form(html)[[1]]
  expect_snapshot(x <- submission_build(form, NULL, base_url = "http://"))
})

test_that("can handle multiple values", {
  html <- minimal_html("test", '
    <form method="post" action="/">
    <input type="text" name="x">
    <input type="text" name="y">
    </form>
  ')
  form <- html_form(html)[[1]]
  form <- form_set(form, x = c("1", "2", "3"), y = character())

  expect_equal(
    submission_build_values(form),
    list(x = "1", x = "2", x = "3")
  )
})

test_that("handles multiple buttons", {
  html <- minimal_html("test", '
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
  html <- minimal_html("test", '
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


# form_submit -------------------------------------------------------------

test_that("can submit using three primary techniques", {
  html <- minimal_html("test", '
    <form action="/">
    <input type="text", name="x" value="1">
    <input type="text", name="x" value="2">
    <input type="text", name="y" value="3">
    </form>
  ')
  form <- html_form(html)[[1]]

  app <- webfakes::local_app_process(app_request())
  session <- html_session(app$url())

  expect_snapshot({
    show_response(form_submit(form, session))

    "deprecated but still works"
    show_response(submit_form(session, form))

    form$method <- "POST"
    show_response(form_submit(form, session))

    form$enctype <- "multipart"
    show_response(form_submit(form, session))
  })
})
