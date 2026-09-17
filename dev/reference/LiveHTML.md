# Interact with a live web page

**\[experimental\]**

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

- [`LiveHTML$new()`](#method-LiveHTML-new)

- [`LiveHTML$print()`](#method-LiveHTML-print)

- [`LiveHTML$view()`](#method-LiveHTML-view)

- [`LiveHTML$html_elements()`](#method-LiveHTML-html_elements)

- [`LiveHTML$click()`](#method-LiveHTML-click)

- [`LiveHTML$get_scroll_position()`](#method-LiveHTML-get_scroll_position)

- [`LiveHTML$scroll_into_view()`](#method-LiveHTML-scroll_into_view)

- [`LiveHTML$scroll_to()`](#method-LiveHTML-scroll_to)

- [`LiveHTML$scroll_by()`](#method-LiveHTML-scroll_by)

- [`LiveHTML$type()`](#method-LiveHTML-type)

- [`LiveHTML$press()`](#method-LiveHTML-press)

- [`LiveHTML$clone()`](#method-LiveHTML-clone)

------------------------------------------------------------------------

### Method `new()`

initialize the object

#### Usage

    LiveHTML$new(url)

#### Arguments

- `url`:

  URL to page.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Called when [`print()`](https://rdrr.io/r/base/print.html)ed

#### Usage

    LiveHTML$print(...)

#### Arguments

- `...`:

  Ignored

------------------------------------------------------------------------

### Method `view()`

Display a live view of the site

#### Usage

    LiveHTML$view()

------------------------------------------------------------------------

### Method [`html_elements()`](https://rvest.tidyverse.org/dev/reference/html_element.md)

Extract HTML elements from the current page.

#### Usage

    LiveHTML$html_elements(css, xpath)

#### Arguments

- `css, xpath`:

  CSS selector or xpath expression.

------------------------------------------------------------------------

### Method `click()`

Simulate a click on an HTML element.

#### Usage

    LiveHTML$click(css, n_clicks = 1)

#### Arguments

- `css`:

  CSS selector.

- `n_clicks`:

  Number of clicks

------------------------------------------------------------------------

### Method `get_scroll_position()`

Get the current scroll position.

#### Usage

    LiveHTML$get_scroll_position()

------------------------------------------------------------------------

### Method `scroll_into_view()`

Scroll selected element into view.

#### Usage

    LiveHTML$scroll_into_view(css)

#### Arguments

- `css`:

  CSS selector.

------------------------------------------------------------------------

### Method `scroll_to()`

Scroll to specified location

#### Usage

    LiveHTML$scroll_to(top = 0, left = 0)

#### Arguments

- `top, left`:

  Number of pixels from top/left respectively.

------------------------------------------------------------------------

### Method `scroll_by()`

Scroll by the specified amount

#### Usage

    LiveHTML$scroll_by(top = 0, left = 0)

#### Arguments

- `top, left`:

  Number of pixels to scroll up/down and left/right respectively.

------------------------------------------------------------------------

### Method `type()`

Type text in the selected element

#### Usage

    LiveHTML$type(css, text)

#### Arguments

- `css`:

  CSS selector.

- `text`:

  A single string containing the text to type.

------------------------------------------------------------------------

### Method `press()`

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

### Method `clone()`

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
