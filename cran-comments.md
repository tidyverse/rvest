## Submission summary

This is a major rewrite which replaces use of the XML package with xml2 (thus avoiding many memory leaks). This is a large change, so I gave the downstream maintainers plenty of time to respond.

## Test environments

* local OS X install, R 3.1.2
* ubuntu 12.04 (on travis-ci), R 3.1.2
* win-builder (devel and release)

## R CMD check results

There were no ERRORs or WARNINGs.

There was 1 NOTE:

* I have changed the maintainer address to hadley@rstudio.com. I'll send
  a confirmation from my old address shortly.

* There was a false positive for "found the following (possibly) invalid URLs":
  the vignette includes a javascript bookmarklet which starts with
  `javascript:`.

## Downstream dependencies

* I ran R CMD check on all 7 downstream dependencies. (Summary at 
  https://github.com/hadley/rvest/blob/master/revdep/summary.md)
  
* There are three new failures:

  * gsheet, nhanesA: uses deprecated function
  * wikipediatrend: uses deprecated function, test now fails

* I notified all downstream maintainers on Sep 2 that release would happen on 
  Sep 22. I notified them again today.
