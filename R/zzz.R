new_chromote <- NULL

.onLoad <- function(...) {
  if (is_installed("chromote")) {
    new_chromote <<- utils::packageVersion("chromote") >= "0.1.2.9000"
  } else {
    # If chromote is not installed yet, assume it's not new to be safe.
    new_chromote <- FALSE
  }

  invisible()
}
