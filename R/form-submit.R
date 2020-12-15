#' Set values in a form
#'
#' @param form Form to modify
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Name-value pairs giving
#'   fields to modify.
#' @return An updated form object
#' @export
#' @examples
#' search <- html_form(read_html("http://www.google.com"))[[1]]
#' set_values(search, q = "My little pony")
#' set_values(search, hl = "fr")
#' \dontrun{set_values(search, btnI = "blah")}
#'
#' # If you have a list of values, use !!!
#' vals <- list(q = "web scraping", hl = "en")
#' set_values(search, !!!vals)
set_values <- function(form, ...) {
  new_values <- list2(...)

  # check for valid names
  no_match <- setdiff(names(new_values), names(form$fields))
  if (length(no_match) > 0) {
    stop("Unknown field names: ", paste(no_match, collapse = ", "),
      call. = FALSE)
  }

  for (field in names(new_values)) {
    type <- form$fields[[field]]$type %||% "non-input"
    if (type == "hidden") {
      warning("Setting value of hidden field '", field, "'.", call. = FALSE)
    } else if (type == "submit") {
      stop("Can't change value of submit input '", field, "'.", call. = FALSE)
    }

    form$fields[[field]]$value <- new_values[[field]]
  }

  form

}

#' Submit a form back to the server.
#'
#' @param session Session to submit form to.
#' @param form Form to submit
#' @param submit Which button should be used?
#'   * `NULL`, the default, uses the first.
#'   * A string selects a button by its name.
#'   * A number selects a button based on it relative position.
#' @param ... Additional arguments passed on to [httr::GET()]
#'   or [httr::POST()]
#' @return If successful, the parsed html response. Throws an error if http
#'   request fails.
#' @export
submit_form <- function(session, form, submit = NULL, ...) {
  request <- submission_build(form, submit, base_url = session$url)

  if (request$method == "GET") {
    request_GET(session,
      url = url,
      query = request$values,
      ...
    )
  } else if (request$method == "POST") {
    request_POST(session,
      url = url,
      body = request$values,
      encode = request$encode,
      ...
    )
  } else {
    stop("Unknown method: ", request$method, call. = FALSE)
  }
}

submission_build <- function(form, submit, base_url) {
  method <- form$method
  if (!(method %in% c("POST", "GET"))) {
    warn(paste0("Invalid method (", method, "), defaulting to GET"))
    method <- "GET"
  }

  url <- form$url
  if (is.null(form$url)) {
    abort("`form` doesn't contain a `action` attribute")
  }
  url <- xml2::url_absolute(form$url, base_url)

  list(
    method = method,
    encode = form$enctype,
    url = url,
    values = submission_build_values(form, submit)
  )
}

submission_build_values <- function(form, submit = NULL) {
  fields <- form$fields
  submit <- submission_find_submit(fields, submit)
  entry_list <- c(Filter(Negate(is_button), fields), list(submit))
  entry_list <- Filter(is_entry, entry_list)

  values <- map_chr(entry_list, "[[", "value")
  names(values) <- map_chr(entry_list, "[[", "name")
  values
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

# https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#constructing-the-form-data-set
is_entry <- function(x) {
  length(x$value) == 1 && !is.null(x$name)
}

is_button <- function(x) {
  if (length(x$type) == 0L) {
    return(FALSE)
  }
  tolower(x$type) %in% c("submit", "image", "button")
}
