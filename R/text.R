

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

html_text_inner <- function(x) {
  text <- PaddedText$new()
  html_text_block(x, text)
  text$output()
}

# Algorithm from
# https://html.spec.whatwg.org/multipage/dom.html#the-innertext-idl-attribute
html_text_block <- function(x, text) {
  children <- xml2::xml_children(x)
  n <- length(children)
  is_inline <- !any(xml2::xml_name(children) %in% c(block_tag, table_tag))

  if (is_inline) {
    text$add_text(html_text_inline(x))
  } else {
    for (i in seq_along(children)) {
      child <- children[[i]]
      name <- xml2::xml_name(child)
      margin <- tag_margin(name)

      text$add_margin(margin)
      html_text_block(child, text)
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

html_text_inline <- function(x) {
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
    lines <- collapse_whitespace(lines)
  }

  has_br <- unname(tapply(is_br, line_num, any))
  paste0(lines, ifelse(has_br, "\n", ""), collapse = "")
}

# https://drafts.csswg.org/css-text/#white-space-phase-1
collapse_whitespace <- function(x) {
  # Remove leading and trailing whitespace
  x <- gsub("(^[ \t\n]+)|([ \t\n]+$)", "", x, perl = TRUE)

  # Convert any whitespace sequence to a space
  x <- gsub("[\t\n ]+", " ", x, perl = TRUE)

  x
}
