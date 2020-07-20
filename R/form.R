#' Parse forms in a page.
#'
#' @export
#' @param x A node, node set or document.
#' @seealso HTML 4.01 form specification:
#'   <http://www.w3.org/TR/html401/interact/forms.html>
#' @examples
#' \donttest{
#' html_form(read_html("https://hadley.wufoo.com/forms/libraryrequire-quiz/"))
#' html_form(read_html("https://hadley.wufoo.com/forms/r-journal-submission/"))
#'
#' box_office <- read_html("http://www.boxofficemojo.com/movies/?id=ateam.htm")
#' box_office %>% html_node("form") %>% html_form()
#' }
html_form <- function(x) UseMethod("html_form")

#' @export
html_form.xml_document <- function(x) {
  html_form(xml2::xml_find_all(x, ".//form"))
}

#' @export
html_form.xml_nodeset <- function(x) {
  lapply(x, html_form)
}

#' @export
html_form.xml_node <- function(x) {
  stopifnot(xml2::xml_name(x) == "form")

  attr <- as.list(xml2::xml_attrs(x))
  name <- attr$id %||% attr$name %||% "<unnamed>" # for human readers
  method <- toupper(attr$method) %||% "GET"
  enctype <- convert_enctype(attr$enctype)

  fields <- parse_fields(x)

  structure(
    list(
      name = name,
      method = method,
      url = attr$action,
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
  if (x$type == "password") {
    value <- paste0(rep("*", nchar(x$value) %||% 0), collapse = "")
  } else {
    value <- x$value
  }
  paste0("<input ", x$type, "> '", x$name, "': ", value)
}

parse_fields <- function(form) {
  raw <- html_nodes(form, "input, select, textarea, button")

  fields <- lapply(raw, function(x) {
    switch(xml2::xml_name(x),
      textarea = parse_textarea(x),
      input = parse_input(x),
      select = parse_select(x),
      button = parse_button(x)
    )
  })
  names(fields) <- pluck(fields, "name")
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
  stopifnot(inherits(input, "xml_node"), xml2::xml_name(input) == "input")
  attr <- as.list(xml2::xml_attrs(input))

  structure(
    list(
      name = attr$name,
      type = attr$type %||% "text",
      value = attr$value %||% NULL,
      checked = attr$checked,
      disabled = attr$disabled,
      readonly = attr$readonly,
      required = attr$required %||% FALSE
    ),
    class = "input"
  )
}

parse_select <- function(select) {
  stopifnot(inherits(select, "xml_node"), xml2::xml_name(select) == "select")

  attr <- as.list(xml2::xml_attrs(select))
  options <- parse_options(html_nodes(select, "option"))

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
    name <- xml2::xml_text(option)
    list(
      value = xml2::xml_attr(option, "value", default = name),
      name = name,
      selected = xml2::xml_has_attr(option, "selected")
    )
  }

  parsed <- lapply(options, parse_option)
  value <- pluck(parsed, "value", character(1))
  name <- pluck(parsed, "name", character(1))
  selected <- pluck(parsed, "selected", logical(1))

  list(
    value = value[selected],
    options = stats::setNames(value, name)
  )
}

parse_textarea <- function(textarea) {
  attr <- as.list(xml2::xml_attrs(textarea))

  structure(
    list(
      name = attr$name,
      value = xml2::xml_text(textarea)
    ),
    class = "textarea"
  )
}

#' @export
format.textarea <- function(x, ...) {
  paste0("<textarea> '", x$name, "' [", nchar(x$value), " char]")
}

parse_button <- function(button) {
  stopifnot(inherits(button, "xml_node"), xml2::xml_name(button) == "button")
  attr <- as.list(xml2::xml_attrs(button))

  structure(
    list(
      name = attr$name %||% "<unnamed>",
      type = attr$type,
      value = attr$value,
      checked = attr$checked,
      disabled = attr$disabled,
      readonly = attr$readonly,
      required = attr$required %||% FALSE
    ),
    class = "button"
  )
}

#' @export
format.button <- function(x, ...) {
  paste0("<button ", x$type, "> '", x$name)
}


#' Set values in a form.
#'
#' @param form Form to modify
#' @param ... Name-value pairs giving fields to modify
#' @return An updated form object
#' @export
#' @examples
#' search <- html_form(read_html("http://www.google.com"))[[1]]
#' set_values(search, q = "My little pony")
#' set_values(search, hl = "fr")
#' \dontrun{set_values(search, btnI = "blah")}
set_values <- function(form, ...) {
  new_values <- list(...)

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
  url <- xml2::url_absolute(form$url, session$url)

  # Make request
  if (request$method == "GET") {
    request_GET(session, url = url, query = request$values, ...)
  } else if (request$method == "POST") {
    request_POST(session, url = url, body = request$values,
      encode = request$encode, ...)
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

#' Make link to google form given id
#'
#' @param x Unique identifier for form
#' @export
#' @examples
#' google_form("1M9B8DsYNFyDjpwSK6ur_bZf8Rv_04ma3rmaaBiveoUI")
google_form <- function(x) {
  xml2::read_html(httr::GET(paste0("https://docs.google.com/forms/d/", x, "/viewform")))
}
