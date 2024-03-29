#' Parse an html table into a data frame
#'
#' The algorithm mimics what a browser does, but repeats the values of merged
#' cells in every cell that cover.
#'
#' @inheritParams html_name
#' @param header Use first row as header? If `NA`, will use first row
#'   if it consists of `<th>` tags.
#'
#'   If `TRUE`, column names are left exactly as they are in the source
#'   document, which may require post-processing to generate a valid data
#'   frame.
#' @param trim Remove leading and trailing whitespace within each cell?
#' @param fill Deprecated - missing cells in tables are now always
#'    automatically filled with `NA`.
#' @param dec The character used as decimal place marker.
#' @param na.strings Character vector of values that will be converted to `NA`
#'    if `convert` is `TRUE`.
#' @param convert If `TRUE`, will run [`type.convert()`] to interpret texts as
#'    integer, double, or `NA`.
#' @return
#' When applied to a single element, `html_table()` returns a single tibble.
#' When applied to multiple elements or a document, `html_table()` returns
#' a list of tibbles.
#' @export
#' @examples
#' sample1 <- minimal_html("<table>
#'   <tr><th>Col A</th><th>Col B</th></tr>
#'   <tr><td>1</td><td>x</td></tr>
#'   <tr><td>4</td><td>y</td></tr>
#'   <tr><td>10</td><td>z</td></tr>
#' </table>")
#' sample1 %>%
#'   html_element("table") %>%
#'   html_table()
#'
#' # Values in merged cells will be duplicated
#' sample2 <- minimal_html("<table>
#'   <tr><th>A</th><th>B</th><th>C</th></tr>
#'   <tr><td>1</td><td>2</td><td>3</td></tr>
#'   <tr><td colspan='2'>4</td><td>5</td></tr>
#'   <tr><td>6</td><td colspan='2'>7</td></tr>
#' </table>")
#' sample2 %>%
#'   html_element("table") %>%
#'   html_table()
#'
#' # If a row is missing cells, they'll be filled with NAs
#' sample3 <- minimal_html("<table>
#'   <tr><th>A</th><th>B</th><th>C</th></tr>
#'   <tr><td colspan='2'>1</td><td>2</td></tr>
#'   <tr><td colspan='2'>3</td></tr>
#'   <tr><td>4</td></tr>
#' </table>")
#' sample3 %>%
#'   html_element("table") %>%
#'   html_table()
html_table <- function(x,
                       header = NA,
                       trim = TRUE,
                       fill = deprecated(),
                       dec = ".",
                       na.strings = "NA",
                       convert = TRUE
  ) {

  check_bool(header, allow_na = TRUE)
  check_bool(trim)
  check_string(dec)
  check_character(na.strings)
  check_bool(convert)

  UseMethod("html_table")
}

#' @export
html_table.xml_document <- function(x,
                                    header = NA,
                                    trim = TRUE,
                                    fill = deprecated(),
                                    dec = ".",
                                    na.strings = "NA",
                                    convert = TRUE) {
  tables <- xml2::xml_find_all(x, ".//table")
  html_table(
    tables,
    header = header,
    trim = trim,
    fill = fill,
    dec = dec,
    na.strings = na.strings,
    convert = convert
  )
}

#' @export
html_table.xml_nodeset <- function(x,
                                   header = NA,
                                   trim = TRUE,
                                   fill = deprecated(),
                                   dec = ".",
                                   na.strings = "NA",
                                   convert = TRUE) {
  lapply(
    x,
    html_table,
    header = header,
    trim = trim,
    fill = fill,
    dec = dec,
    na.strings = na.strings,
    convert = convert
  )
}

#' @export
html_table.xml_node <- function(x,
                                header = NA,
                                trim = TRUE,
                                fill = deprecated(),
                                dec = ".",
                                na.strings = "NA",
                                convert = TRUE) {

  if (lifecycle::is_present(fill) && !isTRUE(fill)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "html_table(fill = )",
      details = "An improved algorithm fills by default so it is no longer needed.",
      user_env = caller_env(2) # S3 generic
    )
  }

  ns <- xml2::xml_ns(x)
  rows <- xml2::xml_find_all(x, ".//tr", ns = ns)
  cells <- lapply(rows, xml2::xml_find_all, ".//td|.//th", ns = ns)
  cells <- compact(cells)

  if (length(cells) == 0) {
    return(tibble::tibble())
  }

  out <- table_fill(cells, trim = trim)

  if (is.na(header)) {
    header <- all(html_name(cells[[1]]) == "th")
  }
  if (header) {
    col_names <- out[1, , drop = FALSE]
    out <- out[-1, , drop = FALSE]
  } else {
    col_names <- paste0("X", seq_len(ncol(out)))
  }

  colnames(out) <- col_names
  df <- tibble::as_tibble(out, .name_repair = "minimal")

  if (isTRUE(convert)) {
    df[] <- lapply(df, function(x) {
        utils::type.convert(x, as.is = TRUE, dec = dec, na.strings = na.strings)
    })
  }

  df
}

# Table fillng algorithm --------------------------------------------------
# Base on https://html.spec.whatwg.org/multipage/tables.html#forming-a-table

table_fill <- function(cells, trim = TRUE) {
  width <- 0
  height <- length(cells) # initial estimate
  values <- vector("list", height)

  # list of downward spanning cells
  dw <- dw_init()

  # https://html.spec.whatwg.org/multipage/tables.html#algorithm-for-processing-rows
  for (i in seq_along(cells)) {
    row <- cells[[i]]
    if (length(row) == 0) {
      next
    }

    rowspan <- as.integer(html_attr(row, "rowspan", default = NA_character_))
    rowspan[is.na(rowspan)] <- 1
    colspan <- as.integer(html_attr(row, "colspan", default = NA_character_))
    colspan[is.na(colspan)] <- 1
    text <- html_text(row)
    if (isTRUE(trim)) {
      text <- gsub("^[[:space:]\u00a0]+|[[:space:]\u00a0]+$", "", text)
    }

    vals <- rep(NA_character_, width)
    col <- 1
    j <- 1
    while(j <= length(row)) {
      if (col %in% dw$col) {
        cell <- dw_find(dw, col)
        cell_text <- cell$text
        cell_colspan <- cell$colspan
      } else {
        cell_text <- text[[j]]
        cell_colspan <- colspan[[j]]

        if (rowspan[[j]] > 1) {
          dw <- dw_add(dw, col, rowspan[[j]], colspan[[j]], text[[j]])
        }

        j <- j + 1
      }
      vals[col:(col + cell_colspan - 1L)] <- cell_text
      col <- col + cell_colspan
    }

    # Add any downward cells after last <td>
    for(j in seq2(col - 1L, width)) {
      if (j %in% dw$col) {
        cell <- dw_find(dw, j)
        vals[j:(j + cell$colspan - 1L)] <- cell$text
      }
    }

    dw <- dw_prune(dw)
    values[[i]] <- vals

    height <- max(height, i + max(rowspan) - 1L)
    width <- max(width, col - 1L)
  }

  # Add any downward cells after <tr>
  i <- length(values) + 1
  length(values) <- height
  while (length(dw$col) > 0) {
    vals <- rep(NA_character_, width)
    for (col in dw$col) {
      cell <- dw_find(dw, col)
      vals[col:(col + cell$colspan - 1L)] <- cell$text
    }
    values[[i]] <- vals
    i <- i + 1
    dw <- dw_prune(dw)
  }

  values <- lapply(values, `[`, seq_len(width))
  matrix(unlist(values), ncol = width, byrow = TRUE)
}

dw_find <- function(dw, col) {
  match <- col == dw$col
  list(
    col = dw$col[match],
    rowspan = dw$rowspan[match],
    colspan = dw$colspan[match],
    text = dw$text[match]
  )
}

dw_init <- function() {
  list(
    col = integer(),
    rowspan = integer(),
    colspan = integer(),
    text = character()
  )
}

dw_add <- function(dw, col, rowspan, colspan, text) {
  dw$col <-     c(dw$col, col)
  dw$text <-    c(dw$text, text)
  dw$rowspan <- c(dw$rowspan, rowspan)
  dw$colspan <- c(dw$colspan, colspan)
  dw
}

dw_prune <- function(dw) {
  dw$rowspan <- dw$rowspan - 1L
  keep <- dw$rowspan > 0L

  dw$col <-     dw$col[keep]
  dw$text <-    dw$text[keep]
  dw$rowspan <- dw$rowspan[keep]
  dw$colspan <- dw$colspan[keep]
  dw
}
