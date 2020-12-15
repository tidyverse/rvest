test_that("multiplication works", {
  skip_on_cran()

  expect_snapshot({
    s <- html_session("http://hadley.nz")
    s

    s <- jump_to(s, "hadley-wickham.jpg")
    session_history(s)

    s <- back(s)
    s <- follow_link(s, 2)
    session_history(s)
  })
})
