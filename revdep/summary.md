# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.2.1 (2015-06-18) |
|system   |x86_64, darwin13.4.0         |
|ui       |RStudio (0.99.673)           |
|language |(EN)                         |
|collate  |en_US.UTF-8                  |
|tz       |America/Chicago              |
|date     |2015-09-02                   |

## Packages

|package  |*  |version |date       |source         |
|:--------|:--|:-------|:----------|:--------------|
|httr     |   |1.0.0   |2015-06-25 |CRAN (R 3.2.0) |
|knitr    |   |1.10.5  |2015-05-06 |CRAN (R 3.2.0) |
|magrittr |   |1.5     |2014-11-22 |CRAN (R 3.2.0) |
|png      |   |0.1-7   |2013-12-03 |CRAN (R 3.2.0) |
|selectr  |   |0.2-3   |2014-12-24 |CRAN (R 3.2.0) |
|stringi  |   |0.5-5   |2015-06-29 |CRAN (R 3.2.0) |
|testthat |*  |0.10.0  |2015-05-22 |CRAN (R 3.2.0) |
|xml2     |   |0.1.1   |2015-06-02 |CRAN (R 3.2.0) |

# Check results
7 checked out of 7 dependencies 

## gsheet (0.1.0)
Maintainer: Max Conway <conway.max1@gmail.com>  
Bug reports: https://github.com/maxconway/gsheet/issues

```
checking examples ... WARNING
Found the following significant warnings:

  Warning: 'rvest::html' is deprecated.
  Warning: 'rvest::html' is deprecated.
  Warning: 'rvest::html' is deprecated.
Deprecated functions may be defunct as soon as of the next release of
R.
See ?Deprecated.
```
```
DONE
Status: 1 WARNING
```

## MazamaSpatialUtils (0.3.2)
Maintainer: Jonathan Callahan <jonathan.s.callahan@gmail.com>

__OK__

## nhanesA (0.5)
Maintainer: Christopher Endres <cjendres1@gmail.com>

```
checking examples ... [9s/14s] WARNING
Found the following significant warnings:

  Warning: 'html' is deprecated.
  Warning: 'html' is deprecated.
  Warning: 'html' is deprecated.
  Warning: 'html' is deprecated.
  Warning: 'html' is deprecated.
  Warning: 'html' is deprecated.
Deprecated functions may be defunct as soon as of the next release of
R.
See ?Deprecated.
```
```
DONE
Status: 1 WARNING
```

## rex (1.0.1)
Maintainer: Jim Hester <james.f.hester@gmail.com>  
Bug reports: https://github.com/kevinushey/rex/issues

__OK__

## rNOMADS (2.1.4)
Maintainer: Daniel C. Bowman <daniel.bowman@unc.edu>

__OK__

## rUnemploymentData (1.0.0)
Maintainer: Ari Lamstein <arilamstein@gmail.com>  
Bug reports: https://github.com/trulia/choroplethr/issues

__OK__

## wikipediatrend (1.1.6)
Maintainer: Peter Meissner <retep.meissner@gmail.com>  
Bug reports: https://github.com/petermeissner/wikipediatrend/issues

```
checking package dependencies ... NOTE
Packages suggested but not available for checking:
  ‘AnomalyDetection’ ‘BreakoutDetection’
```
```
checking examples ... WARNING
Found the following significant warnings:

  Warning: 'rvest::html' is deprecated.
  Warning: 'rvest::html' is deprecated.
Deprecated functions may be defunct as soon as of the next release of
R.
See ?Deprecated.
```
```
checking tests ... ERROR
Running the tests in ‘tests/testthat.R’ failed.
Last 13 lines of output:
  11: Ops.data.frame(dings, dongs)
  12: matrix(unlist(value, recursive = FALSE, use.names = FALSE), nrow = nr, dimnames = list(rn, 
         cn))
  
  Error : expecting a single value
  testthat results ================================================================
  OK: 63 SKIPPED: 0 FAILED: 3
  1. Failure (at test_caching_gathering.R#27): normal usage 
  2. Failure (at test_caching_gathering.R#39): setting cache file 
  3. Error: cache reset 
  
  Error: testthat unit tests failed
  Execution halted
```
```
checking re-building of vignette outputs ... NOTE
Error in re-building vignettes:
  ...
http://stats.grok.se/json/es/201506/Objetivos_de_Desarrollo_del_Milenio
Error in eval(expr, envir, enclos) : expecting a single value
http://stats.grok.se/json/es/201507/Objetivos_de_Desarrollo_del_Milenio
Error in eval(expr, envir, enclos) : expecting a single value
http://stats.grok.se/json/es/201508/Objetivos_de_Desarrollo_del_Milenio
Error in eval(expr, envir, enclos) : expecting a single value
http://stats.grok.se/json/en/201505/Millennium_Development_Goals
Error in eval(expr, envir, enclos) : expecting a single value
http://stats.grok.se/json/en/201506/Millennium_Development_Goals
Error in eval(expr, envir, enclos) : expecting a single value
http://stats.grok.se/json/en/201507/Millennium_Development_Goals
Error in eval(expr, envir, enclos) : expecting a single value
http://stats.grok.se/json/en/201508/Millennium_Development_Goals
Error in eval(expr, envir, enclos) : expecting a single value
http://stats.grok.se/json/en/201508/Cheese
Error in eval(expr, envir, enclos) : expecting a single value
http://stats.grok.se/json/de/201508/K%C3%A4se
Error in eval(expr, envir, enclos) : expecting a single value
Error in eval(expr, envir, enclos) : expecting a single value
Error in eval(expr, envir, enclos) : expecting a single value
Error in eval(expr, envir, enclos) : expecting a single value
Quitting from lines 286-289 (using-wikipediatrend.Rmd) 
Error: processing vignette 'using-wikipediatrend.Rmd' failed with diagnostics:
expecting a single value
Execution halted

```
```
DONE
Status: 1 ERROR, 1 WARNING, 2 NOTEs
```

