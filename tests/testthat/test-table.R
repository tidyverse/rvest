test_that("can parse simple table", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td>1</td><td>Eve</td><td>Jackson</td></tr>
      <tr><td>2</td><td>John</td><td>Doe</td></tr>
      </tr>
    </table>
  '
  )
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("strips whitespace", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x</th></tr>
      <tr><td>    x</td></tr>
      <tr><td>x  </td></tr>
      <tr><td>  x  </td></tr>
      </tr>
    </table>
  '
  )
  table <- html_table(html)[[1]]
  expect_equal(table$x, c("x", "x", "x"))
})


test_that("can parse with colspan", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td colspan="3">1</td></tr>
      <tr><td colspan="2">1</td><td>2</td></tr>
      <tr><td>1</td><td colspan="2">2</td></tr>
      </tr>
    </table>
  '
  )
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can parse with rowspan", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td rowspan="3">1</td><td>2</td><td>3</td></tr>
      <tr><td rowspan="2">2</td><td>3</td></tr>
      <tr><td>3</td></tr>
      </tr>
    </table>
  '
  )

  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can handle wobbling rowspan", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td rowspan="2">1a</td><td>1b</td><td rowspan="2">1c</td></tr>
      <tr><td rowspan="2">2b</td></tr>
      <tr><td>3a</td><td>3c</td></tr>
      </tr>
    </table>
  '
  )
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can handle trailing rowspans", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr>
        <td>1</td>
        <td rowspan="4">2</td>
        <td rowspan="2">3</td>
      </tr>
    </table>
  '
  )
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can handle blank colspans", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x</th><th>y</th></tr>
		  <tr>
        <td colspan="">1</td>
        <td colspan="">2</td>
      </tr>
      <tr><td colspan=2>3</td></tr>
    </table>
  '
  )
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can handle blank rowspans", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x</th><th>y</th></tr>
       <tr>
         <td rowspan="">1</td>
         <td rowspan="">2</td>
       </tr>
       <tr><td colspan=2>3</td></tr>
     </table>
  '
  )
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can handle empty row", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x</th></tr>
      <tr></tr>
      <tr><td>2</td></tr>
      </tr>
    </table>
  '
  )
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})


test_that("defaults to minimal name repair", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x</th><th>x</th><th></th></tr>
    </table>
  '
  )
  table <- html_table(html)[[1]]
  expect_named(table, c("x", "x", ""))
})

test_that("adds names if needed", {
  html <- minimal_html(
    '
    <table>
      <tr><td>1</td><td>2</td></tr>
    </table>
  '
  )
  table <- html_table(html)[[1]]
  expect_named(table, c("X1", "X2"))
})


test_that("passes arguments to type.convert", {
  html <- minimal_html(
    "
    <table>
      <tr><th>x<th>y
      <tr><td>NA<td>1,2
    </table>
  "
  )
  table <- html_table(html, na.strings = "")[[1]]
  expect_equal(table$x, "NA")

  table <- html_table(html, dec = ",")[[1]]
  expect_equal(table$y, 1.2)
})

test_that("no conversion", {
  html <- minimal_html(
    '
    <table>
      <tr><th>x<th>y
      <tr><td>001<td>100.0
    </table>
  '
  )
  table <- html_table(html, convert = FALSE)[[1]]
  expect_snapshot_output(table)
})


test_that("html_table(fill) is deprecated", {
  html <- minimal_html("<table><tr><td>1</td></tr></table>")
  expect_snapshot({
    . <- html_table(html, fill = TRUE)
  })
})

test_that("html_table(fill) deprecation blames the caller", {
  local_options(lifecycle_verbosity = "warning")
  html <- minimal_html("<table><tr><td>1</td></tr></table>")
  user_fun <- function(x) {
    # Otherwise lifecycle treats all code in rvest as direct usage
    old <- Sys.getenv("TESTTHAT_PKG")
    Sys.setenv(TESTTHAT_PKG = "")
    on.exit(Sys.setenv(TESTTHAT_PKG = old))

    . <- html_table(x, fill = TRUE)
  }
  environment(user_fun) <- new_environment(parent = global_env())

  expect_snapshot({
    user_fun(html)
    user_fun(html_elements(html, "table"))
    user_fun(html_element(html, "table"))
  })
})

test_that("can handle empty tables", {
  html <- minimal_html('<table></table>')
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can handle tables consisting of a single empty row", {
  html <- minimal_html('<table><tr></tr></table>')
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can handle tables consisting of only empty rows", {
  html <- minimal_html('<table><tr></tr><tr></tr></table>')
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("html_table2() uses html_text2() to extract cell text", {
  html <- minimal_html(
    "<table>
      <tr><th>x</th><th>y</th></tr>
      <tr><td>a<br>b</td><td>1</td></tr>
    </table>"
  )
  table <- html_table2(html)[[1]]
  expect_equal(table$x, "a\nb")

  table1 <- html_table(html)[[1]]
  expect_equal(table1$x, "ab")
})

test_that("html_table2() works with all inputs", {
  html <- minimal_html(
    "<table><tr><th>x</th></tr><tr><td>1</td></tr></table>"
  )
  expect_equal(html_table2(html)[[1]], tibble::tibble(x = 1L))
  expect_equal(
    html_table2(html_elements(html, "table")),
    list(tibble::tibble(x = 1L))
  )
  expect_equal(
    html_table2(html_element(html, "table")),
    tibble::tibble(x = 1L)
  )
})

test_that("html_table2() respects arguments", {
  html <- minimal_html(
    "<table><tr><td>a</td></tr><tr><td>1</td></tr></table>"
  )
  expect_named(html_table2(html, header = TRUE)[[1]], "a")
})
