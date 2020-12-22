#' @param form An [html_form] to submit
#' @param submit Which button should be used?
#'   * `NULL`, the default, uses the first.
#'   * A string selects a button by its name.
#'   * A number selects a button based on it relative position.
#' @rdname html_session
#' @export
session_submit <- function(x, form, submit = NULL, ...) {
  check_form(form)

  request <- submission_build(form, submit, base_url = x$url)

  if (!missing(...)) {
    abort(paste0("`...` no longer supported; please set httr options in html_sessions()"))
  }

  if (request$method == "POST") {
    session_request(x,
      method = "POST",
      url = request$url,
      body = request$values,
      encode = request$enctype
    )
  } else {
    session_request(x,
      method = "GET",
      url = request$url,
      query = request$values
    )
  }
}

submission_build <- function(form, submit, base_url) {
  method <- form$method
  if (!(method %in% c("POST", "GET"))) {
    warn(paste0("Invalid method (", method, "), defaulting to GET"))
    method <- "GET"
  }

  if (is.null(form$action)) {
    abort("`form` doesn't contain a `action` attribute")
  }
  url <- xml2::url_absolute(form$action, base_url)

  list(
    method = method,
    enctype = form$enctype,
    url = url,
    values = submission_build_values(form, submit)
  )
}

submission_build_values <- function(form, submit = NULL) {
  fields <- form$fields
  submit <- submission_find_submit(fields, submit)
  entry_list <- c(Filter(Negate(is_button), fields), list(submit))
  entry_list <- Filter(function(x) !is.null(x$name), entry_list)

  if (length(entry_list) == 0) {
    return(list())
  }

  values <- lapply(entry_list, function(x) as.character(x$value))
  names <- map_chr(entry_list, "[[", "name")

  out <- set_names(unlist(values, use.names = FALSE), rep(names, lengths(values)))
  as.list(out)
}

submission_find_submit <- function(fields, idx) {
  buttons <- Filter(is_button, fields)

  if (is.null(idx)) {
    if (length(buttons) == 0) {
      list()
    } else {
      if (length(buttons) > 1) {
        inform(paste0("Submitting with '", buttons[[1]]$name, "'"))
      }
      buttons[[1]]
    }
  } else if (is.numeric(idx) && length(idx) == 1) {
    if (idx < 1 || idx > length(buttons)) {
      abort("Numeric `submit` out of range")
    }
    buttons[[idx]]
  } else if (is.character(idx) && length(idx) == 1) {
    if (!idx %in% names(buttons)) {
      abort(c(
        paste0("No <input> found with name '", idx, "'."),
        i = paste0("Possible values: ", paste0(names(buttons), collapse = ", "))
      ))
    }
    buttons[[idx]]
  } else {
    abort("`submit` must be NULL, a string, or a number.")
  }
}

is_button <- function(x) {
  tolower(x$type) %in% c("submit", "image", "button")
}

check_fields <- function(form, values) {
  no_match <- setdiff(names(values), names(form$fields))
  if (length(no_match) > 0) {
    str <- paste("'", no_match, "'", collapse = ", ")
    abort(paste0("Can't set value of fields that don't exist: ", str))
  }
}

check_form <- function(x) {
  if (!inherits(x, "rvest_form")) {
    abort("`form` must be produced by rvest_form()")
  }
}
