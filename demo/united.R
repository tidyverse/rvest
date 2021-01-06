# Scrape miles from united site
library(rvest)

united <- session("http://www.united.com/")

login <- united %>%
  html_element("form[name=LoginForm]") %>%
  html_form() %>%
  html_form_set(
    MpNumber = "GY797363",
    Password = password
  )

logged_in <- united %>% session_submit(login)

logged_in %>%
  follow_link("View account") %>%
  html_element("#ctl00_ContentInfo_AccountSummary_spanEliteMilesNew") %>%
  html_text() %>%
  readr::parse_number()
