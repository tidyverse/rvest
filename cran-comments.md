## Test environments

* local: darwin15.6.0-3.5.2
* travis: 3.1, 3.2, 3.3, oldrel, release, devel
* r-hub: windows-x86_64-devel, ubuntu-gcc-release, fedora-clang-devel
* win-builder: windows-x86_64-devel

## R CMD check results

0 errors | 0 warnings | 2 notes

* Found the following (possibly) invalid URLs:
  URL: http://www.crummy.com/software/BeautifulSoup/
  
  I see this on win-builder but not locally, so this might be
  an SSL misconfig (old certs?) on win-builder.
 
* checking dependencies in R code ... NOTE
  Missing or unexported object: 'xml2::xml_find_first'
  
  This is a new function in xml2 1.0.0 currently protected behind a
  packageVersion() switch.

## Reverse dependencies

I have run R CMD check on all 19 downstream dependencies
(results at https://github.com/hadley/rvest/blob/master/revdep/).

There were no errors or warnings.
