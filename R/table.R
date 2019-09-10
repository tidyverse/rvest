#' Parse an html table into a data frame.
#'
#' @section Assumptions:
#'
#' `html_table` currently makes a few assumptions:
#'
#' \itemize{
#' \item No cells span multiple rows
#' \item Headers are in the first row
#' }
#' @param x A node, node set or document.
#' @param header Use first row as header? If `NA`, will use first row
#'   if it consists of `<th>` tags.
#' @param trim Remove leading and trailing whitespace within each cell?
#' @param fill If `TRUE`, automatically fill rows with fewer than
#'   the maximum number of columns with `NA`s.
#' @param dec The character used as decimal mark.
#' @export
#' @examples
#' sample1 <- minimal_html("<table>
#'   <tr><th>Col A</th><th>Col B</th></tr>
#'   <tr><td>1</td><td>x</td></tr>
#'   <tr><td>4</td><td>y</td></tr>
#'   <tr><td>10</td><td>z</td></tr>
#' </table>")
#' sample1 %>%
#'   html_node("table") %>%
#'   html_table()
#'
#' # Values in merged cells will be duplicated
#' sample2 <- minimal_html("<table>
#'   <tr><th>A</th><th>B</th><th>C</th></tr>
#'   <tr><td>1</td><td>2</td><td>3</td></tr>
#'   <tr><td colspan='2'>4</td><td>5</td></tr>
#'   <tr><td>6</td><td colspan='2'>7</td></tr>
#' </table>")
#'
#' sample2 %>%
#'   html_node("table") %>%
#'   html_table()
#'
#' # If the table is badly formed, and has different number of columns
#' # in each row, use `fill = TRUE` to fill in the missing values
#' sample3 <- minimal_html("<table>
#'   <tr><th>A</th><th>B</th><th>C</th></tr>
#'   <tr><td colspan='2'>1</td><td>2</td></tr>
#'   <tr><td colspan='2'>3</td></tr>
#'   <tr><td>4</td></tr>
#' </table>")
#'
#' sample3 %>%
#'   html_node("table") %>%
#'   html_table(fill = TRUE)
html_table <- function(x, header = NA, trim = TRUE, fill = FALSE, dec = ".") {
  UseMethod("html_table")
}

#' @export
html_table.xml_document <- function(x, header = NA, trim = TRUE, fill = FALSE,
                                    dec = ".") {
  tables <- xml2::xml_find_all(x, ".//table")
  lapply(tables, html_table, header = header, trim = trim, fill = fill, dec = dec)
}


#' @export
html_table.xml_nodeset <- function(x, header = NA, trim = TRUE, fill = FALSE,
                                  dec = ".") {
  # FIXME: guess useful names
  lapply(x, html_table, header = header, trim = trim, fill = fill, dec = dec)
}

#' @export
html_table.xml_node <- function(x, header = NA, trim = TRUE,
                                              fill = FALSE, dec = ".") {

  stopifnot(html_name(x) == "table")

  # Throw error if any rowspan/colspan present
  rows <- html_nodes(x, "tr")
  n <- length(rows)
  cells <- lapply(rows, "html_nodes", xpath = ".//td|.//th")

  ncols <- lapply(cells, html_attr, "colspan", default = "1")
  ncols <- lapply(ncols, as.integer)
  nrows <- lapply(cells, html_attr, "rowspan", default = "1")
  nrows <- lapply(nrows, as.integer)

  p <- unique(vapply(ncols, sum, integer(1)))
  maxp <- max(p)

  if (length(p) > 1) {
    # then malformed table is not parsable by smart filling solution
    ncells <- sum(unlist(lapply(seq_len(n),
                                function(i) nrows[[i]] * ncols[[i]])))
    if (maxp * n != ncells & !fill) { # fill must then be specified to allow filling with NAs
      stop("Table has inconsistent number of columns. ",
           "Do you want fill = TRUE?", call. = FALSE)
    }
  }

  values <- lapply(cells, html_text, trim = trim)
  out <- matrix(NA_character_, nrow = n, ncol = maxp)

  # prepare vectors to hold the number of remaining columns and rows
  # each cell spans to the right and below
  colspans <- rep(0, maxp)
  rowspans <- rep(0, maxp)

  # fill colspans right and rowspans down with repetition
  for (i in seq_len(n)) {
    row <- values[[i]]
    ncol <- ncols[[i]]
    nrow <- nrows[[i]]
    cols <- length(ncol)
    j <- 1
    col <- 1
    while (col <= maxp) {
      if (rowspans[col] != 0) {
        # cell spanning over current row, data already written
        span <- col:(col+colspans[col]-1)
        rowspans[span] <- rowspans[span] - 1
        col <- col + colspans[col]
      } else if (j <= cols) {
        # new cell, write data
        lastr <- min(n, i+nrow[j]-1)
        lastc <- min(maxp, col+ncol[j]-1)
        out[i:lastr, col:lastc] <- row[[j]]
        colspans[col:lastc] <- (lastc-col+1):1
        rowspans[col:lastc] <- nrow[j] - 1
        col <- lastc + 1
        j <- j + 1
      } else {
        # past the last <td>, move carefully to find multirow cells
        col <- col + 1
      }
    }
  }

  if (is.na(header)) {
    header <- all(html_name(cells[[1]]) == "th")
  }
  if (header) {
    col_names <- out[1, , drop = FALSE]
    out <- out[-1, , drop = FALSE]
  } else {
    col_names <- paste0("X", seq_len(ncol(out)))
  }

  # Convert matrix to list to data frame
  df <- lapply(seq_len(maxp), function(i) {
    utils::type.convert(out[, i], as.is = TRUE, dec = dec)
  })
  names(df) <- col_names
  class(df) <- "data.frame"
  attr(df, "row.names") <- .set_row_names(length(df[[1]]))

  if (length(unique(col_names)) < length(col_names)) {
    warning('At least two columns have the same name')
  }

  df
}
