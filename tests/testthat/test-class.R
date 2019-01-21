context("HTML classes")

test_that("classes are parsed correctly", {
  doc <- minimal_html("<div class=\"foo bar baz\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), c("bar", "baz", "foo"))
})

test_that("duplicates are dropped", {
  doc <- minimal_html("<div class=\"foo foo bar\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), c("bar", "foo"))
})

test_that("tabs are parsed as whitespace", {
  doc <- minimal_html("<div class=\"foo\t\tbar\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), c("bar", "foo"))
})

test_that("multiple spaces are parsed correctly", {
  doc <- minimal_html("<div class=\"foo   bar\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), c("bar", "foo"))
})

test_that("leading and trailing spaces are parsed correctly", {
  doc <- minimal_html("<div class=\"  foo bar  \"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), c("bar", "foo"))
})

test_that("element with classes is handled correctly", {
  doc <- minimal_html("<div></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), character())
})

test_that("html_classes works with xml_nodeset objects", {
  doc <- minimal_html("<div class=\"foo bar\"></div><div></div>")
  div <- html_nodes(doc, "div")
  expect_equal(html_classes(div, "foo"), list(c("bar", "foo"), character()))
})

test_that("html_has_classes works", {
  doc <- minimal_html("<div class=\"bar foo baz\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_has_classes(div, "foo"), TRUE)
})

test_that("html_has_classes works when not present", {
  doc <- minimal_html("<div class=\"bar baz\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_has_classes(div, "foo"), FALSE)
})

test_that("html_has_classes works when there are no classes", {
  doc <- minimal_html("<div></div>")
  div <- html_node(doc, "div")
  expect_equal(html_has_classes(div, "foo"), FALSE)
})

test_that("html_has_classes works an xml_nodeset", {
  doc <- minimal_html("<div class=\"foo bar\"></div><div></div>")
  div <- html_nodes(doc, "div")
  expect_equal(html_has_classes(div, "foo"), c(TRUE, FALSE))
})

