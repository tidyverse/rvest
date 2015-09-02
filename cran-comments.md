## Submission summary

This is a major rewrite which replaces use of the XML package with xml2 (thus avoiding many memory leaks). This is a large change, so I gave the downstream maintainers plenty of time to respond.

## Test environments

* local OS X install, R 3.1.2
* ubuntu 12.04 (on travis-ci), R 3.1.2
* win-builder (devel and release)

## R CMD check results

There were no ERRORs or WARNINGs.

There was 1 NOTEs:

* checking CRAN incoming feasibility ... NOTE

  html and httr are not spelling mistakes.

## Downstream dependencies

* I ran R CMD check on all 7 downstream dependencies. 
* Results summary at https://github.com/hadley/rvest/blob/master/revdep/summary.md
* Downstream maintainers were notified on Sep 2 that release would happen on Sep 22.
