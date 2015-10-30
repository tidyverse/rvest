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
#' tdist <- read_html("http://en.wikipedia.org/wiki/Student%27s_t-distribution")
#' tdist %>%
#'   html_node("table.infobox") %>%
#'   html_table(header = FALSE)
#'
#' births <- read_html("https://www.ssa.gov/oact/babynames/numberUSbirths.html")
#' html_table(html_nodes(births, "table")[[2]])
#'
#' # If the table is badly formed, and has different number of rows in
#' # each column use fill = TRUE. Here's it's due to incorrect colspan
#' # specification.
#' skiing <- read_html("http://data.fis-ski.com/dynamic/results.html?sector=CC&raceid=22395")
#' skiing %>%
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
  p <- unique(vapply(ncols, sum, integer(1)))

  if (length(p) > 1) {
    if (!fill) {
      stop("Table has inconsistent number of columns. ",
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
    header <- all(html_name(cells[[1]]) == "th")
  }
  if (header) {
    col_names <- out[1, , drop = FALSE]
    out <- out[-1, , drop = FALSE]
  } else {
    col_names <- paste0("X", seq_len(ncol(out)))
  }

  # Convert matrix to list to data frame
  df <- lapply(seq_len(p), function(i) {
    utils::type.convert(out[, i], as.is = TRUE, dec = dec)
  })
  names(df) <- col_names
  class(df) <- "data.frame"
  attr(df, "row.names") <- .set_row_names(length(df[[1]]))

  df
}
