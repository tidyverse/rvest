test_that("can parse simple table", {
  html <- minimal_html("test", '
    <table>
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td>1</td><td>Eve</td><td>Jackson</td></tr>
      <tr><td>2</td><td>John</td><td>Doe</td></tr>
      </tr>
    </table>
  ')
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("strips whitespace", {
  html <- minimal_html("test", '
    <table>
      <tr><th>x</th></tr>
      <tr><td>    x</td></tr>
      <tr><td>x  </td></tr>
      <tr><td>  x  </td></tr>
      </tr>
    </table>
  ')
  table <- html_table(html)[[1]]
  expect_equal(table$x, c("x", "x", "x"))
})


test_that("can parse with colspan", {
  html <- minimal_html("test", '
    <table>
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td colspan="3">1</td></tr>
      <tr><td colspan="2">1</td><td>2</td></tr>
      <tr><td>1</td><td colspan="2">2</td></tr>
      </tr>
    </table>
  ')
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can parse with rowspan", {
  html <- minimal_html("test", '
    <table>
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td rowspan="3">1</td><td>2</td><td>3</td></tr>
      <tr><td rowspan="2">2</td><td>3</td></tr>
      <tr><td>3</td></tr>
      </tr>
    </table>
  ')

  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can handle wobbling rowspan", {
  html <- minimal_html("test", '
    <table>
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td rowspan="2">1a</td><td>1b</td><td rowspan="2">1c</td></tr>
      <tr><td rowspan="2">2b</td></tr>
      <tr><td>3a</td><td>3c</td></tr>
      </tr>
    </table>
  ')
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})

test_that("can handle trailing rowspans", {
  html <- minimal_html("test", '
    <table>
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr>
        <td>1</td>
        <td rowspan="4">2</td>
        <td rowspan="2">3</td>
      </tr>
    </table>
  ')
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)

})

test_that("can handle empty row", {
  html <- minimal_html("test", '
    <table>
      <tr><th>x</th></tr>
      <tr></tr>
      <tr><td>2</td></tr>
      </tr>
    </table>
  ')
  table <- html_table(html)[[1]]
  expect_snapshot_output(table)
})


test_that("defaults to minimal name repair", {
  html <- minimal_html("test", '
    <table>
      <tr><th>x</th><th>x</th><th></th></tr>
    </table>
  ')
  table <- html_table(html)[[1]]
  expect_named(table, c("x", "x", ""))
})

test_that("adds names if needed", {
  html <- minimal_html("test", '
    <table>
      <tr><td>1</td><td>2</td></tr>
    </table>
  ')
  table <- html_table(html)[[1]]
  expect_named(table, c("X1", "X2"))
})
