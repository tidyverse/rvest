# Scrape miles from united site

united <- html_session("http://www.united.com/")
account <- united %>% follow_link("Account")

login <- account[sel("form")][[1]]
login <- login %>% html_form() %>%
   set_values(
    `ctl00$ContentInfo$SignIn$onepass$txtField` = "GY797363",
    `ctl00$ContentInfo$SignIn$password$txtPassword` = password
  )
account <- account %>%
  submit_form(login, "ctl00$ContentInfo$SignInSecure")

logged_in %>% jump_to(gsub(" ", "+", headers(logged_in)$Location))

