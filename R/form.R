#' Parse forms in a page.
#'
#' @export
#' @param src A string containing xml, a url or a parsed XML document.
#'   If parsed XML document, also provide the \code{base_url} so relative
#'   actions can be correctly constructed.
#' @param ... Other arguments used by methods.
#' @examples
#' parse_forms("https://hadley.wufoo.com/forms/libraryrequire-quiz/")
#' parse_forms("https://hadley.wufoo.com/forms/r-journal-submission/")
#'
#' library(httr)
#' url <- "http://www.boxofficemojo.com/movies/?id=ateam.htm&adjust_yr=1&p=.htm"
#' html <- content(GET(url), "parsed")
#' forms <- parse_forms(html, base_ur = url)
parse_forms <- function(src, ...) UseMethod("parse_forms")

#' @export
parse_forms.XMLAbstractDocument <- function(src, base_url, ...) {
  forms <- src[sel("form")]
  lapply(forms, parse_form, base_url = base_url)
}

#' @export
parse_forms.character <- function(src, base_url, ...) {
  if (grepl(src, "<|>")) {
    html <- XML::htmlParse(src, ...)
  } else {
    r <- httr::GET(src, ...)
    httr::stop_for_status(r)
    html <- httr::content(r, "parsed")
  }

  parse_forms(html, base_url = r$url)
}

# http://www.w3.org/TR/html401/interact/forms.html
#
# <form>: action (url), type (GET/POST), enctype (form/multipart), id
parse_form <- function(form, base_url) {
  stopifnot(inherits(form, "XMLAbstractNode"), XML::xmlName(form) == "form")

  attr <- as.list(XML::xmlAttrs(form))
  name <- attr$id %||% attr$name %||% "<unnamed>" # for human readers
  method <- toupper(attr$method) %||% "GET"
  enctype <- convert_enctype(attr$enctype)

  url <- XML::getRelativeURL(attr$action, base_url)

  fields <- parse_fields(form)

  structure(
    list(
      name = name,
      method = method,
      url = url,
      enctype = enctype,
      fields = fields
    ),
    class = "form")
}

convert_enctype <- function(x) {
  if (is.null(x)) return("form")
  if (x == "application/x-www-form-urlencoded") return("form")
  if (x == "multipart/form-data") return("multipart")

  warning("Unknown enctype (", x, "). Defaulting to form encoded.",
    call. = FALSE)
  "form"
}

#' @export
print.form <- function(x, indent = 0, ...) {
  cat("<form> '", x$name, "' (", x$method, " ", x$url, ")\n", sep = "")
  print(x$fields, indent = indent + 1)
}

#' @export
format.input <- function(x, ...) {
  paste0("<input ", x$type, "> '", x$name, "': ", x$value)
}

parse_fields <- function(form) {
  raw <- form[sel("input, select, textarea")]

  fields <- lapply(raw, function(x) {
    switch(XML::xmlName(x),
      textarea = parse_textarea(x),
      input = parse_input(x),
      select = parse_select(x)
    )
  })
  names(fields) <- vpluck(fields, "name")
  class(fields) <- "fields"
  fields
}

#' @export
print.fields <- function(x, ..., indent = 0) {
  cat(format_list(x, indent = indent), "\n", sep = "")
}

# <input>: type, name, value, checked, maxlength, id, disabled, readonly, required
# Input types:
# * text/email/url/search
# * password: don't print
# * checkbox:
# * radio:
# * submit:
# * image: not supported
# * reset: ignored (client side only)
# * button: ignored (client side only)
# * hidden
# * file
# * number/range (min, max, step)
# * date/datetime/month/week/time
# * (if unknown treat as text)
parse_input <- function(input) {
  stopifnot(inherits(input, "XMLAbstractNode"), XML::xmlName(input) == "input")
  attr <- as.list(XML::xmlAttrs(input))

  structure(
    list(
      name = attr$name,
      type = attr$type %||% "text",
      value = attr$value,
      checked = attr$checked,
      disabled = attr$disabled,
      readonly = attr$readonly,
      required = attr$required %||% FALSE
    ),
    class = "input"
  )
}

parse_select <- function(select) {
  stopifnot(inherits(select, "XMLAbstractNode"), XML::xmlName(select) == "select")

  attr <- as.list(XML::xmlAttrs(select))
  options <- parse_options(select[sel("option")])

  structure(
    list(
      name = attr$name,
      value = options$value,
      options = options$options
    ),
    class = "select"
  )
}

#' @export
format.select <- function(x, ...) {
  paste0("<select> '", x$name, "' [", length(x$value), "/", length(x$options), "]")
}

parse_options <- function(options) {
  parse_option <- function(option) {
    attr <- as.list(XML::xmlAttrs(option))
    list(
      value = attr$value,
      name = XML::xmlValue(option),
      selected = !is.null(attr$selected)
    )
  }

  parsed <- lapply(options, parse_option)
  value <- vpluck(parsed, "value", character(1))
  name <- vpluck(parsed, "name", character(1))
  selected <- vpluck(parsed, "selected", logical(1))

  list(
    value = value[selected],
    options = setNames(value, name)
  )
}

parse_textarea <- function(textarea) {
  attr <- as.list(XML::xmlAttrs(textarea))

  structure(
    list(
      name = attr$name,
      value = XML::xmlValue(textarea)
    ),
    class = "textarea"
  )
}

#' @export
format.textarea <- function(x, ...) {
  paste0("<textarea> '", x$name, "' [", nchar(x$value), " char]")
}


#' Set values in a form.
#'
#' @param form Form to modify
#' @param ... Name-value pairs giving fields to modify
#' @return An updated form object
#' @export
#' @examples
#' search <- parse_forms("https://www.google.com")[[1]]
#' set_values(search, q = "My little pony")
#' set_values(search, hl = "fr")
#' set_values(search, btnI = "blah")
set_values <- function(form, ...) {
  new_values <- list(...)

  # check for valid names
  no_match <- setdiff(names(new_values), names(form$fields))
  if (length(no_match) > 0) {
    stop("Unknown field names: ", paste(no_match, collapse = ", "),
      call. = FALSE)
  }

  for(field in names(new_values)) {
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
#' @param form Form to submit
#' @param submit Name of submit button to use. If not supplied, defaults to
#'   first submission button on the form (with a message).
#' @return If successful, the parsed html response. Throws an error if http
#'   request fails. To access other elements of response, construct it yourself
#'   using the elements returned by \code{submit_request}.
#' @export
#' @examples
#' url <- google_form("1M9B8DsYNFyDjpwSK6ur_bZf8Rv_04ma3rmaaBiveoUI")
#' f0 <- parse_forms(url)[[1]]
#' f1 <- set_values(f0, entry.564397473 = "abc")
#' r <- submit_form(f1)
#' r[sel(".ss-resp-message")]
submit_form <- function(form, submit = NULL) {
  request <- submit_request(form, submit)

  # Make request
  if (request$method == "GET") {
    r <- httr::GET(request$url, params = request$values)
  } else if (request$method == "POST") {
    r <- httr::POST(request$url, body = request$values, encode = request$encode)
  } else {
    stop("Unknown method: ", request$method, call. = FALSE)
  }

  httr::stop_for_status(r)
  httr::content(r, "parsed")
}

submit_request <- function(form, submit = NULL) {
  submits <- Filter(function(x) identical(x$type, "submit"), form$fields)
  if (is.null(submit)) {
    submit <- names(submits)[[1]]
    message("Submitting with '", submit, "'")
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
  fields <- Filter(function(x) !is.null(x$value), fields)
  fields <- fields[setdiff(names(fields), other_submits)]

  values <- vpluck(fields, "value")
  names(values) <- names(fields)

  list(
    method = method,
    encode = form$encode,
    url = url,
    values = values
  )
}

#' Make link to google form given id
#'
#' @param x Unique identifier for form
#' @export
#' @examples
#' google_form("1M9B8DsYNFyDjpwSK6ur_bZf8Rv_04ma3rmaaBiveoUI")
google_form <- function(x) {
  paste0("https://docs.google.com/forms/d/", x, "/viewform")
}
