#' Show the structure of an html/xml document.
#'
#' Show the structure of an html/xml document without displaying any of
#' the values. This is useful if you want to get a high level view of the
#' way a document is organised.
#'
#'
#' @param x HTML/XML document (or part there of)
#' @param indent Number of spaces to ident
#' @export
xml_structure <- function(x, indent = 0) {
  padding <- paste(rep(" ", indent), collapse = "")

  if (is_document(x)) {
    lapply(XML::xmlChildren(x), xml_structure, indent = indent)
  } else if (is_node_list(x)) {
    for (i in seq_along(x)) {
      cat("[[", i, "]]\n", sep = "")
      xml_structure(x[[i]], indent = indent)
      cat("\n")
    }
  } else if (inherits(x, "XMLInternalElementNode")) {
    attr <- XML::xmlAttrs(x)
    if (length(attr) > 0) {
      attr_str <- paste0(" [", paste0(names(attr), collapse = ", "), "]")
    } else {
      attr_str <- ""
    }

    node <- paste0("<", XML::xmlName(x), attr_str, ">")

    if (one_child(x)) {
      cat(padding, node, " ", sep = "")
      xml_structure(XML::xmlChildren(x)[[1]], indent = 0)
    } else {
      cat(padding, node, "\n", sep = "")
      lapply(XML::xmlChildren(x), xml_structure, indent = indent + 2)
    }
  } else if (inherits(x, "XMLInternalTextNode")) {
    cat(padding, "{text}\n", sep = "")
  } else if (inherits(x, "XMLInternalCDataNode")) {
    cat(padding, "{CDATA}\n", sep = "")
  } else if (inherits(x, "XMLCommentNode")) {
    cat(padding, "{comment}\n", sep = "")
  } else if (inherits(x, "XMLInternalPINode")) {
    cat(padding, "{PI}\n", sep = "")
  } else if (inherits(x, "XMLDTDNode")) {
    cat(padding, "{DTD}\n", sep = "")
  } else {
    stop("Unknown input ", paste(class(x), collapse = "/"), call. = FALSE)
  }

  invisible()
}

one_child <- function(x) {
  children <- XML::xmlChildren(x)
  if (length(children) == 0) return(FALSE)
  if (length(children) > 1) return(FALSE)

  grandchildren <- XML::xmlChildren(children[[1]])

  length(grandchildren) == 0
}
