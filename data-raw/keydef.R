# Extract the same data that puppeteer uses
url <- "https://raw.githubusercontent.com/puppeteer/puppeteer/main/packages/puppeteer-core/src/common/USKeyboardLayout.ts"

lines <- readLines(url)
first <- which(grepl("_keyDefinitions", lines))
last <- tail(which(grepl("^}", lines)), 1)



ct <- V8::v8()

def <- paste(c("keydef = {", lines[(first + 1):last]), collapse = "\n")
ct$eval(def)
keydefs <- ct$get("keydef")

usethis::use_data(keydefs, overwrite = TRUE, internal = TRUE)


tibble::enframe(keydef) |>
  unnest_wider(value) |>
  dplyr::arrange(keyCode) |>
  View()
