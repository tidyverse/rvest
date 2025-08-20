test_that("can find from from doc, nodes, and node", {
  html <- minimal_html('
    <form><input name="x" type="text"></form>
    <form><input name="x" type="text"></form>
  ')

  forms <- html_form(html)
  expect_type(forms, "list")
  expect_length(forms, 2)

  forms <- html_form(html_elements(html, "form"))
  expect_type(forms, "list")
  expect_length(forms, 2)

  form <- html_form(html_element(html, "form"))
  expect_s3_class(form, "rvest_form")
})

test_that("has useful print method", {
  html <- minimal_html('
    <form id="test" method="post" action="/test-path">
      <select name="select" size="1"></select>
      <input type="text" name="name" value="Hadley" />
      <input type="password" name="name" value="Hadley" />
      <button type="submit" name="clickMe">Click me</button>
      <textarea name="address">ABCDEF</textarea>
    </form>
  ')
  expect_snapshot(html_form(html, base_url = "http://google.com")[[1]])
  expect_snapshot(html_form(html)[[1]]$fields[[2]])
})


test_that("select options are named character vector", {
  select <- minimal_html("select parsing", '
    <form>
      <select name="x">
        <option value="1">a</option>
        <option value="2">b</option>
      </select>
    </form>
  ')

  form <- select |> html_element("form") |> html_form()
  expect_equal(form$fields[[1]]$options, c(a = "1", b = "2"))
})

test_that("select values are inherited from names", {
  page <- minimal_html("optional values", '
    <select name="b" id="a">
      <option value="1">x</option>
      <option>y</option>
    </select>
  ')

  opts <- page |> html_element('select') |> parse_select()
  expect_equal(opts$options, c(x = "1", y = "y"))
})

test_that("parse_fields gets the button", {
  select <- minimal_html("button test", '
    <form>
      <button type="submit">Click me</button>
    </form>
  ')

  form <- select |> html_element("form") |> html_form()
  expect_equal(form$fields[[1]]$type, "button")
})

test_that("handles different encoding types", {
  expect_equal(convert_enctype(NULL), "form")
  expect_equal(convert_enctype("application/x-www-form-urlencoded"), "form")
  expect_equal(convert_enctype("multipart/form-data"), "multipart")

  expect_snapshot(convert_enctype("unknown"))
})

test_that("validates its inputs", {
  select <- minimal_html("button test", '
    <form>
      <button type="submit">Click me</button>
    </form>
  ')
  expect_snapshot(error = TRUE, {
    html_form(html_element(select, "button"))
    html_form(select, base_url = 1)
  })

})

# set --------------------------------------------------------------

test_that("can set values of inputs", {
  html <- minimal_html('
    <form id="test" method="post" action="/test-path">
      <input type="text" name="text" />
      <input type="hidden" name="hidden" />
    </form>
  ')
  form <- html_form(html)[[1]]

  form <- html_form_set(form, text = "abc")
  expect_equal(form$fields$text$value, "abc")

  # warns that setting hidden field
  expect_snapshot(form <- html_form_set(form, hidden = "abc"))
  expect_equal(form$fields$hidden$value, "abc")
})

test_that("has informative errors", {
  html <- minimal_html('
    <form id="test" method="post" action="/test-path">
      <input type="submit" name="text" />
    </form>
  ')

  form <- html_form(html)[[1]]
  expect_snapshot(html_form_set(form, text = "x"), error = TRUE)
  expect_snapshot(html_form_set(form, missing = "x"), error = TRUE)
})

# submit ------------------------------------------------------------------

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
  app <- local_test_app()

  html <- minimal_html('
    <form action="/">
    <input type="text", name="x" value="1">
    <input type="text", name="x" value="2">
    <input type="text", name="y" value="3">
    </form>
  ')
  form <- html_form(html, base_url = app$url())[[1]]

  expect_snapshot({
    show_response(html_form_submit(form))

    form$method <- "POST"
    show_response(html_form_submit(form))

    form$enctype <- "multipart"
    show_response(html_form_submit(form))
  })
})
