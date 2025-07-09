#' Live web scraping (with chromote)
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' [read_html()] operates on the HTML source code downloaded from the server.
#' This works for most websites but can fail if the site uses javascript to
#' generate the HTML. `read_html_live()` provides an alternative interface
#' that runs a live web browser (Chrome) in the background. This allows you to
#' access elements of the HTML page that are generated dynamically by javascript
#' and to interact with the live page by clicking on buttons or typing in
#' forms.
#'
#' Behind the scenes, this function uses the
#' [chromote](https://rstudio.github.io/chromote/) package, which requires that
#' you have a copy of [Google Chrome](https://www.google.com/chrome/) installed
#' on your machine.
#'
#' @return `read_html_live()` returns an R6 [LiveHTML] object. You can interact
#'   with this object using the usual rvest functions, or call its methods,
#'   like `$click()`, `$scroll_to()`, and `$type()` to interact with the live
#'   page like a human would.
#' @param url Website url to read from.
#' @export
#' @examples
#' \dontrun{
#' # When we retrieve the raw HTML for this site, it doesn't contain the
#' # data we're interested in:
#' static <- read_html("https://www.forbes.com/top-colleges/")
#' static %>% html_elements(".TopColleges2023_tableRow__BYOSU")
#'
#' # Instead, we need to run the site in a real web browser, causing it to
#' # download a JSON file and then dynamically generate the html:
#'
#' sess <- read_html_live("https://www.forbes.com/top-colleges/")
#' sess$view()
#' rows <- sess %>% html_elements(".TopColleges2023_tableRow__BYOSU")
#' rows %>% html_element(".TopColleges2023_organizationName__J1lEV") %>% html_text()
#' rows %>% html_element(".grant-aid") %>% html_text()
#' }
read_html_live <- function(url) {
  check_installed(c("chromote", "R6"))
  LiveHTML$new(url)
}

#' Interact with a live web page
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' You construct an LiveHTML object with [read_html_live()] and then interact,
#' like you're a human, using the methods described below. When debugging a
#' scraping script it is particularly useful to use `$view()`, which will open
#' a live preview of the site, and you can actually see each of the operations
#' performed on the real site.
#'
#' rvest provides relatively simple methods for scrolling, typing, and
#' clicking. For richer interaction, you probably want to use a package
#' that exposes a more powerful user interface, like
#' [selendir](https://ashbythorpe.github.io/selenider/).
#'
#' @export
#' @examples
#' \dontrun{
#' # To retrieve data for this paginated site, we need to repeatedly push
#' # the "Load More" button
#' sess <- read_html_live("https://www.bodybuilding.com/exercises/finder")
#' sess$view()
#'
#' sess %>% html_elements(".ExResult-row") %>% length()
#' sess$click(".ExLoadMore-btn")
#' sess %>% html_elements(".ExResult-row") %>% length()
#' sess$click(".ExLoadMore-btn")
#' sess %>% html_elements(".ExResult-row") %>% length()
#' }
LiveHTML <- R6::R6Class(
  "LiveHTML",
  public = list(
    #' @field session Underlying chromote session object. For expert use only.
    session = NULL,

    #' @description initialize the object
    #' @param url URL to page.
    initialize = function(url) {
      private$live_session <- LiveSession$new(url)
      self$session <- private$live_session$session
    },

    #' @description Called when `print()`ed
    #' @param ... Ignored
    print = function(...) {
      print(self$html_elements("html > *"))
      invisible(self)
    },

    #' @description
    #' Display a live view of the site
    view = function() { # nocov start
      private$live_session$view()
      invisible(self)
    }, # nocov end

    #' @description
    #' Extract HTML elements from the current page.
    #' @param css,xpath CSS selector or xpath expression.
    html_elements = function(css, xpath) {
      private$live_session$html_elements(css, xpath)
    },

    #' @description Simulate a click on an HTML element.
    #' @param css CSS selector or xpath expression.
    #' @param n_clicks Number of clicks
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    click = function(css, n_clicks = 1, wait_for = NULL) {
      private$live_session$click(css, n_clicks, wait_for)
      invisible(self)
    },

    #' @description Get the current scroll position.
    get_scroll_position = function() {
      private$live_session$get_scroll_position()
    },

    #' @description Scroll selected element into view.
    #' @param css CSS selector or xpath expression.
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    scroll_into_view = function(css, wait_for = NULL) {
      private$live_session$scroll_into_view(css, wait_for)
      invisible(self)
    },

    #' @description Scroll to specified location
    #' @param top,left Number of pixels from top/left respectively.
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    scroll_to = function(top = 0, left = 0, wait_for = NULL) {
      private$live_session$scroll_to(top, left, wait_for)
      invisible(self)
    },

    #' @description Scroll by the specified amount
    #' @param top,left Number of pixels to scroll up/down and left/right
    #'   respectively.
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    scroll_by = function(top = 0, left = 0, wait_for = NULL) {
      private$live_session$scroll_by(top, left, wait_for)
      invisible(self)
    },

    #' @description Type text in the selected element
    #' @param css CSS selector or xpath expression.
    #' @param text A single string containing the text to type.
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    type = function(css, text, wait_for = NULL) {
      private$live_session$type(css, text, wait_for)
      invisible(self)
    },

    #' @description Simulate pressing a single key (including special keys).
    #' @param css CSS selector or xpath expression. Set to `NULL`
    #' @param key_code Name of key. You can see a complete list of known
    #'   keys at <https://pptr.dev/api/puppeteer.keyinput/>.
    #' @param modifiers A character vector of modifiers. Must be one or more
    #'   of `"Shift`, `"Control"`, `"Alt"`, or `"Meta"`.
    #' @param wait_for What to wait for after the click. Can be `NULL` (the
    #'   default, waits only for the click event to be sent), `"load"` (waits
    #'   for a `Page.loadEventFired` event), or a custom promise.
    press = function(css, key_code, modifiers = character(), wait_for = NULL) {
      private$live_session$press(css, key_code, modifiers, wait_for)
      invisible(self)
    },

    #' @description Wait for a promise to resolve and then sync the session
    #' @param promise A promise object to wait for. If `NULL`, the method
    #'   returns immediately.
    wait_for = function(promise = NULL) {
      private$live_session$wait_for(promise)
      invisible(self)
    }
  ),

  private = list(
    live_session = NULL
  )
)

# S3 Methods -----------------------------------------------------------------

#' @export
html_table.LiveHTML <- function(x,
                                header = NA,
                                trim = TRUE,
                                fill = deprecated(),
                                dec = ".",
                                na.strings = "NA",
                                convert = TRUE) {

  tables <- html_elements(x, "table")
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
html_elements.LiveHTML <- function(x, css, xpath) {
  x$html_elements(css, xpath)
}

#' @export
html_element.LiveHTML <- function(x, css, xpath) {
  out <- html_elements(x, css, xpath)
  if (length(out) == 0) {
    xml2::xml_missing()
  } else {
    out[[1]]
  }
}
