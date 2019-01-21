# vector to HTML class attribute string
html_class_vec2str <- function(x) {
  paste(sort(unique(as.character(x))), collapse = " ")
}

# HTML class attribute string to character vector
# classes are space separated - includes space, tab, and newlines
# classes are unique
# https://www.w3.org/TR/2011/WD-html5-20110525/elements.html#classes
html_class_str2vec <- function(x) {
  sort(unique(strsplit(trimws(x), "\\s+", fixed = FALSE)[[1]]))
}

#' Extract or modify HTML classes
#'
#' These functions simplify working with the HTML class attribute.
#' The \code{html_classes()} function returns the classes of an element.
#' The \code{html_has_classes()} function checks whether an element has
#' one or specified class.
#' The \code{html_set_classes()} and \code{html_classes<-()} functions sets
#' the classes of a HTML element, while \code{html_add_classes()} appends,
#' and \code{html_remove_classes()} removes classes from the existing set of
#' classes.
#'
#' @param x A node or node set.
#' @param classnames A character vector of class names.
#' @param value A character vector of class names. If \code{NULL} in
#'   \code{html_classes<-} or \code{html_set_classes}
#'   then all classes are removed.
#' @param ... Arguments passed to methods.
#' @return
#'   \describe{
#'   \item{\code{html_classes}}{
#'      If \code{x} is a node, then a character vector containing
#'      the names of the classes of the HTML element. If the element has no
#'      classes, then a length-0 character vector is returned.
#'      If \code{x} is a node set, then a list of character vectors.
#'      If \code{x} is missing, then \code{NA}.
#'   }
#'   }
#'
#' @examples
#' doc <- read_html("<div class='section level1'><h1>Title</h1></div>")
#' div <- html_nodes(doc, "div")
#' html_classes(div)
#'
#' # Remove class
#' html_remove_classes(div, "level1")
#'
#' # Add classes
#' html_add_classes(div, c("chapter", "heading"))
#'
#' # Set classes
#' h1 <- doc %>% html_node("h1")
#' html_classes(h1) <- "chapter-title"
#'
#' @export
html_classes <- function(x) {
  UseMethod("html_classes")
}

#' @importFrom xml2 xml_attr
#' @export
html_classes.xml_node <- function(x) {
  klass <- xml_attr(x, "class")
  if (!length(klass) || is.na(klass)) {
    character()
  } else {
    html_class_str2vec(klass)
  }
}

#' @export
html_classes.xml_missing <- function(x) {
  NA_character_
}

#' @export
html_classes.xml_nodeset <- function(x) {
  lapply(x, html_classes)
}

#' @rdname html_classes
#' @export
"html_classes<-" <- function(x, value) {
  UseMethod("html_classes<-")
}

#' @rdname html_classes
#' @importFrom xml2 xml_attr<-
#' @export
"html_classes<-.xml_node" <- function(x, value) {
  # xml_attr<- will remove attribute if value is NULL
  if (!is.null(value)) {
    value <- html_class_vec2str(value)
  }
  xml_attr(x, "class") <- value
  x
}

#' @importFrom xml2 xml_attr<-
#' @export
"html_classes<-.xml_nodeset" <- function(x, value) {
  lapply(x, `html_classes<-`, value = value)
  x
}

#' @export
"html_classes<-.xml_missing" <- function(x, value) {
  x
}

#' @rdname html_classes
#' @export
html_set_classes <- function(x, value) {
  html_classes(x) <- value
  x
}

#' @rdname html_classes
#' @export
html_has_classes <- function(x, classnames) {
  UseMethod("html_has_classes")
}

#' @export
html_has_classes.xml_node <- function(x, classnames) {
  all(classnames %in% html_classes(x))
}

#' @export
html_has_classes.xml_nodeset <- function(x, classnames) {
  vapply(x, html_has_classes, TRUE, classnames = classnames)
}

#' @export
html_has_classes.xml_missing <- function(x, classnames) {
  NA
}

#' @rdname html_classes
#' @export
html_add_classes <- function(x, classnames) {
  UseMethod("html_add_classes")
}

#' @export
html_add_classes.xml_node <- function(x, classnames) {
  newclasses <- c(html_classes(x), as.character(classnames))
  html_classes(x) <- newclasses
}

#' @export
html_add_classes.xml_nodeset <- function(x, classnames) {
  lapply(x, html_add_classes, classnames = classnames)
  x
}

#' @export
html_add_classes.xml_missing <- function(x, classnames) {
  x
}

#' @rdname html_classes
#' @export
html_remove_classes <- function(x, classnames) {
  UseMethod("html_remove_classes")
}

#' @export
html_remove_classes.xml_node <- function(x, classnames) {
  newclasses <- setdiff(html_classes(x), as.character(classnames))
  # If no classes, remove class attribute
  if (!length(newclasses)) {
    newclasses <- NULL
  }
  html_classes(x) <- newclasses
}

#' @export
html_remove_classes.xml_nodeset <- function(x, classnames) {
  lapply(x, html_remove_classes, classnames = classnames)
  x
}

#' @export
html_remove_classes.xml_missing <- function(x, classnames) {
  x
}
