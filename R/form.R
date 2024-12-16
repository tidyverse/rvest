#' Parse forms and set values
#'
#' Use `html_form()` to extract a form, set values with `html_form_set()`,
#' and submit it with `html_form_submit()`.
#'
#' @export
#' @inheritParams html_name
#' @param base_url Base url of underlying HTML document. The default, `NULL`,
#'   uses the url of the HTML document underlying `x`.
#' @seealso HTML 4.01 form specification:
#'   <https://www.w3.org/TR/html401/interact/forms.html>
#' @return
#' * `html_form()` returns as S3 object with class `rvest_form` when applied
#'   to a single element. It returns a list of `rvest_form` objects when
#'   applied to multiple elements or a document.
#'
#' * `html_form_set()` returns an `rvest_form` object.
#'
#' * `html_form_submit()` submits the form, returning an httr response which
#'   can be parsed with [read_html()].
#' @examples
#' html <- read_html("http://www.google.com")
#' search <- html_form(html)[[1]]
#'
#' search <- search %>% html_form_set(q = "My little pony", hl = "fr")
#'
#' # Or if you have a list of values, use !!!
#' vals <- list(q = "web scraping", hl = "en")
#' search <- search %>% html_form_set(!!!vals)
#'
#' # To submit and get result:
#' \dontrun{
#' resp <- html_form_submit(search)
#' read_html(resp)
#' }
html_form <- new_generic("html_form", "x", function(x, base_url = NULL) {
  # TODO: verify that base_url is NULL or character?
  S7_dispatch()
})

#' @export
method(html_form, new_S3_class("xml_document")) <- function(x, base_url = NULL) {
  html_form(xml2::xml_find_all(x, ".//form"), base_url = base_url)
}

#' @export
method(html_form, new_S3_class("xml_nodeset")) <- function(x, base_url = NULL) {
  lapply(x, html_form, base_url = base_url)
}

rvest_form <- new_class(
  "rvest_form",
  package = "rvest",
  properties = list(
    name = class_character,
    method = class_character,
    action = class_character,
    enctype = class_character,
    fields = class_list # TODO: fix this
  )
)

#' @export
method(html_form, new_S3_class("xml_node")) <- function(x, base_url = NULL) {
  if (xml2::xml_name(x) != "form") {
    cli::cli_abort("{.arg x} must be a <form> element.")
  }
  check_string(base_url, allow_null = TRUE)

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
  names(fields) <- map_chr(fields, function(x) x@name %||% "")

  rvest_form(
    name = name,
    method = method,
    action = xml2::url_absolute(attr$action, base_url %||% xml2::xml_url(x)),
    enctype = enctype,
    fields = fields
  )
}

baseprint <- new_external_generic("base", "print", "x")
method(baseprint, rvest_form) <- function(x, ...) {
  cat("<form> '", x@name, "' (", x@method, " ", x@action, ")\n", sep = "")
  cat(format_list(x@fields, indent = 1), "\n", sep = "")
}


# set ----------------------------------------------------------------

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
    type <- form@fields[[field]]@type %||% "non-input"
    if (type == "hidden") {
      cli::cli_warn("Setting value of hidden field {.str {field}}.")
    } else if (type == "submit") {
      cli::cli_abort("Can't change value of input with type submit: {.str {field}}.")
    }

    form@fields[[field]]@value <- new_values[[field]]
  }

  form
}

# submit ------------------------------------------------------------------

#' @rdname html_form
#' @param submit Which button should be used to submit the form?
#'   * `NULL`, the default, uses the first button.
#'   * A string selects a button by its name.
#'   * A number selects a button using its relative position.
#' @export
html_form_submit <- function(form, submit = NULL) {
  check_form(form)

  subm <- submission_build(form, submit)
  submission_submit(subm)
}

submission_build <- function(form, submit, error_call = caller_env()) {
  method <- form@method
  if (!(method %in% c("POST", "GET"))) {
    cli::cli_warn("Invalid method ({method}), defaulting to GET.", call = error_call)
    method <- "GET"
  }

  if (length(form@action) == 0) {
    cli::cli_abort("`form` doesn't contain a `action` attribute.", call = error_call)
  }

  list(
    method = method,
    enctype = form@enctype,
    action = form@action,
    values = submission_build_values(form, submit, error_call = error_call)
  )
}

submission_submit <- function(x, ...) {
  if (x$method == "POST") {
    httr::POST(url = x$action, body = x$values, encode = x$enctype, ...)
  } else {
    httr::GET(url = x$action, query = x$values, ...)
  }
}

submission_build_values <- function(form, submit = NULL, error_call = caller_env()) {
  fields <- form@fields
  submit <- submission_find_submit(fields, submit, error_call = error_call)
  entry_list <- c(Filter(Negate(is_button), fields), list(submit))
  entry_list <- Filter(function(x) S7_inherits(x, rvest_field), entry_list)

  if (length(entry_list) == 0) {
    return(list())
  }

  values <- lapply(entry_list, function(x) as.character(x@value))
  names <- map_chr(entry_list, function(x) x@name)

  out <- set_names(unlist(values, use.names = FALSE), rep(names, lengths(values)))
  as.list(out)
}

submission_find_submit <- function(fields, idx, error_call = caller_env()) {
  buttons <- Filter(is_button, fields)

  if (is.null(idx)) {
    if (length(buttons) == 0) {
      list()
    } else {
      if (length(buttons) > 1) {
        cli::cli_inform("Submitting with button {.str {buttons[[1]]@name}}.")
      }
      buttons[[1]]
    }
  } else if (is.numeric(idx) && length(idx) == 1) {
    if (idx < 1 || idx > length(buttons)) {
      cli::cli_abort("Numeric {.arg submit} out of range.", call = error_call)
    }
    buttons[[idx]]
  } else if (is.character(idx) && length(idx) == 1) {
    if (!idx %in% names(buttons)) {
      cli::cli_abort(
        c(
          "No <input> found with name {.str {idx}}.",
          i = "Possible values: {.str {names(buttons)}}."
        ),
        call = error_call
      )
    }
    buttons[[idx]]
  } else {
    cli::cli_abort(
      "{.arg submit} must be NULL, a string, or a number.",
      call = error_call
    )
  }
}

is_button <- function(x) {
  tolower(x@type) %in% c("submit", "image", "button")
}

# Field parsing -----------------------------------------------------------
rvest_field <- new_class(
  "rvest_field",
  package = "rvest",
  properties = list(
    type = class_character,
    name = class_character | NULL,
    value = class_character | NULL,
    attr = class_list,
    options = NULL | class_any # TODO: fix this
  ),
  constructor = function(type, name, value, attr, options = NULL) {
    force(type)
    force(name)
    force(value)
    force(attr)
    new_object(S7_object(), type = type, name = name, value = value, attr = attr, options = options)
  }
)

baseformat <- new_external_generic("base", "format", "x")
#' @export
method(baseformat, rvest_field) <- function(x, ...) {
  if (x@type == "password") {
    value <- paste0(rep("*", nchar(x@value %||% "")), collapse = "")
  } else {
    value <- paste(x@value, collapse = ", ")
    value <- str_trunc(encodeString(value), 20)
  }

  paste0("<field> (", x@type, ") ", x@name, ": ", value)
}

#' @export
method(baseprint, rvest_field) <- function(x, ...) {
  # TODO: make this work
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
    options = options$options # TODO: just make this an actual property default empty? Instead of relying on dots?
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
  value <- map_chr(parsed, "[[", "value")
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

check_fields <- function(form, values, error_call = caller_env()) {
  no_match <- setdiff(names(values), names(form@fields))
  if (length(no_match) > 0) {
    cli::cli_abort(
      "Can't set value of fields that don't exist: {.str {no_match}}.",
      call = error_call
    )
  }
}
