# Inspired by https://github.com/notesofdabbler
library(rvest)
library(tidyr)

page <- read_html("http://www.zillow.com/homes/for_sale/Greenwood-IN/fsba,fsbo,fore,cmsn_lt/house_type/52333_rid/39.638414,-86.011362,39.550714,-86.179419_rect/12_zm/0_mmm/")

houses <- page %>%
  html_elements(".photo-cards li article")

z_id <- houses %>% html_attr("id")

address <- houses %>%
  html_element(".zsg-photo-card-address") %>%
  html_text()

price <- houses %>%
  html_element(".zsg-photo-card-price") %>%
  html_text() %>%
  readr::parse_number()

params <- houses %>%
  html_element(".zsg-photo-card-info") %>%
  html_text() %>%
  strsplit("\u00b7")

beds <- params %>% purrr::map_chr(1) %>% readr::parse_number()
baths <- params %>% purrr::map_chr(2) %>% readr::parse_number()
house_area <- params %>% purrr::map_chr(3) %>% readr::parse_number()
