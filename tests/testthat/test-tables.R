context("table parsing")

test_that("a simple table is parsed as a data frame", {
  select <- minimal_html("table parsing", '
    <table class="reference" style="width:100%">
      <tr>
          <th>Number</th>
          <th>First Name</th>
          <th>Last Name</th>
          <th>Points</th>
      </tr>
      <tr>
          <td>1</td>
          <td>Eve</td>
          <td>Jackson</td>
          <td>94</td>
      </tr>
      <tr>
          <td>2</td>
          <td>John</td>
          <td>Doe</td>
          <td>80</td>
      </tr>
      <tr>
          <td>3</td>
          <td>Adam</td>
          <td>Johnson</td>
          <td>67</td>
      </tr>
      <tr>
          <td>4</td>
          <td>Jill</td>
          <td>Smith</td>
          <td>50</td>
      </tr>
    </table>
  ')

  table <- select %>% html_node("table") %>% html_table()
  expect_equal(table$Number, c(1, 2, 3, 4))
  expect_equal(table[["First Name"]], c("Eve", "John", "Adam", "Jill"))
  expect_equal(table[["Last Name"]], c("Jackson", "Doe", "Johnson", "Smith"))
  expect_equal(table$Points, c(94, 80, 67, 50))
})

