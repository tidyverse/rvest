
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
#' @param submit Name of submit button to use. If not supplied, defaults to
#'   first submission button on the form (with a message).
#' @param ... Additional arguments passed on to [httr::GET()]
#'   or [httr::POST()]
#' @return If successful, the parsed html response. Throws an error if http
#'   request fails.
#' @export
submit_form <- function(session, form, submit = NULL, ...) {
  request <- submit_request(form, submit)

  if (is.null(form$url)) {
    abort("`form` doesn't contain a `action` attribute")
  }
  url <- xml2::url_absolute(form$url, session$url)

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

submit_request <- function(form, submit = NULL) {
  is_submit <- function(x) {
    if (length(x$type) == 0L) {
      return(FALSE)
    }
    tolower(x$type) %in% c("submit", "image", "button")
  }

  submits <- Filter(is_submit, form$fields)
  if (length(submits) == 0) {
    stop("Could not find possible submission target.", call. = FALSE)
  }

  if (is.null(submit)) {
    submit <- names(submits)[[1]]
    inform(paste0("Submitting with '", submit, "'"))
  }
  if (!(submit %in% names(submits))) {
    stop(
      "Unknown submission name '", submit, "'.\n",
      "Possible values: ", paste0(names(submits), collapse = ", "),
      call. = FALSE
    )
  }
  other_submits <- setdiff(names(submits), submit)

  # Parameters needed for http request -----------------------------------------
  method <- form$method
  if (!(method %in% c("POST", "GET"))) {
    warning("Invalid method (", method, "), defaulting to GET", call. = FALSE)
    method <- "GET"
  }

  url <- form$url

  fields <- form$fields
  fields <- Filter(function(x) length(x$value) > 0, fields)
  fields <- fields[setdiff(names(fields), other_submits)]

  values <- pluck(fields, "value")
  names(values) <- names(fields)

  list(
    method = method,
    encode = form$enctype,
    url = url,
    values = values
  )
}
