test_that("can print and subset", {
  session <- test_session()

  # can extract from page
  sections <- session %>% html_elements("#main section")

  expect_snapshot({
    sections
    sections[1:2]
    sections[[1]]
  })
})

test_that("can find multiple elements", {
  session <- test_session()

  # can extract from page
  sections <- session %>% html_elements("#main section")
  expect_length(sections, 7)

  # can extract from other elements
  p <- sections %>% html_elements("p")
  expect_length(p, 33)
})

test_that("can find single element", {
  session <- test_session()

  # can extract from page
  sections <- session %>% html_element("#main")
  expect_length(sections, 1)

  # can find from elements
  h2 <- session %>% html_elements("#main section") %>% html_element("h2")
  expect_length(h2, 7)
})
