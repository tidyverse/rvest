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
      
      [ FAIL 1 | WARN 28 | SKIP 0 | PASS 80 ]
      Error: Test failures
      Execution halted
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
# ralger

<details>

* Version: 2.2.1
* GitHub: https://github.com/feddelegrand7/ralger
* Source code: https://github.com/cran/ralger
* Date/Publication: 2021-01-10 14:10:02 UTC
* Number of recursive dependencies: 72

Run `cloud_details(, "ralger")` for more info

</details>

## Newly broken

*   checking whether package ‘ralger’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/tmp/workdir/ralger/new/ralger.Rcheck/00install.out’ for details.
    ```

## Newly fixed

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘testthat’
      All declared Imports should be used.
    ```

## Installation

### Devel

```
* installing *source* package ‘ralger’ ...
** package ‘ralger’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** inst
** byte-compile and prepare package for lazy loading
Error: object ‘pluck’ is not exported by 'namespace:rvest'
Execution halted
ERROR: lazy loading failed for package ‘ralger’
* removing ‘/tmp/workdir/ralger/new/ralger.Rcheck/ralger’


```
### CRAN

```
* installing *source* package ‘ralger’ ...
** package ‘ralger’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** inst
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
*** copying figures
** building package indices
** installing vignettes
** testing if installed package can be loaded from temporary location
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (ralger)


```
# rMorningStar

<details>

* Version: 1.0.6
* GitHub: NA
* Source code: https://github.com/cran/rMorningStar
* Date/Publication: 2020-06-26 09:20:02 UTC
* Number of recursive dependencies: 76

Run `cloud_details(, "rMorningStar")` for more info

</details>

## Newly broken

*   checking examples ... ERROR
    ```
    Running examples in ‘rMorningStar-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: ms.Top10Holding
    > ### Title: ms.Top10Holding
    > ### Aliases: ms.Top10Holding ms.Top10HoldingTotal
    > 
    > ### ** Examples
    > 
    > ms.Top10Holding('FXAIX')
    Error in parse_vector(x, col_number(), na = na, locale = locale, trim_ws = trim_ws) : 
      is.character(x) is not TRUE
    Calls: ms.Top10Holding -> parse_number -> parse_vector -> stopifnot
    Execution halted
    ```

# rUnemploymentData

<details>

* Version: 1.1.0
* GitHub: NA
* Source code: https://github.com/cran/rUnemploymentData
* Date/Publication: 2017-01-19 18:15:41
* Number of recursive dependencies: 120

Run `cloud_details(, "rUnemploymentData")` for more info

</details>

## Newly broken

*   checking whether package ‘rUnemploymentData’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/tmp/workdir/rUnemploymentData/new/rUnemploymentData.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘rUnemploymentData’ ...
** package ‘rUnemploymentData’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** data
** inst
** byte-compile and prepare package for lazy loading
Error: object ‘html’ is not exported by 'namespace:rvest'
Execution halted
ERROR: lazy loading failed for package ‘rUnemploymentData’
* removing ‘/tmp/workdir/rUnemploymentData/new/rUnemploymentData.Rcheck/rUnemploymentData’


```
### CRAN

```
* installing *source* package ‘rUnemploymentData’ ...
** package ‘rUnemploymentData’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** data
** inst
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded from temporary location
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (rUnemploymentData)


```
