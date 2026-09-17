# SelectorGadget

SelectorGadget is a JavaScript bookmarklet that allows you to
interactively figure out what css selector you need to extract desired
components from a page.

## Installation

To install it, open this page in your browser, and then drag the
following link to your bookmark bar:
[SelectorGadget](javascript:(function()%7Bvar%20s=document.createElement('div');s.innerHTML='Loading...';s.style.color='black';s.style.padding='20px';s.style.position='fixed';s.style.zIndex='9999';s.style.fontSize='3.0em';s.style.border='2px%20solid%20black';s.style.right='40px';s.style.top='40px';s.setAttribute('class','selector_gadget_loading');s.style.background='white';document.body.appendChild(s);s=document.createElement('script');s.setAttribute('type','text/javascript');s.setAttribute('src','https://dv0akt2986vzh.cloudfront.net/unstable/lib/selectorgadget.js');document.body.appendChild(s);%7D)();).

## Use

To use it, open the page you want to scrape, then:

1.  Click the SelectorGadget entry in your bookmark bar.

2.  Click on the element you want to select. SelectorGadget will make a
    first guess at what css selector you want. It’s likely to be bad
    since it only has one example to learn from, but it’s a start.
    Elements that match the selector will be highlighted in yellow.

3.  Click on elements that shouldn’t be selected. They will turn red.
    Click on elements that *should* be selected. They will turn green.

4.  Iterate until only the elements you want are selected.
    SelectorGadget isn’t perfect and sometimes won’t be able to find a
    useful css selector. Sometimes starting from a different element
    helps.

## Example

For example, imagine we want to find the names of the movies listed in
[`vignette("starwars")`](https://rvest.tidyverse.org/dev/articles/starwars.md).

``` r

library(rvest)
html <- read_html("https://rvest.tidyverse.org/articles/starwars.html")
```

1.  Start by opening
    <https://rvest.tidyverse.org/articles/starwars.html> in a web
    browser.

2.  Click on the SelectorGadget link in the bookmarks. The
    SelectorGadget console will appear at the bottom of the screen, and
    element currently under the mouse will be highlighted in orange.

    ![A screenshot of the starwars vignette with an orange box drawn
    around the top few lines of the page. SelectorGadget reports "no
    valid path found"](selectorgadget-hover.png)

3.  Click on the movie name to select it. The element you selected will
    be highlighted in green. SelectorGadget guesses which css selector
    you want (`h2` in this case), and highlights all matches in yellow
    (see total count equal to 7 as indicated on on the “Clear” button).

    ![A screenshot of the starwars vignette with an green box around the
    heading "Attack of the Clones". SelectorGadget reports that a css
    selector of "h2" selects this element.](selectorgadget-click.png)

4.  Scroll around the document to verify that we have selected all the
    desired movie titles and nothing else. In this case, it looks like
    SelectorGadget figured it out on the first try, and we can use the
    selector in our R code:

    ``` r

    html |> 
      html_element("h2") |> 
      html_text2()
    #> [1] "The Phantom Menace"
    ```

Now let’s try something a little more challenging: selecting all
paragraphs of the movie intro.

1.  Start the same way as before, opening the website and then using the
    SelectorGadget bookmark, but this time we click on the first
    paragraph of the intro.

    ![A screenshot of the starwars vignette with an green box around the
    paragraph that begins "There is unrest in the Galactic Senate" Every
    other paragraph is coloured yellow.](selectorgadget-too-many.png)

2.  This obviously selects too many elements, so click on one of the
    paragraphs that shouldn’t match. It turns red indicating that this
    element shouldn’t be matched.

    ![A screenshot of the starwars vignette with an green box around the
    paragraph that begins "There is unrest in the Galactic Senate" and a
    red box around the sentence "Released: 2002-05-16". The sentence
    giving the director is unhiglighted and everything else is yellow.
    The discovered selector is ".crawl p".](selectorgadget-remove.png)

3.  This looks good, so we convert it to R code:

    ``` r

    html |> 
      html_elements(".crawl p") |> 
      html_text2() |> 
      _[1:4]
    #> [1] "Turmoil has engulfed the Galactic Republic. The taxation of trade routes to outlying star systems is in dispute."                                                                                                               
    #> [2] "Hoping to resolve the matter with a blockade of deadly battleships, the greedy Trade Federation has stopped all shipping to the small planet of Naboo."                                                                         
    #> [3] "While the Congress of the Republic endlessly debates this alarming chain of events, the Supreme Chancellor has secretly dispatched two Jedi Knights, the guardians of peace and justice in the galaxy, to settle the conflict…."
    #> [4] "There is unrest in the Galactic Senate. Several thousand solar systems have declared their intentions to leave the Republic."
    ```

This is correct, but we’ve lost the connection between title and intro.
To fix this problem we need to take a step back and see if we can find
an element that identifies all the data for one movie. By carefully
hovering, we can figure out that the `section` selector seems to do the
job:

``` r

films <- html |> html_elements("section")
films
#> {xml_nodeset (7)}
#> [1] <section><h2 data-id="1">\nThe Phantom Menace\n</h2>\n<p>\nRelea ...
#> [2] <section><h2 data-id="2">\nAttack of the Clones\n</h2>\n<p>\nRel ...
#> [3] <section><h2 data-id="3">\nRevenge of the Sith\n</h2>\n<p>\nRele ...
#> [4] <section><h2 data-id="4">\nA New Hope\n</h2>\n<p>\nReleased: 197 ...
#> [5] <section><h2 data-id="5">\nThe Empire Strikes Back\n</h2>\n<p>\n ...
#> [6] <section><h2 data-id="6">\nReturn of the Jedi\n</h2>\n<p>\nRelea ...
#> [7] <section><h2 data-id="7">\nThe Force Awakens\n</h2>\n<p>\nReleas ...
```

Then we can get the title for each film:

``` r

films |> 
  html_element("h2") |> 
  html_text2()
#> [1] "The Phantom Menace"      "Attack of the Clones"   
#> [3] "Revenge of the Sith"     "A New Hope"             
#> [5] "The Empire Strikes Back" "Return of the Jedi"     
#> [7] "The Force Awakens"
```

And the contents of that intro:

``` r

films |> 
  html_element(".crawl") |>
  html_text2() |> 
  _[[1]] |> 
  writeLines()
#> Turmoil has engulfed the Galactic Republic. The taxation of trade routes to outlying star systems is in dispute.
#> 
#> Hoping to resolve the matter with a blockade of deadly battleships, the greedy Trade Federation has stopped all shipping to the small planet of Naboo.
#> 
#> While the Congress of the Republic endlessly debates this alarming chain of events, the Supreme Chancellor has secretly dispatched two Jedi Knights, the guardians of peace and justice in the galaxy, to settle the conflict….
```

This is a pretty common experience — SelectorGadget will get you started
finding useful selectors but you’ll often have to combine it with other
code.
