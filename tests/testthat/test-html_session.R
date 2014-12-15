context("html_session: additional args")

test_that("additional args for html_session()", {
  expect_is(s <- html_session("https://www.aldi-sued.de/",
    httr::user_agent("Mozilla/5.0")), "session")

  ## `i` is text that should be matched:
  expect_is(s %>% follow_link("Angebote"), "session")

  ## `i` is valid selector:
  expect_is(s %>% follow_link(".m-first"), "session")

  ## `i` is invalid selector:
  expect_error(s %>% follow_link("abcd"))
})

test_that("additional args for html_session()", {
  expect_is(s <- html_session(
    "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=ssd",
    httr::user_agent("Mozilla/5.0")), "session")

  ## `i` is text that should be matched:
  expect_is(s %>% follow_link("Prime"), "session")

  ## `i` is valid selector:
  expect_is(s %>% follow_link(
    "#result_0 .a-spacing-base+ .a-spacing-mini .a-spacing-none"), "session")

  ## `i` is invalid selector:
  expect_error(s %>% follow_link("abcd"))
})

