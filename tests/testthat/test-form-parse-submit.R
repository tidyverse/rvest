# set_values --------------------------------------------------------------

test_that("can set values of inputs", {
  html <- minimal_html("test", '
    <form id="test" method="post" action="/test-path">
      <input type="text" name="text" />
      <input type="hidden" name="hidden" />
    </form>
  ')
  form <- html_form(html)[[1]]

  form <- set_values(form, text = "abc")
  expect_equal(form$fields$text$value, "abc")

  # warns that setting hidden field
  expect_snapshot(form <- set_values(form, hidden = "abc"))
  expect_equal(form$fields$hidden$value, "abc")
})

# submit_request ----------------------------------------------------------

test_that("submit_request detects submit-buttons correctly", {
  select <- minimal_html("submit test", '
    <form id="suchparameterForm" method="post" action="/test-path">
      <select name="elementWithoutType" size="1">
        <option value="10">10</option>
        <option value="25">25</option>
      </select>
    <button type="submit" name="clickMe">Click me</button>
    </form>
  ')
  form <- select %>% html_node("form") %>% html_form()

  req <- submit_request(form, "clickMe")
  expect_length(req, 4L)
  expect_equal(req$method, "POST")
  expect_equal(req$url, "/test-path")
})
