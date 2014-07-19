#' @examples
#' url <- "http://www.boxofficemojo.com/movies/?id=ateam.htm&adjust_yr=1&p=.htm"
#' forms <- parse_forms(url)
parse_forms <- function(url, ...) {
  r <- httr::GET(url, ...)
  httr::stop_for_status(r)

  forms <- html[sel("form")]
  lapply(forms, parse_form, base_url = r$url)
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

  structure(
    list(
      name = name,
      method = method,
      action = action,
      enctype = enctype
    ),
    class = "form")
}

#' @export
print.form <- function(x, ...) {
  cat("<form> '", x$name, "' (", x$method, " ", x$action, ")\n", sep = "")
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
