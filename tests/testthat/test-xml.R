test_that("xml functions are deprecated", {
  x <- minimal_html("test", "<p>Hello</p>")

  expect_snapshot(. <- xml_tag(x))
  expect_snapshot(. <- xml_node(x, "p"))
  expect_snapshot(. <- xml_nodes(x, "p"))
})
