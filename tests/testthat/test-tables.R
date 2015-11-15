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

test_that("a table with colspan only is correctly parsed", {
  select <- minimal_html("table parsing", '
                         <table class="reference" style="width:100%">
                         <tr>
                         <th colspan="4">Data Columns</th>
                         </tr>
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
                         <td>4</td>
                         <td>Jill</td>
                         <td>Smith</td>
                         <td>50</td>
                         </tr>
                         </table>')
  table <- select %>% html_node("table") %>% html_table(fill=T)
  expect_equal(table$`Data Columns`, c('Number', '1', '4'))
  expect_equal(colnames(table), c("Data Columns", rep(NA, 3)))
})

test_that("a table with a complex rowspan is correctly parsed", {
  select <- minimal_html("table parsing", '
                         <table class="reference" style="width:100%">
                         <tr>
                         <th>State</th>
                         <th>Name</th>
                         <th>Eye Color</th>
                         </tr>
                         <tr>
                         <td>OR</td>
                         <td>Eve</td>
                         <td rowspan="5">Brown</td>
                         </tr>
                         <tr>
                         <td rowspan=3>AK</td>
                         <td>Jill</td>
                         </tr>
                         <tr>
                         <td>John</td>
                         </tr>
                         <tr>
                         <td>Adam</td>
                         </tr>
                         <tr>
                         <td rowspan="2">OH</td>
                         <td>Jim</td>
                         </tr>
                         <tr>
                         <td>Tony</td>
                         <td>Blue</td>
                         </tr>
                         </table>')
  table <- select %>% html_node("table") %>% html_table()
  states <- c('OR', 'AK', 'AK', 'AK', 'OH', 'OH')
  names <- c('Eve', 'Jill', 'John', 'Adam', 'Jim', 'Tony')
  expect_equal(table$State, states)
  expect_equal(table$Name, names)
})

test_that("a table with both rowspan and colspan issues is correctly parsed", {
  select <- minimal_html("table parsing", '
                         <table class="reference" style="width:100%">
                         <tr>
                         <th colspan="3">Data Columns</th>
                         </tr>
                         <tr>
                         <th>State</th>
                         <th>Name</th>
                         <th>Eye Color</th>
                         </tr>
                         <tr>
                         <td>OR</td>
                         <td>Eve</td>
                         <td rowspan="5">Brown</td>
                         </tr>
                         <tr>
                         <td rowspan=3>AK</td>
                         <td>Jill</td>
                         </tr>
                         <tr>
                         <td>John</td>
                         </tr>
                         <tr>
                         <td>Adam</td>
                         </tr>
                         <tr>
                         <td rowspan="2">OH</td>
                         <td>Jim</td>
                         </tr>
                         <tr>
                         <td>Tony</td>
                         <td>Blue</td>
                         </tr>
                         </table>')
  table <- select %>% html_node("table") %>% html_table(fill=T)
  states <- c('OR', 'AK', 'AK', 'AK', 'OH', 'OH')
  names <- c('Eve', 'Jill', 'John', 'Adam', 'Jim', 'Tony')
  expect_equal(table$`Data Columns`, c('State', states))
  expect_equal(colnames(table), c('Data Columns', NA, NA))
})
