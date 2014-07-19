#' @examples
#' url <- "http://www.boxofficemojo.com/movies/?id=ateam.htm&adjust_yr=1&p=.htm"
#' html <- content(GET(url), "parsed")
#' forms <- parse_forms(html)
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

  inputs <- form[xpath("input")]
  inputs <- lapply(inputs, parse_input)

  structure(
    list(
      name = name,
      method = method,
      action = action,
      enctype = enctype,
      inputs = inputs
    ),
    class = "form")
}

#' @export
print.form <- function(x, ...) {
  cat("<form> '", x$name, "' (", x$method, " ", x$action, ")\n", sep = "")

  inputs <- paste0("  ", vapply(x$inputs, format, character(1)), collapse = "\n")
  cat(inputs, "\n", sep = "")
}

#' @export
format.input <- function(x, ...) {
  paste0("<input ", x$type, "> '", x$name, "': ", x$value)
}

# <input>: type, name, value, checked, maxlength, id, disabled, readonly, required
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

# *
# <button>: ignored (client side only)
# <select>: name, multiple, id
# <option>: selected, value, label
# <textarea>: name, id, value (contents, not property)
# <label>: currently ignored? (but eventually should modify)


submit_form <- function(form) {
  if (!(method %in% c("POST", "GET"))) {
    warning("Invalid method (", method, "), defaulting to GET", call. = FALSE)
    method <- "GET"
  }
}
