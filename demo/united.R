# Scrape miles from united site
library(rvest)

united <- html_session("http://www.united.com/")

login <- united %>%
  html_node("form[name=LoginForm]") %>%
  html_form() %>%
  set_values(
    MpNumber = "GY797363",
    Password = password
  )

logged_in <- united %>% submit_form(login)

logged_in %>%
  follow_link("View account") %>%
  html_node("#ctl00_ContentInfo_AccountSummary_spanEliteMilesNew") %>%
  html_text() %>%
  readr::parse_number()
