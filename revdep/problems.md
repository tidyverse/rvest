# finreportr

<details>

* Version: 1.0.2
* GitHub: https://github.com/sewardlee337/finreportr
* Source code: https://github.com/cran/finreportr
* Date/Publication: 2020-06-13 06:10:02 UTC
* Number of recursive dependencies: 60

Run `cloud_details(, "finreportr")` for more info

</details>

## Newly broken

*   checking tests ... ERROR
    ```
      Running ‘testthat.R’
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
        9.     ├─xml2::read_xml(x, encoding = encoding, ..., as_html = TRUE, options = options)
       10.     └─xml2:::read_xml.character(...)
       11.       └─xml2:::read_xml.connection(...)
       12.         ├─base::open(x, "rb")
       13.         └─base::open.connection(x, "rb")
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      ERROR (test.R:7:6): CompanyInfo returning correct dimensions
      
      [ FAIL 1 | WARN 0 | SKIP 0 | PASS 1 ]
      Error: Test failures
      In addition: Warning message:
      In for (i in seq_len(n)) { :
        closing unused connection 4 (https://www.sec.gov/cgi-bin/browse-edgar?CIK=TSLA&owner=exclude&action=getcompany&Find=Search)
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
