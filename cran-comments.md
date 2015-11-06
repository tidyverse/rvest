## Submission summary

* Fixes failing url in examples.
* Also includes two minor bug fixes.

## Test environments

* local OS X install, R 3.2.1
* ubuntu 12.04 (on travis-ci), R 3.2.2
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs.

There was one NOTE:

* "Found the following (possibly) invalid URLs: URL: javascript:(...)" - 
  this is a false positive. It's a valid used to embed a JS bookmarklet in
  a vignette.

## Downstream dependencies

* I ran R CMD check on all 9 downstream dependencies. (Summary at 
  https://github.com/hadley/rvest/blob/master/revdep/summary.md)
  
* There were no new failures
