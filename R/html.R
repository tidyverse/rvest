#' Get element name
#'
#' @param x A document (from [read_html()]), node set (from [html_elements()]),
#'   node (from [html_element()]), or session (from [session()]).
#' @return A character vector the same length as `x`
#' @export
#' @examples
#' url <- "https://rvest.tidyverse.org/articles/starwars.html"
#' html <- read_html(url)
#'
#' html %>%
#'   html_element("div") %>%
#'   html_children() %>%
#'   html_name()
#' @export
#' @importFrom xml2 xml_name
html_name <- function(x) {
  xml_name(x)
}

#' Get element attributes
#'
#' `html_attr()` gets a single attribute; `html_attrs()` gets all attributes.
#'
#' @inheritParams html_name
#' @param name Name of attribute to retrieve.
#' @param default A string used as a default value when the attribute does
#'   not exist in every element.
#' @return A character vector (for `html_attr()`) or list (`html_attrs()`)
#'   the same length as `x`.
#' @examples
#' html <- minimal_html('<ul>
#'   <li><a href="https://a.com" class="important">a</a></li>
#'   <li class="active"><a href="https://c.com">b</a></li>
#'   <li><a href="https://c.com">b</a></li>
#'   </ul>')
#'
#' html %>% html_elements("a") %>% html_attrs()
#'
#' html %>% html_elements("a") %>% html_attr("href")
#' html %>% html_elements("li") %>% html_attr("class")
#' html %>% html_elements("li") %>% html_attr("class", default = "inactive")
#' @export
#' @importFrom xml2 xml_attr
html_attr <- function(x, name, default = NA_character_) {
  check_string(name)
  check_string(default, allow_na = TRUE)

  xml_attr(x, name, default = default)
}

#' @rdname html_attr
#' @export
#' @importFrom xml2 xml_attrs
html_attrs <- function(x) {
  xml_attrs(x)
}

#' Get element children
#'
#' @inheritParams html_name
#' @examples
#' html <- minimal_html("<ul><li>1<li>2<li>3</ul>")
#' ul <- html_elements(html, "ul")
#' html_children(ul)
#'
#' html <- minimal_html("<p>Hello <b>Hadley</b><i>!</i>")
#' p <- html_elements(html, "p")
#' html_children(p)
#' @importFrom xml2 xml_children
#' @export
html_children <- function(x) {
  xml_children(x)
}
