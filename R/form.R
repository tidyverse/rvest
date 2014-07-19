#' @examples
#' url <- "http://www.boxofficemojo.com/movies/?id=ateam.htm&adjust_yr=1&p=.htm"
#' html <- content(GET(url), "parsed")
#' forms <- parse_forms(html)
#'
#' parse_forms("https://hadley.wufoo.com/forms/libraryrequire-quiz/")
#' parse_forms("https://hadley.wufoo.com/forms/r-journal-submission/")
parse_forms <- function(src, ...) UseMethod("parse_forms")

#' @export
parse_forms.XMLAbstractDocument <- function(src, ...) {
  forms <- src[sel("form")]
  lapply(forms, parse_form, base_url = r$url)
}

#' @export
parse_forms.character <- function(src, ...) {
  if (grepl(src, "<|>")) {
    html <- XML::htmlParse(src, ...)
  } else {
    r <- httr::GET(src, ...)
    httr::stop_for_status(r)
    html <- httr::content(r, "parsed")
  }

  parse_forms(html)
}

# http://www.w3.org/TR/html401/interact/forms.html
#
# <form>: action (url), type (GET/POST), enctype (form/multipart), id
parse_form <- function(form, base_url) {
  stopifnot(inherits(form, "XMLAbstractNode"), xmlName(form) == "form")

  attr <- as.list(XML::xmlAttrs(form))
  name <- attr$id %||% attr$name %||% "<unnamed>" # for human readers
  method <- toupper(attr$method) %||% "GET"
  action <- attr$action
  enctype <- attr$enctype %||% "application/x-www-form-urlencoded"

  fields <- parse_fields(form)

  structure(
    list(
      name = name,
      method = method,
      action = action,
      enctype = enctype,
      fields = fields
    ),
    class = "form")
}

#' @export
print.form <- function(x, indent = 0, ...) {
  cat("<form> '", x$name, "' (", x$method, " ", x$action, ")\n", sep = "")
  print(x$fields, indent = indent + 1)
}

#' @export
format.input <- function(x, ...) {
  paste0("<input ", x$type, "> '", x$name, "': ", x$value)
}

parse_fields <- function(form) {
  raw <- form[sel("input, select, textarea")]

  fields <- lapply(raw, function(x) {
    switch(xmlName(x),
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
  stopifnot(inherits(input, "XMLAbstractNode"), xmlName(input) == "input")
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
  stopifnot(inherits(select, "XMLAbstractNode"), xmlName(select) == "select")

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
    attr <- as.list(xmlAttrs(option))
    list(
      value = attr$value,
      name = xmlValue(option),
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
  attr <- as.list(xmlAttrs(textarea))

  structure(
    list(
      name = attr$name,
      value = xmlValue(textarea)
    ),
    class = "textarea"
  )
}

#' @export
format.textarea <- function(x, ...) {
  paste0("<textarea> '", x$name, "' [", nchar(x$value), " char]")
}

submit_form <- function(form) {
  if (!(method %in% c("POST", "GET"))) {
    warning("Invalid method (", method, "), defaulting to GET", call. = FALSE)
    method <- "GET"
  }
}
