test_that("can find from from doc, nodes, and node", {
  html <- minimal_html("test", '
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
  expect_s3_class(form, "form")
})

test_that("has useful print method", {
  html <- minimal_html("test", '
    <form id="test" method="post" action="/test-path">
      <select name="select" size="1"></select>
      <input type="text" name="name" value="Hadley" />
      <input type="password" name="name" value="Hadley" />
      <button type="submit" name="clickMe">Click me</button>
      <textarea name="address">ABCDEF</textarea>
    </form>
  ')
  expect_snapshot(html_form(html)[[1]])
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
  expect_equal(form$fields[[1]]$type, "submit")
})
