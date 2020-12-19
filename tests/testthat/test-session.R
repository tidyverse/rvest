test_that("basic session process works as expected", {
  skip_on_cran()

  expect_snapshot({
    s <- html_session("http://hadley.nz/")
    s

    s <- jump_to(s, "hadley-wickham.jpg")
    session_history(s)

    s <- back(s)
    s <- follow_link(s, css = "p a")
    session_history(s)
  })
})
