# Inspired by https://github.com/notesofdabbler
library(rvest)
library(tidyr)

url <- "http://www.zillow.com/homes/for_sale/Greenwood-IN/fsba,fsbo,fore,cmsn_lt/house_type/52333_rid/39.638414,-86.011362,39.550714,-86.179419_rect/12_zm/0_mmm/"

houses <- read_html(url) %>%
  html_nodes("article")

z_id <- houses %>% html_attr("id")

address <- houses %>%
  html_node(".property-address a") %>%
  html_attr("href") %>%
  strsplit("/") %>%
  pluck(3, character(1))

area <- function(x) {
  val <- as.numeric(gsub("[^0-9.]+", "", x))
  as.integer(val * ifelse(grepl("ac", x), 43560, 1))
}
sqft <- houses %>%
  html_node(".property-lot") %>%
  html_text() %>%
  area()

year_build <- houses %>%
  html_node(".property-year") %>%
  html_text() %>%
  gsub("Built in ", "", .) %>%
  as.integer()

price <- houses %>%
  html_node(".price-large") %>%
  html_text() %>%
  tidyr::extract_numeric()

params <- houses %>%
  html_node(".property-data") %>%
  html_text() %>%
  strsplit(", ")
beds <- params %>%
  pluck(1, character(1)) %>%
  extract_numeric()
baths <- params %>%
  pluck(2, character(1)) %>%
  extract_numeric()
house_area <- params %>%
  pluck(3, character(1)) %>%
  area()
