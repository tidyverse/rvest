#' Parse forms in a page
#'
#'
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
  method <- toupper(attr$method %||% "GET")
  enctype <- convert_enctype(attr$enctype)

  nodes <- html_nodes(x, "input, select, textarea, button")
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
      action = attr$action,
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
  options <- parse_options(html_nodes(x, "option"))

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

