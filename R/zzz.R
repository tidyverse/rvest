new_chromote <- NULL

.onLoad <- function(...) {
  new_chromote <<- utils::packageVersion("chromote") >= "0.1.2.9000"

  invisible()
}
