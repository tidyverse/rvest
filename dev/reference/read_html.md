# Static web scraping (with xml2)

`read_html()` works by performing a HTTP request then parsing the HTML
received using the xml2 package. This is "static" scraping because it
operates only on the raw HTML file. While this works for most sites, in
some cases you will need to use
[`read_html_live()`](https://rvest.tidyverse.org/dev/reference/read_html_live.md)
if the parts of the page you want to scrape are dynamically generated
with javascript.

Generally, we recommend using `read_html()` if it works, as it will be
faster and more robust, as it has fewer external dependencies (i.e. it
doesn't rely on the Chrome web browser installed on your computer.)

## Usage

``` r
read_html(
  x,
  encoding = "",
  ...,
  options = c("RECOVER", "NOERROR", "NOBLANKS", "HUGE")
)
```

## Arguments

- x:

  Usually a string representing a URL. See
  [`xml2::read_html()`](http://xml2.r-lib.org/reference/read_xml.md) for
  other options.

- encoding:

  Specify a default encoding for the document. Unless otherwise
  specified XML documents are assumed to be in UTF-8 or UTF-16. If the
  document is not UTF-8/16, and lacks an explicit encoding directive,
  this allows you to supply a default.

- ...:

  Additional arguments passed on to methods.

- options:

  Set parsing options for the libxml2 parser. Zero or more of

  RECOVER

  :   recover on errors

  NOENT

  :   substitute entities

  DTDLOAD

  :   load the external subset

  DTDATTR

  :   default DTD attributes

  DTDVALID

  :   validate with the DTD

  NOERROR

  :   suppress error reports

  NOWARNING

  :   suppress warning reports

  PEDANTIC

  :   pedantic error reporting

  NOBLANKS

  :   remove blank nodes

  SAX1

  :   use the SAX1 interface internally

  XINCLUDE

  :   Implement XInclude substitution

  NONET

  :   Forbid network access

  NODICT

  :   Do not reuse the context dictionary

  NSCLEAN

  :   remove redundant namespaces declarations

  NOCDATA

  :   merge CDATA as text nodes

  NOXINCNODE

  :   do not generate XINCLUDE START/END nodes

  COMPACT

  :   compact small text nodes; no modification of the tree allowed
      afterwards (will possibly crash if you try to modify the tree)

  OLD10

  :   parse using XML-1.0 before update 5

  NOBASEFIX

  :   do not fixup XINCLUDE xml:base uris

  HUGE

  :   relax any hardcoded limit from the parser

  OLDSAX

  :   parse using SAX2 interface before 2.7.0

  IGNORE_ENC

  :   ignore internal document encoding hint

  BIG_LINES

  :   Store big lines numbers in text PSVI field

## Examples

``` r
# Start by reading a HTML page with read_html():
starwars <- read_html("https://rvest.tidyverse.org/articles/starwars.html")

# Then find elements that match a css selector or XPath expression
# using html_elements(). In this example, each <section> corresponds
# to a different film
films <- starwars |> html_elements("section")
films
#> {xml_nodeset (7)}
#> [1] <section><h2 data-id="1">\nThe Phantom Menace\n</h2>\n<p>\nRelea ...
#> [2] <section><h2 data-id="2">\nAttack of the Clones\n</h2>\n<p>\nRel ...
#> [3] <section><h2 data-id="3">\nRevenge of the Sith\n</h2>\n<p>\nRele ...
#> [4] <section><h2 data-id="4">\nA New Hope\n</h2>\n<p>\nReleased: 197 ...
#> [5] <section><h2 data-id="5">\nThe Empire Strikes Back\n</h2>\n<p>\n ...
#> [6] <section><h2 data-id="6">\nReturn of the Jedi\n</h2>\n<p>\nRelea ...
#> [7] <section><h2 data-id="7">\nThe Force Awakens\n</h2>\n<p>\nReleas ...

# Then use html_element() to extract one element per film. Here
# we the title is given by the text inside <h2>
title <- films |>
  html_element("h2") |>
  html_text2()
title
#> [1] "The Phantom Menace"      "Attack of the Clones"   
#> [3] "Revenge of the Sith"     "A New Hope"             
#> [5] "The Empire Strikes Back" "Return of the Jedi"     
#> [7] "The Force Awakens"      

# Or use html_attr() to get data out of attributes. html_attr() always
# returns a string so we convert it to an integer using a readr function
episode <- films |>
  html_element("h2") |>
  html_attr("data-id") |>
  readr::parse_integer()
episode
#> [1] 1 2 3 4 5 6 7
```
