#' Parse an html table into a data frame.
#'
#' @section Assumptions:
#'
#' \code{html_table} currently makes a few assumptions:
#'
#' \itemize{
#' \item No cells span multiple rows
#' \item Headers are in the first row
#' }
#' @param x A node, node set or document.
#' @param header Use first row as header? If \code{NA}, will use first row
#'   if it consists of \code{<th>} tags.
#' @param trim Remove leading and trailing whitespace within each cell?
#' @param fill If \code{TRUE}, automatically fill rows with fewer than
#'   the maximum number of columns with \code{NA}s.
#' @param dec The character used as decimal mark.
#' @export
#' @examples
#' bonds <- html("http://finance.yahoo.com/bonds/composite_bond_rates")
#' tables <- html_nodes(bonds, "table")
#' html_table(tables[[2]])
#' html_table(tables[2:4])
#'
#' births <- html("http://www.ssa.gov/oact/babynames/numberUSbirths.html")
#' html_table(html_nodes(births, "table")[[2]])
#'
#' # If the table is badly formed, and has different number of rows in
#' # each column use fill = TRUE. Here's it's due to incorrect colspan
#' # specification.
#' skiing <- html("http://data.fis-ski.com/dynamic/results.html?sector=CC&raceid=22395")
#' skiing %>%
#'   html_table(fill = TRUE)
html_table <- function(x, header = NA, trim = TRUE, fill = FALSE, dec = ".") {
  UseMethod("html_table")
}

#' @export
html_table.XMLAbstractDocument <- function(x, ...) {
  html_table(html_nodes(x, "table"), ...)
}

#' @export
html_table.XMLNodeSet <- function(x, header = NA, trim = TRUE, fill = FALSE,
                                  dec = ".") {
  # FIXME: guess useful names
  lapply(x, html_table, header = header, trim = trim, fill = fill, dec = dec)
}

#' @export
html_table.XMLInternalElementNode <- function(x, header = NA, trim = TRUE,
                                              fill = FALSE, dec = ".") {

  stopifnot(html_tag(x) == "table")

  # Throw error if any rowspan/colspan present
  rows <- html_nodes(x, "tr")
  n <- length(rows)
  cells <- lapply(rows, "html_nodes", xpath = ".//td|.//th")

  ncols <- lapply(cells, html_attr, "colspan", default = "1")
  ncols <- lapply(ncols, as.integer)
  p <- unique(vapply(ncols, sum, integer(1)))

  if (length(p) > 1) {
    if (!fill) {
      stop("Table doesn't has different numbers of columns in different rows. ",
        "Do you want fill = TRUE?", call. = FALSE)
    } else {
      p <- max(p)
    }
  }

  values <- lapply(cells, html_text, trim = trim)
  out <- matrix(NA_character_, nrow = n, ncol = p)

  for (i in seq_len(n)) {
    row <- values[[i]]
    ncol <- ncols[[i]]
    col <- 1
    for (j in seq_len(p)) {
      if (j > length(row)) next
      out[i, col] <- row[[j]]
      col <- col + ncol[j]
    }
  }

  if (is.na(header)) {
    header <- all(html_tag(cells[[1]]) == "th")
  }
  if (header) {
    col_names <- out[1, ]
    out <- out[-1, ]
  } else {
    col_names <- paste("X", seq_along(ncol(out)))
  }

  df <- lapply(seq_len(p), function(i) {
    type.convert(out[, i], as.is = TRUE, dec = dec)
  })
  names(df) <- col_names
  class(df) <- "data.frame"
  attr(df, "row.names") <- .set_row_names(nrow(out))

  df
}

expand <- function(x, n) {


  browser()
  length(x) <- n
  x
}
