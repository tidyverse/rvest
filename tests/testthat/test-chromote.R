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


test_that("can extract text and attributes", {
  session <- test_session()
  sections <- session %>% html_elements("#main section")
  expect_equal(html_attrs(sections[[1]]), list(character()))
  expect_equal(html_attr(sections[[1]], "foo"), NA_character_)

  h2 <- sections %>% html_element("h2")

  expect_equal(
    html_attrs(h2[[1]]),
    list(c(`data-id` = "1", id = "the-phantom-menace"))
  )

  expect_equal(html_attr(h2[1:3], "data-id"), c("1", "2", "3"))
  expect_equal(
    html_text(h2[1:3]),
    c("The Phantom Menace", "Attack of the Clones", "Revenge of the Sith")
  )
})

test_that("even when those elements don't exist", {
  session <- test_session()
  sections <- session %>% html_elements("#main section")
  missing <- sections %>% html_element("foo") %>% .[1:3]

  expect_equal(xml_attrs(missing[[1]]), list(NULL))
  expect_equal(xml_attr(missing, "id"), rep(NA_character_, 3))
  expect_equal(html_text(missing, "id"), rep(NA_character_, 3))
  expect_equal(html_text2(missing, "id"), rep(NA_character_, 3))
})
