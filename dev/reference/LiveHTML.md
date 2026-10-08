# Interact with a live web page

You construct an LiveHTML object with
[`read_html_live()`](https://rvest.tidyverse.org/dev/reference/read_html_live.md)
and then interact, like you're a human, using the methods described
below. When debugging a scraping script it is particularly useful to use
`$view()`, which will open a live preview of the site, and you can
actually see each of the operations performed on the real site.

rvest provides relatively simple methods for scrolling, typing, and
clicking. For richer interaction, you probably want to use a package
that exposes a more powerful user interface, like
[selendir](https://ashbythorpe.github.io/selenider/).

## Public fields

- `session`:

  Underlying chromote session object. For expert use only.

## Methods

### Public methods

- [`LiveHTML$new()`](#method-LiveHTML-initialize)

- [`LiveHTML$print()`](#method-LiveHTML-print)

- [`LiveHTML$view()`](#method-LiveHTML-view)

- [`LiveHTML$html_elements()`](#method-LiveHTML-html_elements)

- [`LiveHTML$wait_for()`](#method-LiveHTML-wait_for)

- [`LiveHTML$click()`](#method-LiveHTML-click)

- [`LiveHTML$download()`](#method-LiveHTML-download)

- [`LiveHTML$get_scroll_position()`](#method-LiveHTML-get_scroll_position)

- [`LiveHTML$scroll_into_view()`](#method-LiveHTML-scroll_into_view)

- [`LiveHTML$scroll_to()`](#method-LiveHTML-scroll_to)

- [`LiveHTML$scroll_by()`](#method-LiveHTML-scroll_by)

- [`LiveHTML$type()`](#method-LiveHTML-type)

- [`LiveHTML$select()`](#method-LiveHTML-select)

- [`LiveHTML$press()`](#method-LiveHTML-press)

- [`LiveHTML$clone()`](#method-LiveHTML-clone)

------------------------------------------------------------------------

### `LiveHTML$new()`

initialize the object

#### Usage

    LiveHTML$new(
      url,
      mode = c("headless", "visible"),
      view = c("desktop", "mobile"),
      browser = NULL,
      timeout = 10,
      error = caller_env()
    )

#### Arguments

- `url`:

  URL to page.

- `mode, view, browser`:

  As described in
  [`read_html_live()`](https://rvest.tidyverse.org/dev/reference/read_html_live.md).

- `timeout`:

  Number of seconds to wait for the page to load.

- `error`:

  Execution environment used for error messages.

------------------------------------------------------------------------

### `LiveHTML$print()`

Called when [`print()`](https://rdrr.io/r/base/print.html)ed

#### Usage

    LiveHTML$print(...)

#### Arguments

- `...`:

  Ignored

------------------------------------------------------------------------

### `LiveHTML$view()`

Display a live view of the site

#### Usage

    LiveHTML$view()

------------------------------------------------------------------------

### `LiveHTML$html_elements()`

Extract HTML elements from the current page.

#### Usage

    LiveHTML$html_elements(css, xpath)

#### Arguments

- `css, xpath`:

  CSS selector or xpath expression.

------------------------------------------------------------------------

### `LiveHTML$wait_for()`

Wait for an element to appear on the page. Useful when a page renders
content with JavaScript after the initial page load.

#### Usage

    LiveHTML$wait_for(css, timeout = 5)

#### Arguments

- `css`:

  CSS selector.

- `timeout`:

  Maximum number of seconds to wait before erroring.

------------------------------------------------------------------------

### `LiveHTML$click()`

Simulate a click on an HTML element.

#### Usage

    LiveHTML$click(css, n_clicks = 1, method = c("mouse", "js"))

#### Arguments

- `css`:

  CSS selector.

- `n_clicks`:

  Number of clicks

- `method`:

  Click method. `"mouse"` simulates a real mouse click and requires the
  element to be visible on the page. `"js"` calls JavaScript's
  `element.click()` directly, which works even for hidden or off-screen
  elements, but only fires the `click` event (no `mousedown`, `mouseup`,
  or hover events).

------------------------------------------------------------------------

### `LiveHTML$download()`

Click on an element that triggers a download, and wait for the download
to complete.

#### Usage

    LiveHTML$download(css, dir = tempdir(), timeout = 30)

#### Arguments

- `css`:

  CSS selector.

- `dir`:

  Directory to save the file in. Will be created if needed.

- `timeout`:

  Maximum number of seconds to wait for the download to complete.

#### Returns

The path to the downloaded file, invisibly. The file name is determined
by the server.

------------------------------------------------------------------------

### `LiveHTML$get_scroll_position()`

Get the current scroll position.

#### Usage

    LiveHTML$get_scroll_position()

------------------------------------------------------------------------

### `LiveHTML$scroll_into_view()`

Scroll selected element into view.

#### Usage

    LiveHTML$scroll_into_view(css)

#### Arguments

- `css`:

  CSS selector.

------------------------------------------------------------------------

### `LiveHTML$scroll_to()`

Scroll to specified location

#### Usage

    LiveHTML$scroll_to(top = 0, left = 0)

#### Arguments

- `top, left`:

  Number of pixels from top/left respectively.

------------------------------------------------------------------------

### `LiveHTML$scroll_by()`

Scroll by the specified amount

#### Usage

    LiveHTML$scroll_by(top = 0, left = 0)

#### Arguments

- `top, left`:

  Number of pixels to scroll up/down and left/right respectively.

------------------------------------------------------------------------

### `LiveHTML$type()`

Type text in the selected element

#### Usage

    LiveHTML$type(css, text)

#### Arguments

- `css`:

  CSS selector.

- `text`:

  A single string containing the text to type.

------------------------------------------------------------------------

### `LiveHTML$select()`

Select an option in a `<select>` element.

#### Usage

    LiveHTML$select(css, value, text)

#### Arguments

- `css`:

  CSS selector.

- `value, text`:

  A single string giving the value or the visible text of the option to
  select. Supply exactly one.

------------------------------------------------------------------------

### `LiveHTML$press()`

Simulate pressing a single key (including special keys).

#### Usage

    LiveHTML$press(css, key_code, modifiers = character())

#### Arguments

- `css`:

  CSS selector.

- `key_code`:

  Name of key. You can see a complete list of known keys at
  <https://pptr.dev/api/puppeteer.keyinput>.

- `modifiers`:

  A character vector of modifiers. Must be one or more of `"Shift`,
  `"Control"`, `"Alt"`, or `"Meta"`.

------------------------------------------------------------------------

### `LiveHTML$clone()`

The objects of this class are cloneable with this method.

#### Usage

    LiveHTML$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (FALSE) { # \dontrun{
# To retrieve data for this paginated site, we need to repeatedly push
# the "Load More" button
sess <- read_html_live("https://www.bodybuilding.com/exercises/finder")
sess$view()

sess |> html_elements(".ExResult-row") |> length()
sess$click(".ExLoadMore-btn")
sess |> html_elements(".ExResult-row") |> length()
sess$click(".ExLoadMore-btn")
sess |> html_elements(".ExResult-row") |> length()
} # }
```
