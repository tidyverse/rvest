"%||%" <- function(a, b) if (length(a) == 0) b else a

vpluck_with_default <- function(xs, i, default) {
  extract <- function(x) {
    if (i %in% names(x)) {
      x[[i]]
    } else {
      default
    }
  }
  vapply(xs, extract, FUN.VALUE = default)
}

format_list <- function(x, indent = 0) {
  spaces <- paste(rep("  ", indent), collapse = "")

  formatted <- vapply(x, format, character(1))
  paste0(spaces, formatted, collapse = "\n")
}

is_node <- function(x) {
  inherits(x, "XMLInternalElementNode") || inherits(x, "HTMLInternalDocument")
}
is_node_list <- function(x) {
  inherits(x, "XMLNodeSet")
}

xml_apply <- function(x, f, ..., .type) {
  if (is_node(x)) {
    f(x, ...)
  } else if (is_node_list(x)) {
    if (missing(.type)) {
      lapply(x, f, ...)
    } else {
      vapply(x, f, ..., FUN.VALUE = .type)
    }
  } else {
    stop("Unknown input of class: ", paste(class(x), collapse = ", "))
  }
}

#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL


#' Extract elements of a list by position.
#'
#' @param x A list
#' @param i A string or integer.
#' @param type Type of output, if known
#' @export
pluck <- function(x, i, type) {
  if (missing(type)) {
    lapply(x, .subset2, i)
  } else {
    vapply(x, .subset2, i, FUN.VALUE = type)
  }
}
