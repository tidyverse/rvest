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
    gsub("-{3,}[A-Za-z0-9-]+", "---{divider}", x)
  }

  x <- httr::content(x)

  cat_line(toupper(x$method), " ", strip_divider(x$type))
  cat_line("Query string: ", x$query)
  cat_line(strip_divider(x$body))
}


# chromote ----------------------------------------------------------------

skip_if_no_chromote <- function() {
  skip_on_cran()
  skip_if(lacks_chromote(), "chromote not available")

  # On CI we have to opt-in to testlive
  skip_if(Sys.getenv("CI") == "true" && Sys.getenv('testlive') == "")
}

lacks_chromote <- function() {
  # We try twice because in particular Windows on GHA seems to need it,
  # but it doesn't otherwise hurt. More details at
  # https://github.com/rstudio/shinytest2/issues/209
  env_cache(the, "lacks_chromote", !has_chromote() && !has_chromote())
}

html_test_path <- function(name) {
  paste0("file://", normalizePath(test_path(paste0("html/", name, ".html"))))
}
