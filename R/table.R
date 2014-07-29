#' Parse an html table into a data frame.
#'
#' @section Assumptions:
#'
#' \code{html_table} currently makes a few assumptions:
#'
#' \itemize{
#' \item No cells span multiple rows or columns
#' \item Headers are in the first row
#' \item All rows have the same number of cells
#' }
#' @param x HTML tag or list of tags to parse.
#' @param header Use first row as header? If \code{NA}, will use first row
#'   if it consists of \code{<th>} tags.
#' @param trim Remove leading and trailing whitespace within each cell?
#' @export
#' @examples
#' bonds <- html("http://finance.yahoo.com/bonds/composite_bond_rates")
#' tables <- bonds[sel("table")]
#' html_table(tables[[2]])
#' html_table(tables[2:4])
#'
#' births <- html("http://www.ssa.gov/oact/babynames/numberUSbirths.html")
#' html_table(births[sel("table")][[2]])
html_table <- function(x, header = NA, trim = TRUE) {
  UseMethod("html_table")
}

#' @export
html_table.XMLNodeSet <- function(x, header = NA, trim = TRUE) {
  # FIXME: guess useful names
  lapply(x, html_table, header = header, trim = trim)
}

#' @export
html_table.XMLInternalElementNode <- function(x, header = NA, trim = TRUE) {

  stopifnot(html_tag(x) == "table")

  # Throw error if any rowspan/colspan present
  rows <- x[sel("tr")]
  cells <- lapply(rows, "[", sel("td, th"))

  n <- unique(vapply(cells, length, integer(1)))
  if (length(n) != 1) {
    stop("Table doesn't have equal number of columns in every row",
      call. = FALSE)
  }

  is_header <- t(vapply(cells, function(x) html_tag(x) == "th", logical(n)))
  if (is.na(header)) {
    header <- all(is_header[1, ])
  }

  values <- t(vapply(cells, html_text, trim = trim, FUN.VALUE = character(n)))
  if (header) {
    col_names <- values[1, ]
    values <- values[-1, ]
  } else {
    col_names <- paste("X", seq_along(ncol(values)))
  }

  df <- lapply(seq_len(ncol(values)), function(i) {
    type.convert(values[, i], as.is = TRUE)
  })
  names(df) <- col_names
  class(df) <- "data.frame"
  attr(df, "row.names") <- .set_row_names(nrow(values))

  df
}
