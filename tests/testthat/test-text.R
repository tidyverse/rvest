test_that("handles block containing only inline elements", {
  html <- minimal_html("test", "<p>a <b>b</b> <b><i>c</i></b></p>")
  expect_equal(html_text_inner(html_node(html, "p")), "a b c")
})

test_that("handles multiple paragraphs with line breaks", {
  html <- minimal_html("test", "
    <body>
      <p>a
      <p>b<br>c
    </body>")
  expect_equal(html_text_inner(html_node(html, "body")), "a\n\nb\nc")
})

test_that("handles table", {
  html <- minimal_html("test", "
    <table>
    <tr><th>a<th>b
    <tr><td>1<td>2
    <tr><td>2<td>3
    </table>
  ")

  expect_equal(
    html_text_inner(html_node(html, "table")),
    "a\tb\n1\t2\n2\t3"
  )
})


test_that("breaks as expected", {
  expect_identical(tag_margin("p"), 2L)
  expect_identical(tag_margin("li"), 1L)
  expect_identical(tag_margin("b"), 0L)
})

# inline ------------------------------------------------------------------

test_that("handle single line of text", {
  html <- minimal_html("test", "<p>a <b>b</b> <b><i>c</i></b></p>")
  expect_equal(html_text_inline(html_node(html, "p")), "a b c")

  # collapses space across nodes
  html <- minimal_html("test", "<p>a <b>b </b> <b> c</b></p>")
  expect_equal(html_text_inline(html_node(html, "p")), "a b c")
})

test_that("converts br to \n", {
  html <- minimal_html("test", "<p><br>x</p>")
  expect_equal(html_text_inline(html_node(html, "p")), "\nx")

  html <- minimal_html("test", "<p>x<br></p>")
  expect_equal(html_text_inline(html_node(html, "p")), "x\n")

  html <- minimal_html("test", "<p><br><br></p>")
  expect_equal(html_text_inline(html_node(html, "p")), "\n\n")
})

test_that("empty block returns empty string", {
  html <- minimal_html("test", "<p></p>")
  expect_equal(html_text_inline(html_node(html, "p")), "")
})

test_that("collapse whitespace handles single line", {
  expect_equal(collapse_whitespace("\n\tx\t\n"), "x")
  expect_equal(collapse_whitespace("x  y"), "x y")
})

# PaddedText --------------------------------------------------------------

test_that("margins only added within text", {
  text <- PaddedText$new()
  text$add_margin(1)
  text$add_text("x")
  text$add_margin(1)

  expect_equal(text$output(), "x")
})

test_that("margins are collapsed", {
  text <- PaddedText$new()
  text$add_text("x")
  text$add_margin(1)
  expect_equal(text$lines, 1)
  text$add_margin(2)
  expect_equal(text$lines, 2)
  text$add_text("y")
  expect_equal(text$output(), "x\n\ny")
})

test_that("empty text is ignored", {
  text <- PaddedText$new()
  text$add_text("")
  text$add_margin(1)
  text$add_text("x")

  expect_equal(text$output(), "x")
})