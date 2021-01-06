# Inspired by
# http://notesofdabbler.github.io/201408_hotelReview/scrapeTripAdvisor.html

library(rvest)

url <- "http://www.tripadvisor.com/Hotel_Review-g37209-d1762915-Reviews-JW_Marriott_Indianapolis-Indianapolis_Indiana.html"

reviews <- url %>%
  read_html() %>%
  html_elements("#REVIEWS .innerBubble")

id <- reviews %>%
  html_element(".quote a") %>%
  html_attr("id")

quote <- reviews %>%
  html_element(".quote span") %>%
  html_text()

rating <- reviews %>%
  html_element(".rating .rating_s_fill") %>%
  html_attr("alt") %>%
  gsub(" of 5 stars", "", .) %>%
  as.integer()

date <- reviews %>%
  html_element(".rating .ratingDate") %>%
  html_attr("title") %>%
  strptime("%b %d, %Y") %>%
  as.POSIXct()

review <- reviews %>%
  html_element(".entry .partial_entry") %>%
  html_text()

data.frame(id, quote, rating, date, review, stringsAsFactors = FALSE) %>% View()
