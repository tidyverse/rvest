test_that("forwards to xml2 functions", {
  html <- minimal_html("test", "<p id ='x'>Hello <i>children</i></p>")
  p <- html_nodes(html, "p")

  expect_equal(html_name(p), "p")
  expect_equal(html_text(p), "Hello children")
  expect_equal(html_attr(p, "id"), "x")
  expect_equal(html_attr(p, "id2"), NA_character_)
  expect_equal(html_attrs(p), list(c(id = "x")))

  expect_equal(html_children(p), html_nodes(html, "i"))
})
