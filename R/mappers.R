#' Iterate over a nodeset with attributes and return a tidy data frame
#'
#' @param x `xml_nodeset` object, containing text and attributes of interest
#' @param attrs character vector of attribute names. If missing, all attributes will be used
#' @param trim if `TRUE`, will trim leading and trailing spaces
#' @param defaults character vector of default values to be passed to `rvest::html_attr()`. Recycled to match length of `attrs`
#' @param add_text if `TRUE`, node content will be added as `.text` column (using `rvest::html_text`)
#'
#' @return data frame with one row per xml node, consisting of an html_text column with text and additional columns with attributes
#' @export
#'
#' @examples
#' \donttest{
#' library(rvest)
#' read_html("https://en.wikipedia.org/wiki/List_of_cognitive_biases") %>%
#'   html_nodes("tr td:nth-child(1) a") %>%
#'   html_attrs_dfr()
#'   }
#' @importFrom stats setNames
html_attrs_dfr <- function(x, attrs=NULL, trim=FALSE, defaults=NA_character_, add_text=TRUE){

  attrs <-  attrs %||% unique(unlist(lapply(rvest::html_attrs(x), names)))
  defaults <- rep(defaults, length.out=length(attrs))
  attrs_lst <- lapply(seq_along(attrs), function(i)
    rvest::html_attr(x, attrs[i], default = defaults[i]))
  if(trim) attrs_lst <- lapply(attrs_lst, trimws)
  attrs_lst <- stats::setNames(attrs_lst, attrs)
  res <- as.data.frame(do.call(cbind, attrs_lst), stringsAsFactors=FALSE, row.names = FALSE)

  if(add_text) res$.text <- rvest::html_text(x, trim=trim)
  res
}
