now <- function() {
  proc.time()[[3]]
}

has_chromote <- function() {
  tryCatch(
    {
      default <- chromote::default_chromote_object()
      local_bindings(default_timeout = 5, .env = default)
      startup <- default$new_session(wait_ = FALSE)
      default$wait_for(startup)
      TRUE
    },
    error = function(cnd) {
      FALSE
    }
  )
}

as_key_desc <- function(key, modifiers = character(), error_call = caller_env()) {
  check_string(key, call = error_call)
  modifiers <- arg_match(
    modifiers,
    values = c("Alt", "Control", "Meta", "Shift"),
    multiple = TRUE,
    error_call = error_call
  )

  if (!has_name(keydefs, key)) {
    cli::cli_abort("No key definition for {.str {key}}.")
  }

  def <- keydefs[[key]]
  desc <- list()

  desc$key <- def$key %||% ""
  if ("Shift" %in% modifiers && has_name(def, "shiftKey")) {
    desc$key <- def$shiftKey
  }

  desc$windowsVirtualKeyCode <- def$keyCode %||% 0
  if ("Shift" %in% modifiers && has_name(def, "shiftKeyCode")) {
    desc$windowsVirtualKeyCode <- def$shiftKeyCode
  }

  desc$code <- def$code %||% ""
  desc$location <- def$location %||% 0

  desc$text <- if (nchar(desc$key) == 1) def$key else def$text
  # no elements have shiftText field

  #  if any modifiers besides shift are pressed, no text should be sent
  if (any(modifiers != "Shift")) {
    desc$text <- ''
  }

  desc$modifiers <- sum(c(Alt = 1, Control = 2, Meta = 4, Shift = 8)[modifiers])
  desc
}

#' Create JavaScript to find nodes via XPath
#'
#' @param xpath A string containing an XPath 1.0 expression.
#' @return A string of JavaScript code.
#' @noRd
create_xpath_finder_js <- function(xpath) {
  # Sanitize xpath to prevent JS injection
  xpath <- gsub("\\\\", "\\\\\\\\", xpath)
  xpath <- gsub("`", "\\\\`", xpath)
  xpath <- gsub("'", "\\\\'", xpath)

  glue::glue("
    (function() {{
      const xpathResult = document.evaluate('{xpath}', document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
      const nodes = [];
      for (let i = 0; i < xpathResult.snapshotLength; i++) {{
        nodes.push(xpathResult.snapshotItem(i));
      }}
      return(nodes);
    }})();
  ")
}

#' Parse a vector of HTML fragments into a nodeset
#'
#' @param elements A character vector where each element is an HTML string.
#' @return An `xml_nodeset` object.
#' @noRd
parse_html_fragments <- function(elements) {
  if (length(elements) == 0) {
    # Return a missing node to be consistent with html_elements
    return(structure(list(), class = "xml_nodeset"))
  }
  # Wrap fragments in a single root element to create valid HTML
  html <- paste0("<html>", paste0(elements, collapse = "\n"), "</html>")
  # read_html returns the document, children gets <html>, children again gets
  # the actual nodes
  xml2::xml_children(xml2::xml_children(xml2::read_html(html)))
}
