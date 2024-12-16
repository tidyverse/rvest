new_chromote <- NULL

.onLoad <- function(...) {
  S7::methods_register()

  if (is_installed("chromote")) {
    new_chromote <<- utils::packageVersion("chromote") >= "0.1.2.9000"
  } else {
    # If chromote is not installed yet, assume it's not new to be safe.
    new_chromote <- FALSE
  }

  invisible()
}

# enable usage of <S7_object>@name in package code
#' @rawNamespace if (getRversion() < "4.3.0") importFrom("S7", "@")
NULL
