test_that("can read an httr2 response", {
  skip_if_not_installed("httr2")

  resp <- httr2::response(body = charToRaw("<p>Hello!</p>"))
  html <- read_html(resp)
  expect_equal(html |> html_element("p") |> html_text(), "Hello!")
})

test_that("httr2 response sets base_url", {
  skip_if_not_installed("httr2")

  resp <- httr2::response(
    url = "https://example.com/dir/page.html",
    body = charToRaw("<a href='other.html'>link</a>")
  )
  html <- read_html(resp)
  expect_equal(
    html |> html_element("a") |> html_attr("href"),
    "other.html"
  )
  expect_equal(xml2::xml_url(html), "https://example.com/dir/page.html")
})
