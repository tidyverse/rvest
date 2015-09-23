context("form parsing")

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
