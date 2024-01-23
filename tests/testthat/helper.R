local_test_app <- function(envir = parent.frame()) {
  skip_if_not_installed("webfakes")

  webfakes::local_app_process(app_request(), .local_envir = envir)
}

app_request <- function() {
  req_json <- function(req, res) {
    out <- list(
      method = req$method,
      query = req$query_string,
      type = req$headers$`Content-Type` %||% NA_character_,
      body = rawToChar(req$.body %||% raw())
    )
    res$send_json(out, auto_unbox = TRUE)
  }

  app <- webfakes::new_app()
  app$post("/", req_json)
  app$get("/", req_json)
  app
}


show_response <- function(x) {
  strip_divider <- function(x) {
    gsub("-{3,}[a-f0-9]+", "---<divider>", x)
  }

  x <- httr::content(x)

  cat_line(toupper(x$method), " ", strip_divider(x$type))
  cat_line("Query string: ", x$query)
  cat_line(strip_divider(x$body))
}
