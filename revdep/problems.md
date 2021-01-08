# coalitions

<details>

* Version: 0.6.15
* GitHub: https://github.com/adibender/coalitions
* Source code: https://github.com/cran/coalitions
* Date/Publication: 2020-08-31 08:40:06 UTC
* Number of recursive dependencies: 77

Run `cloud_details(, "coalitions")` for more info

</details>

## Newly broken

*   checking tests ... ERROR
    ```
      Running ‘testthat.R’
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      > 
      > test_check("coalitions")
      ══ Failed tests ════════════════════════════════════════════════════════════════
      ── Failure (test-scrapers.R:70:3): Federal german scrapers work ────────────────
      he[he$date == as.Date("2018-09-07"), "others"] not identical to 4.
      Modes: list, numeric
      names for target but not for current
      Attributes: < Modes: list, NULL >
      Attributes: < Lengths: 2, 0 >
      Attributes: < names for target but not for current >
      Attributes: < current is not list-like >
      
      [ FAIL 1 | WARN 43 | SKIP 0 | PASS 80 ]
      Error: Test failures
      Execution halted
    ```

# fitzRoy

<details>

* Version: 0.3.2
* GitHub: https://github.com/jimmyday12/fitzRoy
* Source code: https://github.com/cran/fitzRoy
* Date/Publication: 2020-05-23 05:10:05 UTC
* Number of recursive dependencies: 92

Run `cloud_details(, "fitzRoy")` for more info

</details>

## Newly broken

*   checking dependencies in R code ... NOTE
    ```
    Missing or unexported object: ‘rvest::pluck’
    ```

# gluedown

<details>

* Version: 1.0.2
* GitHub: https://github.com/kiernann/gluedown
* Source code: https://github.com/cran/gluedown
* Date/Publication: 2020-01-14 05:50:02 UTC
* Number of recursive dependencies: 65

Run `cloud_details(, "gluedown")` for more info

</details>

## Newly broken

*   checking tests ... ERROR
    ```
      Running ‘spelling.R’
      Running ‘testthat.R’
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      ● could not find function 'condition' (1)
      
      ══ Failed tests ════════════════════════════════════════════════════════════════
      ── Failure (test-4.10-tables.R:38:3): md_table creates a single <table> tag (ex. 198) ──
      `node` not equal to `df`.
      Attributes: < Component "class": Lengths (3, 1) differ (string compare on first 1) >
      Attributes: < Component "class": 1 string mismatch >
      ── Failure (test-4.10-tables.R:53:3): md_table can create a table with no body (ex. 205) ──
      `node` not equal to `df`.
      Attributes: < Component "class": Lengths (3, 1) differ (string compare on first 1) >
      Attributes: < Component "class": 1 string mismatch >
      
      [ FAIL 2 | WARN 1 | SKIP 6 | PASS 122 ]
      Error: Test failures
      Execution halted
    ```

# helminthR

<details>

* Version: 1.0.7
* GitHub: https://github.com/rOpenSci/helminthR
* Source code: https://github.com/cran/helminthR
* Date/Publication: 2019-02-03 16:33:14 UTC
* Number of recursive dependencies: 56

Run `cloud_details(, "helminthR")` for more info

</details>

## Newly broken

*   checking whether package ‘helminthR’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/tmp/workdir/helminthR/new/helminthR.Rcheck/00install.out’ for details.
    ```

## Newly fixed

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘knitr’ ‘rmarkdown’
      All declared Imports should be used.
    ```

## Installation

### Devel

```
* installing *source* package ‘helminthR’ ...
** package ‘helminthR’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
Error: object ‘html’ is not exported by 'namespace:rvest'
Execution halted
ERROR: lazy loading failed for package ‘helminthR’
* removing ‘/tmp/workdir/helminthR/new/helminthR.Rcheck/helminthR’


```
### CRAN

```
* installing *source* package ‘helminthR’ ...
** package ‘helminthR’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
** building package indices
** installing vignettes
** testing if installed package can be loaded from temporary location
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (helminthR)


```
# ihpdr

<details>

* Version: 1.2.1
* GitHub: https://github.com/kvasilopoulos/ihpdr
* Source code: https://github.com/cran/ihpdr
* Date/Publication: 2020-07-13 04:30:06 UTC
* Number of recursive dependencies: 69

Run `cloud_details(, "ihpdr")` for more info

</details>

## Newly broken

*   checking examples ... ERROR
    ```
    Running examples in ‘ihpdr-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: ihpd_release_dates
    > ### Title: Fetches the latest release dates
    > ### Aliases: ihpd_release_dates
    > 
    > ### ** Examples
    > 
    > ihpd_release_dates()
    Error in type.convert.default(out[, i], as.is = TRUE, dec = dec, na.strings = na.strings) : 
      promise already under evaluation: recursive default argument reference or earlier problems?
    Calls: ihpd_release_dates ... lapply -> FUN -> <Anonymous> -> type.convert.default
    Execution halted
    ```

# MazamaCoreUtils

<details>

* Version: 0.4.6
* GitHub: https://github.com/MazamaScience/MazamaCoreUtils
* Source code: https://github.com/cran/MazamaCoreUtils
* Date/Publication: 2020-11-13 21:20:03 UTC
* Number of recursive dependencies: 94

Run `cloud_details(, "MazamaCoreUtils")` for more info

</details>

## Newly broken

*   checking examples ... ERROR
    ```
    Running examples in ‘MazamaCoreUtils-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: html_getTables
    > ### Title: Find all tables in an html page
    > ### Aliases: html_getTables html_getTable
    > 
    > ### ** Examples
    > 
    > library(MazamaCoreUtils)
    ...
      promise already under evaluation: recursive default argument reference or earlier problems?
    ERROR [2021-01-07 19:14:52] Error in type.convert.default(out[, i], as.is = TRUE, dec = dec, na.strings = na.strings) : 
      promise already under evaluation: recursive default argument reference or earlier problems?
    ERROR [2021-01-07 19:14:52] Error in type.convert.default(out[, i], as.is = TRUE, dec = dec, na.strings = na.strings) : 
      promise already under evaluation: recursive default argument reference or earlier problems?
    ERROR [2021-01-07 19:14:52] Error in type.convert.default(out[, i], as.is = TRUE, dec = dec, na.strings = na.strings) : 
      promise already under evaluation: recursive default argument reference or earlier problems?
    Error: Error in type.convert.default(out[, i], as.is = TRUE, dec = dec, na.strings = na.strings) : 
      promise already under evaluation: recursive default argument reference or earlier problems?
    Execution halted
    ```

# nhanesA

<details>

* Version: 0.6.5
* GitHub: https://github.com/cjendres1/nhanes
* Source code: https://github.com/cran/nhanesA
* Date/Publication: 2018-10-17 05:20:23 UTC
* Number of recursive dependencies: 88

Run `cloud_details(, "nhanesA")` for more info

</details>

## Newly broken

*   checking examples ... ERROR
    ```
    Running examples in ‘nhanesA-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: nhanesSearchTableNames
    > ### Title: Search for matching table names
    > ### Aliases: nhanesSearchTableNames
    > 
    > ### ** Examples
    > 
    > nhanesSearchTableNames('HPVS', includerdc=TRUE, details=TRUE)
    Warning: `xml_nodes()` is deprecated as of rvest 1.0.0.
    Please use `html_elements()` instead.
    This warning is displayed once every 8 hours.
    Call `lifecycle::last_warnings()` to see where this warning was generated.
    Error in type.convert.default(out[, i], as.is = TRUE, dec = dec, na.strings = na.strings) : 
      promise already under evaluation: recursive default argument reference or earlier problems?
    Calls: nhanesSearchTableNames ... lapply -> FUN -> <Anonymous> -> type.convert.default
    Execution halted
    ```

# qqr

<details>

* Version: 0.0.1
* GitHub: NA
* Source code: https://github.com/cran/qqr
* Date/Publication: 2020-10-14 12:10:02 UTC
* Number of recursive dependencies: 97

Run `cloud_details(, "qqr")` for more info

</details>

## Newly broken

*   checking examples ... ERROR
    ```
    Running examples in ‘qqr-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: previousData
    > ### Title: Get data from previous years of the Brazilian soccer
    > ###   championship
    > ### Aliases: previousData
    > 
    > ### ** Examples
    > 
    > previousData(2019)
    Warning: `fill` is now ignored and always happens
    Warning: `fill` is now ignored and always happens
    Error in type.convert.default(out[, i], as.is = TRUE, dec = dec, na.strings = na.strings) : 
      promise already under evaluation: recursive default argument reference or earlier problems?
    Calls: previousData ... lapply -> FUN -> <Anonymous> -> type.convert.default
    Execution halted
    ```

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 7 marked UTF-8 strings
    ```

