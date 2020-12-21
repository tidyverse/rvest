test_that("basic session process works as expected", {
  skip_on_cran()

  expect_snapshot({
    s <- html_session("http://hadley.nz/")
    s
    expect_true(is_session(s))

    s <- jump_to(s, "hadley-wickham.jpg")
    session_history(s)

    s <- back(s)
    s <- follow_link(s, css = "p a")
    session_history(s)
  })
})

test_that("session responds to httr and rvest methods", {
  # skip_on_cran()

  s <- html_session("http://rstudio.com/")
  expect_silent(html_form(s))
  # expect_silent(html_table(s))
  expect_silent(html_node(s, "body"))
  expect_silent(html_nodes(s, "body"))

  expect_silent(status_code(s))
  expect_silent(headers(s))
  expect_silent(cookies(s))
})
