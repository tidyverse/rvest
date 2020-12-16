#' Modify and submit a form
#'
#' Once you've extracted a form from a page with [html_form()] use
#' [form_set()] to modify its values and [form_submit()] to submit it.
#'
#' @section rvest 1.0.0:
#' `r lifecycle::badge("deprecated")`
#'
#' In rvest 1.0.0, `set_values()` was deprecated in favor of
#' `form_set()` and `submit_form()` in favor of `form_submit()`.
#' Note that the argument order of `form_submit()` is different in order
#' to facilitate use in a pipe
#'
#' @param form An [html_form()].
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Name-value pairs giving
#'   fields to modify.
#' @return `set_values()` returns an updated form object;
#'   `submit_form()` returns the parsed HTML response (or an error if the
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
#' @param config Additional config passed on to [httr::GET()]
#'   or [httr::POST()]
#' @rdname form_set
#' @export
form_submit <- function(form, session, submit = NULL, config = list(), ...) {
  request <- submission_build(form, submit, base_url = session$url)

  if (!missing(...)) {
    lifecycle::deprecate_warn("1.0.0",
      "submit_form(... = )",
      "submit_form(config = )"
    )
  }

  if (request$method == "GET") {
    request_GET(session,
      url = url,
      query = request$values,
      ...,
      config
    )
  } else if (request$method == "POST") {
    request_POST(session,
      url = url,
      body = request$values,
      encode = request$encode,
      ...,
      config
    )
  } else {
    stop("Unknown method: ", request$method, call. = FALSE)
  }
}

#' @rdname form_set
#' @export
set_values <- function(form, ...) {
  lifecycle::deprecate_warn("1.0.0", "set_values()", "form_set()")
  form_set(form = form, ...)
}

#' @rdname form_set
#' @export
submit_form <- function(session, form, submit = NULL, config = list(), ...) {
  lifecycle::deprecate_warn("1.0.0", "submit_form()", "form_submit()")
  form_set(form = form, session = session, submit = submit, config = list(), ...)
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

check_fields <- function(form, values) {
  no_match <- setdiff(names(values), names(form$fields))
  if (length(no_match) > 0) {
    str <- paste("'", no_match, "'", collapse = ", ")
    abort(paste0("Can't set value of fields that don't exist: ", str))
  }
}
