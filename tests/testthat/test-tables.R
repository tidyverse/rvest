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
    </table>'
  )
  table <- select %>% html_node("table") %>% html_table(fill=T)
  expect_equal(table$`Data Columns`, c('Number', '1', '4'))
  expect_equal(colnames(table), rep("Data Columns", 4))
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
    </table>'
  )
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
    </table>'
  )
  table <- select %>% html_node("table") %>% html_table(fill=T)
  states <- c('OR', 'AK', 'AK', 'AK', 'OH', 'OH')
  names <- c('Eve', 'Jill', 'John', 'Adam', 'Jim', 'Tony')
  expect_equal(table$`Data Columns`, c('State', states))
  expect_equal(colnames(table), rep('Data Columns', 3))
})

test_that("a table with complex and multiple colspan issues is correctly parsed", {
  select <- minimal_html("table parsing", '
    <table class="reference" style="width:100%">
    <tr>
     <th colspan="2">Categorical Columns</th>
     <th colspan="2">Numerical Columns</th>
    </tr>
    <tr>
     <td>A</th>
     <td>Small</th>
     <td>1.0</th>
     <td>2.3</th>
    </tr>
    <tr>
     <td colspan="3">NA</td>
     <td>4</td>
    </tr>
    </table>'
  )
  table <- select %>% html_node("table") %>% html_table(fill=T)
  col1 <- c('A', NA)
  col2 <- c('Small', NA)
  col3 <- c(1, NA)
  col4 <- c(2.3, 4)
  expect_equal(table$`Categorical Columns`, col1)
  expect_equal(table$`Numerical Columns`, col3)
  expect_equal(table[,2], col2)
  expect_equal(table[,4], col4)
  expect_equal(colnames(table),
               c(rep('Categorical Columns', 2),
                 rep('Numerical Columns', 2)))
})

test_that("a cell with both rowspan and colspan is correctly parsed", {
  select <- minimal_html("table parsing", '
    <table class="reference" style="width:100%">
    <tr>
     <th colspan="2" rowspan="2">Categorical Columns</th>
     <th colspan="2" rowspan="2">Numerical Columns</th>
    </tr>
    <tr></tr>
    <tr>
     <td>A</th>
     <td>Small</th>
     <td>1.0</th>
     <td>2.3</th>
    </tr>
    <tr>
     <td colspan="3">NA</td>
     <td>4</td>
    </tr>
    </table>'
  )
  table <- select %>% html_node("table") %>% html_table(fill=T)
  col1 <- c('Categorical Columns', 'A', NA)
  col2 <- c('Categorical Columns', 'Small', NA)
  col3 <- c('Numerical Columns', "1.0", NA)
  col4 <- c('Numerical Columns', 2.3, 4)
  expect_equal(table$`Categorical Columns`, col1)
  expect_equal(table$`Numerical Columns`, col3)
  expect_equal(table[, 2], col2)
  expect_equal(table[, 4], col4)
  expect_equal(colnames(table),
               c(rep('Categorical Columns', 2),
                 rep('Numerical Columns', 2)))
})

test_that("a correct but slightly pathological table correctly parsed", {
  select <- minimal_html("table parsing", '
    <table class="reference" style="width:100%">
    <tr>
     <th colspan="2" rowspan="3">Categorical Columns</th>
     <th colspan="2" rowspan="1">Numerical Columns</th>
    </tr>
    <tr><th>45</th></tr>
    <tr><th>95</th></tr>
    <tr>
     <td>A</th>
     <td>Small</th>
     <td>1.0</th>
     <td>2.3</th>
    </tr>
    <tr>
     <td colspan="3">NA</td>
     <td>4</td>
    </tr>
    </table>
  ')
  table <- select %>% html_node("table") %>% html_table(fill=T)
  col1 <- c(rep('Categorical Columns', 2), 'A', NA)
  col2 <- c(rep('Categorical Columns', 2), 'Small', NA)
  col3 <- c(rep('Numerical Columns', 2), "1.0", NA)
  col4 <- c(45, 95, 2.3, 4)
  expect_equal(table$`Categorical Columns`, col1)
  expect_equal(table$`Numerical Columns`, col3)
  expect_equal(table[, 2], col2)
  expect_equal(table[, 4], col4)
  expect_equal(colnames(table),
               c(rep('Categorical Columns', 2),
                 rep('Numerical Columns', 2)))
})
