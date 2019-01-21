context("HTML classes")

# --- html_classes ---

test_that("html_classes parses classes correctly", {
  doc <- minimal_html("<div class=\"foo bar baz\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), c("bar", "baz", "foo"))
})

test_that("html_classes drops duplicates", {
  doc <- minimal_html("<div class=\"foo foo bar\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), c("bar", "foo"))
})

test_that("html_classes treats tabs as whitespace", {
  doc <- minimal_html("<div class=\"foo\t\tbar\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), c("bar", "foo"))
})

test_that("html_classes parses multiples spaces correctly", {
  doc <- minimal_html("<div class=\"foo   bar\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), c("bar", "foo"))
})

test_that("html_classes removes leading and trailing spaces", {
  doc <- minimal_html("<div class=\"  foo bar  \"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), c("bar", "foo"))
})

test_that("html_classes works with an element without classes", {
  doc <- minimal_html("<div></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), character())
})

test_that("html_classes works with no class attribute", {
  doc <- minimal_html("<div></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), character())
})

test_that("html_classes works with an empty class attribute", {
  doc <- minimal_html("<div class=\"\"></div>")
  div <- html_node(doc, "div")
  expect_equal(html_classes(div), character())
})

test_that("html_classes works with xml_missing objects", {
  doc <- minimal_html("<div class=\"foo bar\"></div>")
  expect_equal(html_classes(html_node(doc, "daga")), NA_character_)
})

test_that("html_classes works with xml_nodeset objects", {
  doc <- minimal_html("<div class=\"foo bar\"></div><div></div>")
  div <- html_nodes(doc, "div")
  expect_equal(html_classes(div), list(c("bar", "foo"), character()))
})

# --- html_classes<- ----

test_that("html_classes<- works", {
  doc <- minimal_html("<div class=\"foo bar\"></div>")
  div <- html_node(doc, "div")
  html_classes(div) <- c("baz", "hidden")
  expect_equal(xml_attr(div, "class"), "baz hidden")
})

test_that("html_classes<- with NULL removes class attribute", {
  doc <- minimal_html("<div class=\"foo bar\"></div>")
  div <- html_node(doc, "div")
  html_classes(div) <- NULL
  expect_equal(xml_attr(div, "class"), NA_character_)
})

test_that("html_classes<-.xml_nodeset works", {
  doc <- minimal_html("<div class=\"foo\"></div><div></div>")
  divs <- html_nodes(doc, "div")
  html_classes(divs) <- c("baz", "bar")
  expect_equal(xml_attr(divs, "class"), rep("bar baz", 2))
})

test_that("html_classes<-.xml_missing works", {
  doc <- minimal_html("<div class=\"foo\"></div><div></div>")
  x <- html_node(doc, "abdcds")
  html_classes(x) <- c("baz", "bar")
  expect_equal(xml_attr(x, "class"), NA_character_)
})

test_that("html_set_classes works", {
  doc <- minimal_html("<div class=\"foo\"></div>")
  x <- html_node(doc, "div")
  html_set_classes(x, c("baz", "bar"))
  expect_equal(xml_attr(x, "class"), c("bar baz"))
})

# --- html_add_classes

test_that("html_add_classes.xml_node works", {
  doc <- minimal_html("<div class=\"foo bar\"></div>")
  div <- html_node(doc, "div")
  html_add_classes(div, c("bar", "baz"))
  expect_equal(xml_attr(div, "class"), "bar baz foo")
})

test_that("html_add_classes<-.xml_nodeset works", {
  doc <- minimal_html("<div class=\"foo\"></div><div></div>")
  divs <- html_nodes(doc, "div")
  html_add_classes(divs, c("bar", "baz"))
  expect_equal(xml_attr(divs, "class"), c("bar baz foo", "bar baz"))
})

test_that("html_add_classes<-.xml_missing works", {
  doc <- minimal_html("<div class=\"foo\"></div>")
  x <- html_node(doc, "abdcds")
  html_add_classes(x, c("baz", "bar"))
  expect_equal(xml_attr(x, "class"), NA_character_)
})

# --- html_remove_classes

test_that("html_remove_classes.xml_node works", {
  doc <- minimal_html("<div class=\"foo bar\"></div>")
  div <- html_node(doc, "div")
  html_remove_classes(div, c("bar", "baz"))
  expect_equal(xml_attr(div, "class"), "foo")
})

test_that("html_remove_classes<-.xml_nodeset works", {
  doc <- minimal_html("<div class=\"foo bar baz\"></div><div></div>")
  divs <- html_nodes(doc, "div")
  html_remove_classes(divs, c("bar", "baz"))
  expect_equal(xml_attr(divs, "class"), c("foo", NA_character_))
})

test_that("html_remove_classes<-.xml_missing works", {
  doc <- minimal_html("<div class=\"foo\"></div>")
  x <- html_node(doc, "abdcds")
  html_remove_classes(x, c("baz", "bar"))
  expect_equal(xml_attr(x, "class"), NA_character_)
})

# --- html_has_classes ---

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

