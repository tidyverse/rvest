test_that("xml functions are deprecated", {
  x <- minimal_html("test", "<p>Hello</p>")

  expect_snapshot(. <- xml_tag(x))
  expect_snapshot(. <- xml_node(x, "p"))
  expect_snapshot(. <- xml_nodes(x, "p"))
})

test_that("set_values() is deprecated", {
  html <- minimal_html("test", '
    <form><input type="text" name="text" /></form>
  ')
  form <- html_form(html)[[1]]
  expect_snapshot(set_values(form, text = "abc"))
})

# submit_form() is tested in form-submit because it needs a test server
