test_that("can find from from doc, nodes, and node", {
  html <- minimal_html('
    <form><input name="x" type="text"></form>
    <form><input name="x" type="text"></form>
  ')

  forms <- html_form(html)
  expect_type(forms, "list")
  expect_length(forms, 2)

  forms <- html_form(html_nodes(html, "form"))
  expect_type(forms, "list")
  expect_length(forms, 2)

  form <- html_form(html_node(html, "form"))
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
  expect_snapshot(html_form(html)[[1]])
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

  form <- select %>% html_node("form") %>% html_form()
  expect_equal(form$fields[[1]]$options, c(a = "1", b = "2"))
})

test_that("select values are inherited from names", {
  page <- minimal_html("optional values", '
    <select name="b" id="a">
      <option value="1">x</option>
      <option>y</option>
    </select>
  ')

  opts <- page %>% html_node('select') %>% parse_select()
  expect_equal(opts$options, c(x = "1", y = "y"))
})

test_that("parse_fields gets the button", {
  select <- minimal_html("button test", '
    <form>
      <button type="submit">Click me</button>
    </form>
  ')

  form <- select %>% html_node("form") %>% html_form()
  expect_equal(form$fields[[1]]$type, "button")
})

test_that("handles different encoding types", {
  expect_equal(convert_enctype(NULL), "form")
  expect_equal(convert_enctype("application/x-www-form-urlencoded"), "form")
  expect_equal(convert_enctype("multipart/form-data"), "multipart")

  expect_snapshot(convert_enctype("unknown"))
})

# form_set --------------------------------------------------------------

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


