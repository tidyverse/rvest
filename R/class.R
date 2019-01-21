# vector to HTML class attribute string
html_class_vec2str <- function(x) {
  paste(sort(unique(as.character(x))), sep = " ")
}

# HTML class attribute string to character vector
# classes are space separated - includes space, tab, and newlines
# classes are unique
# https://www.w3.org/TR/2011/WD-html5-20110525/elements.html#classes
html_class_str2vec <- function(x) {
  sort(unique(strsplit(trimws(x), "\\s+", fixed = FALSE)[[1]]))
}

#' Extract classes of a HTML element
#'
#' The function \code{html_classes()} is a helper function to return the classes
#' of a HTML element as a character vector of the unique classes rather than
#' a single string.
#'
#' @param x A node or node set.
#' @param .classes A character vector of classe names.
#' @param value A character vector of class names. If \code{NULL} in
#'   \code{html_classes<-} then all classes are removed.
#' @param ... Arguments passed to methods.
#' @return If \code{x} is a node, then a character vector containing
#'   the names of the classes of the HTML element. If the element has no
#'   classes, then a length-0 character vector is returned. If \code{x} is a
#'   node set, then a list of character vectors.
#' @examples
#' doc <- read_html("<div class='section level1'><h1>Title</h1></div>")
#' doc %>%
#'   html_nodes("div") %>%
#'   html_classes("level1")
#'
#' doc %>%
#'   html_nodes("section") %>%
#'   html_remove_classes("level1")
#'
#' doc %>%
#'   html_nodes("h1") %>%
#'   html_add_classes("chapter-title")
#'
#' @export
html_classes <- function(x, ...) {
  UseMethod("html_classes")
}

#' @importFrom xml2 xml_attr
#' @export
html_classes.xml_node <- function(x, ...) {
  klass <- xml_attr(x, "class")
  if (!length(klass) || is.na(klass)) {
    character()
  } else {
    html_class_str2vec(klass)
  }
}

#' @export
html_classes.xml_missing <- function(x, ...) {
  NA_character_
}

#' @export
html_classes.xml_nodeset <- function(x, ...) {
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
  xml_attr(x = x, attr = "class") <- value
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
}

#' @rdname html_classes
#' @export
html_has_classes <- function(x, .classes, ...) {
  UseMethod("html_has_classes")
}

#' @export
html_has_classes.xml_node <- function(x, .classes, ...) {
  all(.classes %in% html_classes(x))
}

#' @export
html_has_classes.xml_nodeset <- function(x, .classes, ...) {
  vapply(x, html_has_classes, TRUE, .classes = .classes)
}

#' @export
html_has_classes.xml_missing <- function(x, .classes, ...) {
  NA
}

#' @rdname html_classes
#' @export
html_add_classes <- function(x, .classes, ...) {
  UseMethod("html_add_classes")
}

#' @export
html_add_classes.xml_node <- function(x, .classes, ...) {
  newclasses <- c(html_classes, as.character(.classes))
  html_classes(x) <- newclasses
}

#' @export
html_add_classes.xml_nodeset <- function(x, .classes, ...) {
  lapply(x, html_add_classes, .classes = .classes, ...)
  x
}

#' @export
html_add_classes.xml_missing <- function(x, .classes, ...) {
  x
}

#' @rdname html_classes
#' @export
html_remove_classes <- function(x, .classes, ...) {
  UseMethod("html_remove_classes")
}

#' @export
html_remove_classes.xml_node <- function(x, .classes, ...) {
  newclasses <- setdiff(html_classes(x), as.character(.classes))
  # If no classes, remove class attribute
  if (!length(newclasses)) {
    newclasses <- NULL
  }
  html_classes(x) <- newclasses
}

#' @export
html_remove_classes.xml_nodeset <- function(x, .classes, ...) {
  lapply(x, html_remove_classes, .classes = .classes)
  x
}

#' @export
html_remove_classes.xml_missing <- function(x, .classes, ...) {
  x
}
