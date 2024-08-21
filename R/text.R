#' Get element text
#'
#' @description
#' There are two ways to retrieve text from a element: `html_text()` and
#' `html_text2()`. `html_text()` is a thin wrapper around [xml2::xml_text()]
#' which returns just the raw underlying text. `html_text2()` simulates how
#' text looks in a browser, using an approach inspired by JavaScript's
#' [innerText()](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/innerText).
#' Roughly speaking, it converts `<br />` to `"\n"`, adds blank lines
#' around `<p>` tags, and lightly formats tabular data.
#'
#' `html_text2()` is usually what you want, but it is much slower than
#' `html_text()` so for simple applications where performance is important
#' you may want to use `html_text()` instead.
#'
#' @inheritParams xml2::xml_text
#' @importFrom xml2 xml_text
#' @return A character vector the same length as `x`
#' @examples
#' # To understand the difference between html_text() and html_text2()
#' # take the following html:
#'
#' html <- minimal_html(
#'   "<p>This is a paragraph.
#'     This another sentence.<br>This should start on a new line"
#' )
#'
#' # html_text() returns the raw underlying text, which includes whitespace
#' # that would be ignored by a browser, and ignores the <br>
#' html |> html_element("p") |> html_text() |> writeLines()
#'
#' # html_text2() simulates what a browser would display. Non-significant
#' # whitespace is collapsed, and <br> is turned into a line break
#' html |> html_element("p") |> html_text2() |> writeLines()
#'
#' # By default, html_text2() also converts non-breaking spaces to regular
#' # spaces:
#' html <- minimal_html("<p>x&nbsp;y</p>")
#' x1 <- html |> html_element("p") |> html_text()
#' x2 <- html |> html_element("p") |> html_text2()
#'
#' # When printed, non-breaking spaces look exactly like regular spaces
#' x1
#' x2
#' # But aren't actually the same:
#' x1 == x2
#' # Which you can confirm by looking at their underlying binary
#' # representaion:
#' charToRaw(x1)
#' charToRaw(x2)
#' @export
html_text <- function(x, trim = FALSE) {
  check_bool(trim)
  xml_text(x, trim = trim)
}

#' @export
#' @rdname html_text
#' @param preserve_nbsp Should non-breaking spaces be preserved? By default,
#'   `html_text2()` converts to ordinary spaces to ease further computation.
#'   When `preserve_nbsp` is `TRUE`, `&nbsp;` will appear in strings as
#'   `"\ua0"`. This often causes confusion because it prints the same way as
#'   `" "`.
html_text2 <- function(x, preserve_nbsp = FALSE) {
  check_bool(preserve_nbsp)

  UseMethod("html_text2")
}

#' @export
html_text2.xml_document <- function(x, preserve_nbsp = FALSE) {
  body <- xml2::xml_find_first(x, ".//body")
  html_text2(body, preserve_nbsp = preserve_nbsp)
}

#' @export
html_text2.xml_nodeset <- function(x, preserve_nbsp = FALSE) {
  vapply(
    x,
    html_text2,
    preserve_nbsp = preserve_nbsp,
    FUN.VALUE = character(1)
  )
}

#' @export
html_text2.xml_node <- function(x, preserve_nbsp = FALSE) {
  text <- PaddedText$new()
  html_text_block(x, text, preserve_nbsp = preserve_nbsp)
  text$output()
}

#' @export
html_text2.xml_missing <- function(x, preserve_nbsp = FALSE) {
  NA_character_
}

# Algorithm roughly inspired by
# https://html.spec.whatwg.org/multipage/dom.html#the-innertext-idl-attribute
# but following deatils in
# https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Whitespace#How_does_CSS_process_whitespace
html_text_block <- function(x, text, preserve_nbsp = FALSE) {
  if (xml2::xml_type(x) == "text") {
    text$add_text(collapse_whitespace(xml2::xml_text(x), preserve_nbsp))
  } else if (is_inline(x)) {
    text$add_text(html_text_inline(x, preserve_nbsp))
  } else {
    children <- xml2::xml_contents(x)
    n <- length(children)

    for (i in seq_along(children)) {
      child <- children[[i]]
      name <- xml2::xml_name(child)
      margin <- tag_margin(name)

      text$add_margin(margin)
      html_text_block(child, text, preserve_nbsp = preserve_nbsp)
      switch(name,
        tr = if (i != n) text$add_text("\n"),
        th = ,
        td = if (i != n) text$add_text("\t"),
        br = text$add_text("\n")
      )
      text$add_margin(margin)
    }
  }
}

is_inline <- function(x) {
  children <- xml2::xml_children(x)
  !any(xml2::xml_name(children) %in% c(block_tag, table_tag))
}

block_tag <- c(
  # https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements
  "address", "article", "aside", "blockquote", "details", "dialog", "dd", "div",
  "dl", "dt", "fieldset", "figcaption", "figure", "footer", "form", "h1", "h2",
  "h3", "h4", "h5", "h6", "header", "hgroup", "hr", "li", "main", "nav", "ol",
  "p", "pre", "section", "table", "ul",
  "caption"
)

table_tag <- c("tr", "td", "th")

tag_margin <- function(name) {
  # + caption
  if (name == "p") {
    2L
  } else if (name %in% block_tag) {
    1L
  } else {
    0L
  }
}

html_text_inline <- function(x, preserve_nbsp = FALSE) {
  children <- xml2::xml_contents(x)
  n <- length(children)
  if (n == 0) {
    return("")
  }

  text <- xml2::xml_text(children)
  is_br <- xml2::xml_name(children) == "br"

  line_num <- cumsum(c(TRUE, is_br[-n]))
  lines <- split(text, line_num)
  lines <- vapply(lines, paste0, collapse = "", FUN.VALUE = character(1))

  if (xml2::xml_name(x) != "pre") {
    lines <- collapse_whitespace(lines, preserve_nbsp)
  }

  has_br <- unname(tapply(is_br, line_num, any))
  paste0(lines, ifelse(has_br, "\n", ""), collapse = "")
}

# https://drafts.csswg.org/css-text/#white-space-phase-1
collapse_whitespace <- function(x, preserve_nbsp = FALSE) {
  # Remove leading and trailing whitespace
  x <- gsub("(^[ \t\n]+)|([ \t\n]+$)", "", x, perl = TRUE)

  # Convert any whitespace sequence to a space
  match <- if (preserve_nbsp) "[\t\n ]+" else "[\t\n \u00a0]+"
  x <- gsub(match, " ", x, perl = TRUE)

  x
}

# Text with line break padding in between blocks, collapsing breaks
# similarly to css margin collapsing rules
PaddedText <- R6::R6Class("PaddedText", list(
  text = character(),
  lines = 0,
  i = 1L,

  add_margin = function(n) {
    # Don't add breaks before encountering text
    if (self$i == 1) {
      return()
    }

    self$lines <- max(self$lines, n)
  },

  convert_breaks = function() {
    if (self$lines == 0) {
      return()
    }

    self$text[[self$i]] <- strrep("\n", self$lines)
    self$i <- self$i + 1
    self$lines <- 0
  },

  add_text = function(x) {
    # Ignore empty strings
    if (identical(x, "")) {
      return()
    }

    self$convert_breaks()
    self$text[[self$i]] <- x
    self$i <- self$i + 1L
  },

  output = function() {
    paste(self$text, collapse = "")
  }
))
