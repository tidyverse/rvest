#' Modify and submit a form
#'
#' Once you've extracted a form from a page with [html_form()] use
#' [form_set()] to modify its values and [form_submit()] to submit it.
#'
#' @param form An [html_form()].
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Name-value pairs giving
#'   fields to modify.
#'
#'   Provide a character vector to set multiple checkboxes in a set or
#'   select multiple values from a multi-select.
#' @return `form_set()` returns an updated form object;
#'   `form_submit()` returns an HTML session object.
#'   HTTP request fails).
#' @export
#' @examples
#' session <- html_session("http://www.google.com")
#' search <- html_form(session)[[1]]
#'
#' \dontrun{
#' search %>%
#'   set_values(q = "My little pony", hl = "fr") %>%
#'   submit_form(session)
#' }
#'
#' # If you have a list of values, use !!!
#' vals <- list(q = "web scraping", hl = "en")
#' search %>% set_values(!!!vals)
form_set <- function(form, ...) {
  check_form(form)

  new_values <- list2(...)
  check_fields(form, new_values)

  for (field in names(new_values)) {
    type <- form$fields[[field]]$type %||% "non-input"
    if (type == "hidden") {
      warn(paste0("Setting value of hidden field '", field, "'."))
    } else if (type == "submit") {
      abort(paste0("Can't change value of input with type submit: '", field, "'."))
    }

    form$fields[[field]]$value <- new_values[[field]]
  }

  form
}

#' @param session An [html_session()].
#' @param submit Which button should be used?
#'   * `NULL`, the default, uses the first.
#'   * A string selects a button by its name.
#'   * A number selects a button based on it relative position.
#' @rdname form_set
#' @export
form_submit <- function(form, session, submit = NULL, ...) {
  check_form(form)

  request <- submission_build(form, submit, base_url = session$url)

  if (!missing(...)) {
    abort(paste0("`...` no longer supported; please set httr options in html_sessions()"))
  }

  if (request$method == "POST") {
    session_request(session,
      method = "POST",
      url = request$url,
      body = request$values,
      encode = request$enctype
    )
  } else {
    session_request(session,
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
