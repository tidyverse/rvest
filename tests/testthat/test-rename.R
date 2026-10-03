test_that("html_node(s) is superseded (no warnings)", {
  x <- minimal_html("<p>Hello</p>")

  expect_equal(html_node(x, "p"), html_element(x, "p"))
  expect_equal(html_nodes(x, "p"), html_elements(x, "p"))
})
