# Scrape miles from united site

library(rvest)
library(magrittr)

united <- html_session("http://www.united.com/")
account <- united %>% follow_link("Account")

login <- account %>%
  html_nodes("form") %>%
  extract2(1) %>%
  html_form() %>%
   set_values(
    `ctl00$ContentInfo$SignIn$onepass$txtField` = "GY797363",
    `ctl00$ContentInfo$SignIn$password$txtPassword` = password
  )
account <- account %>%
  submit_form(login, "ctl00$ContentInfo$SignInSecure")

logged_in %>% jump_to(gsub(" ", "+", headers(logged_in)$Location))

