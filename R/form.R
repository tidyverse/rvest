#' Parse forms and set values
#'
#' Use `html_form()` to extract a form, set values with `html_form_set()`,
#' then submit it with [session_submit()]
#'
#' @export
#' @inheritParams html_name
#' @param base_url Base url of underlying HTML document. The default, `NULL`,
#'   uses the url of the HTML document underlying `x`.
#' @seealso HTML 4.01 form specification:
#'   <http://www.w3.org/TR/html401/interact/forms.html>
#' @return An an S3 object with class `rvest_form`.
#' @examples
#' session <- session("http://www.google.com")
#' search <- html_form(session)[[1]]
#'
#' search <- search %>% html_form_set(q = "My little pony", hl = "fr")
#'
#' # Or if you have a list of values, use !!!
#' vals <- list(q = "web scraping", hl = "en")
#' search <- search %>% html_form_set(!!!vals)
#'
#' # To submit and get result:
#' \dontrun{
#' session_submit(session, form)
#' }
html_form <- function(x, base_url = NULL) UseMethod("html_form")

#' @export
html_form.xml_document <- function(x, base_url = NULL) {
  html_form(xml2::xml_find_all(x, ".//form"), base_url = base_url)
}

#' @export
html_form.xml_nodeset <- function(x, base_url = NULL) {
  lapply(x, html_form, base_url = base_url)
}

#' @export
html_form.xml_node <- function(x, base_url = NULL) {
  stopifnot(xml2::xml_name(x) == "form")

  attr <- as.list(xml2::xml_attrs(x))
  name <- attr$id %||% attr$name %||% "<unnamed>" # for human readers
  method <- toupper(attr$method %||% "GET")
  enctype <- convert_enctype(attr$enctype)

  nodes <- html_elements(x, "input, select, textarea, button")
  fields <- lapply(nodes, function(x) {
    switch(xml2::xml_name(x),
      textarea = parse_textarea(x),
      input = parse_input(x),
      select = parse_select(x),
      button = parse_button(x)
    )
  })
  names(fields) <- map_chr(fields, function(x) x$name %||% "")

  structure(
    list(
      name = name,
      method = method,
      action = xml2::url_absolute(attr$action, base_url %||% xml2::xml_url(x)),
      enctype = enctype,
      fields = fields
    ),
    class = "rvest_form")
}

#' @export
print.rvest_form <- function(x, ...) {
  cat("<form> '", x$name, "' (", x$method, " ", x$action, ")\n", sep = "")
  cat(format_list(x$fields, indent = 1), "\n", sep = "")
}


# form_set ----------------------------------------------------------------

#' @rdname html_form
#' @param form A form
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Name-value pairs giving
#'   fields to modify.
#'
#'   Provide a character vector to set multiple checkboxes in a set or
#'   select multiple values from a multi-select.
#' @export
html_form_set <- function(form, ...) {
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

# Field parsing -----------------------------------------------------------

rvest_field <- function(type, name, value, attr, ...) {
  structure(
    list(
      type = type,
      name = name,
      value = value,
      attr = attr,
      ...
    ),
    class = "rvest_field"
  )
}

#' @export
format.rvest_field <- function(x, ...) {
  if (x$type == "password") {
    value <- paste0(rep("*", nchar(x$value %||% "")), collapse = "")
  } else {
    value <- paste(x$value, collapse = ", ")
    value <- str_trunc(encodeString(value), 20)
  }

  paste0("<field> (", x$type, ") ", x$name, ": ", value)
}

#' @export
print.rvest_field <- function(x, ...) {
  cat(format(x, ...), "\n", sep = "")
  invisible(x)
}

parse_input <- function(x) {
  attr <- as.list(xml2::xml_attrs(x))
  rvest_field(
    type = attr$type %||% "text",
    name = attr$name,
    value = attr$value,
    attr = attr
  )
}

parse_select <- function(x) {
  attr <- as.list(xml2::xml_attrs(x))
  options <- parse_options(html_elements(x, "option"))

  rvest_field(
    type = "select",
    name = attr$name,
    value = options$value,
    attr = attr,
    options = options$options
  )
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
  value <-  map_chr(parsed, "[[", "value")
  name <- map_chr(parsed, "[[", "name")
  selected <- map_lgl(parsed, "[[", "selected")

  list(
    value = value[selected],
    options = stats::setNames(value, name)
  )
}

parse_textarea <- function(x) {
  attr <- as.list(xml2::xml_attrs(x))

  rvest_field(
    type = "textarea",
    name = attr$name,
    value = xml2::xml_text(x),
    attr = attr
  )
}

parse_button <- function(x) {
  attr <- as.list(xml2::xml_attrs(x))

  rvest_field(
    type = "button",
    name = attr$name,
    value = attr$value,
    attr = attr
  )
}

# Helpers -----------------------------------------------------------------

convert_enctype <- function(x) {
  if (is.null(x)) {
    "form"
  } else if (x == "application/x-www-form-urlencoded") {
    "form"
  } else if (x == "multipart/form-data") {
    "multipart"
  } else {
    warn(paste0("Unknown enctype (", x, "). Defaulting to form encoded."))
    "form"
  }
}

format_list <- function(x, indent = 0) {
  spaces <- paste(rep("  ", indent), collapse = "")

  formatted <- vapply(x, format, character(1))
  paste0(spaces, formatted, collapse = "\n")
}

check_fields <- function(form, values) {
  no_match <- setdiff(names(values), names(form$fields))
  if (length(no_match) > 0) {
    str <- paste("'", no_match, "'", collapse = ", ")
    abort(paste0("Can't set value of fields that don't exist: ", str))
  }
}
