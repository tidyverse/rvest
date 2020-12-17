test_that("can parse simple table", {
  html <- minimal_html("test", '
    <table class="reference" style="width:100%">
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td>1</td><td>Eve</td><td>Jackson</td></tr>
      <tr><td>2</td><td>John</td><td>Doe</td></tr>
      </tr>
    </table>
  ')
  table <- tibble::as_tibble(html_table(html)[[1]])
  expect_snapshot_output(table)
})

test_that("can parse with colspan", {
  html <- minimal_html("test", '
    <table class="reference" style="width:100%">
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td colspan="3">1</td></tr>
      <tr><td colspan="2">1</td><td>2</td></tr>
      <tr><td>1</td><td colspan="2">2</td></tr>
      </tr>
    </table>
  ')
  table <- tibble::as_tibble(html_table(html)[[1]])
  expect_snapshot_output(table)
})

test_that("can parse with rowspan", {
  html <- minimal_html("test", '
    <table class="reference" style="width:100%">
      <tr><th>x</th><th>y</th><th>z</th></tr>
      <tr><td rowspan="3">1</td><td>2</td><td>3</td></tr>
      <tr><td rowspan="2">2</td><td>3</td></tr>
      <tr><td>3</td></tr>
      </tr>
    </table>
  ')
<<<<<<< HEAD:tests/testthat/test-tables.R
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
||||||| parent of d860bea... Restart with simpler tests:tests/testthat/test-table.R
  table <- select %>% html_node("table") %>% html_table(fill=T)
  col1 <- c(rep('Categorical Columns', 2), 'A', NA)
  col2 <- c(rep('Categorical Columns', 2), 'Small', NA)
  col3 <- c(45, 95, 1, NA)
  col4 <- c(NA, NA, 2.3, 4)
  expect_equal(table$`Categorical Columns`, col1)
  expect_equal(table$`Numerical Columns`, col3)
  expect_equal(table[, 2], col2)
  expect_equal(table[, 4], col4)
  expect_equal(colnames(table),
               c(rep('Categorical Columns', 2),
                 rep('Numerical Columns', 2)))
})

test_that("Test rowspans are respected when fill=True", {
  select <- minimal_html("table parsing", '
    <table>
    	<thead>
    		<tr>
    			<th>Lorem</th>
    			<th>ipsum</th>
    			<th colspan="2">dolor sit</th>
    		</tr>
    	</thead>
    	<tbody>
    		<tr>
    			<td rowspan="3">amet</td>
    			<td>consectetur adipiscing</td>
    			<td rowspan="2"></td>
    			<td rowspan="2">elit sed do</td>
    		</tr>
    		<tr>
    			<td>eiusmod tempor</td>
    		</tr>
    		<tr>
    			<td>incididunt ut labore</td>
    			<td></td>
    			<td>et</td>
    		</tr>
    		<tr>
    			<td rowspan="3">dolore</td>
    			<td>magna aliqua</td>
    			<td></td>
    			<td>ut</td>
    		</tr>
    		<tr>
    			<td>enim ad</td>
    			<td rowspan="2"></td>
    			<td rowspan="2">minim veniam quis</td>
    		</tr>
    		<tr>
    			<td>nostrud exercitation</td>
    		</tr>
    		<tr>
    			<td rowspan="4"><ah>irure</td>
    			<td>dolor</td>
    			<td rowspan="2"></td>
    			<td rowspan="2">in reprehenderit</td>
    		</tr>
    		<tr>
    			<td>in voluptate</td>
    		</tr>
    		<tr>
    			<td>nulla</td>
    			<td rowspan="2"></td>
    			<td rowspan="2">pariatur</td>
    		</tr>
    		<tr>
    			<td>excepteur</td>
    		</tr>
    	</tbody>
    </table>'
  )


  table <- select %>%
    html_node('table') %>% html_table(fill=T)

  row1 <- c('amet', 'incididunt ut labore', 'NA', 'et')
  row2 <- c('dolore', 'magna aliqua', 'NA', 'ut')
  row3 <- c('irure', 'excepteur', 'NA', 'pariatur')

  expect_equal(as.character(table[3,]), row1)
  expect_equal(as.character(table[4,]), row2)
  expect_equal(as.character(table[10,]), row3)
})
=======
  table <- tibble::as_tibble(html_table(html)[[1]])
  expect_snapshot_output(table)
})
>>>>>>> d860bea... Restart with simpler tests:tests/testthat/test-table.R
