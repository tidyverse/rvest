##------------------------------------------------------------------------------
## Preparations //
##------------------------------------------------------------------------------

## Ensure offline copy of test website //
path_data <- if (basename(getwd()) == "testthat") {
  "data"
} else {
  "tests/testthat/data"
}
dir.create(path_data, recursive = TRUE, showWarnings = FALSE)

html_1 <- file.path(path_data, "test_1.html")
if (!file.exists(html_1)) {
  res <- httr::GET("http://testing-ground.scraping.pro/")
  write(httr::content(res, as = "text"), file = html_1)
}

## Load offline copy //
expect_is(.html <- html(html_1), "HTMLInternalDocument")

## TODO: suggestion #43
## Possibly figure out a way to download the entire website and to being
## able to use sessions as created by `html_session()` (as well as derived
## functionality such as `follow_link()` on such offline content

##------------------------------------------------------------------------------
## Actual tests //
##------------------------------------------------------------------------------

context("follow_link: text")

test_that("valid text", {
  expect_is(s <- html_session("http://testing-ground.scraping.pro/"), "session")
  expect_is(s %>% follow_link("TABLE REPORT", "text"), "session")
})

test_that("invalid text", {
  expect_is(s <- html_session("http://testing-ground.scraping.pro/"), "session")
  expect_error(s %>% follow_link("abcd", "text"))
})

##----------

context("follow_link: CSS")

test_that("simple CSS", {
  expect_is(s <- html_session("http://testing-ground.scraping.pro/"), "session")
  expect_is(s %>% follow_link(".caseblock", "css"), "session")
})

test_that("complex CSS", {
  expect_is(s <- html_session("http://testing-ground.scraping.pro/"), "session")
#   expect_is(s %>% follow_link(".caseblock:nth-child(1) a", "css"), "session")
## TODO: fix #41
  expect_error(s %>% follow_link(".caseblock:nth-child(1) a", "css"))
})

test_that("invalid CSS", {
  expect_is(s <- html_session("http://testing-ground.scraping.pro/"), "session")
  expect_error(s %>% follow_link("abcd", "css"))
})

##----------

context("follow_link: XPath")

test_that("Simple Xpath", {
  expect_is(s <- html_session("http://testing-ground.scraping.pro/"), "session")

  ## Valid XPath expression/selector:
  expect_is(s %>% follow_link(
    '//*[contains(concat( " ", @class, " " ), concat( " ", "caseblock", " " ))]',
    "xpath"), "session")
})

test_that("Complex Xpath", {
  expect_is(s <- html_session("http://testing-ground.scraping.pro/"), "session")
#   expect_is(s %>% follow_link(
#     '//*[contains(concat( " ", @class, " " ), concat( " ", "caseblock", " " )) and (((count(preceding-sibling::*) + 1) = 1) and parent::*)]//a',
#     "xpath"), "session")
## TODO: fix #42
  expect_error(s %>% follow_link(
    '//*[contains(concat( " ", @class, " " ), concat( " ", "caseblock", " " )) and (((count(preceding-sibling::*) + 1) = 1) and parent::*)]//a',
    "xpath"))
})

test_that("Invalid Xpath", {
  expect_is(s <- html_session("http://testing-ground.scraping.pro/"), "session")
  expect_error(s %>% follow_link("abcd", "xpath"))
})

##----------

context("follow_link: position")

test_that("Valid position", {
  expect_is(s <- html_session("http://testing-ground.scraping.pro/"), "session")
  expect_is(s %>% follow_link(1, "position"), "session")
})

test_that("Invalid position", {
  expect_is(s <- html_session("http://testing-ground.scraping.pro/"), "session")
  expect_error(s %>% follow_link(10^3, "position"))
})
