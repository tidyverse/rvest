# aire.zmvm

Version: 0.8.1

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 52 marked UTF-8 strings
    ```

# AMR

Version: 0.6.1

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  6.5Mb
      sub-directories of 1Mb or more:
        R      2.1Mb
        data   2.9Mb
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘microbenchmark’
      All declared Imports should be used.
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 7 marked UTF-8 strings
    ```

# BANEScarparkinglite

Version: 0.1.2

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘zoo’
      All declared Imports should be used.
    ```

# banxicoR

Version: 0.9.0

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 148 marked UTF-8 strings
    ```

# BiocPkgTools

Version: 1.0.3

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘gh’
      All declared Imports should be used.
    ```

*   checking R code for possible problems ... NOTE
    ```
    ...
    process_data: no visible binding for global variable ‘biocViews’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/BiocPkgTools/new/BiocPkgTools.Rcheck/00_pkg_src/BiocPkgTools/R/getData.R:51-70)
    process_data: no visible binding for global variable ‘Description’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/BiocPkgTools/new/BiocPkgTools.Rcheck/00_pkg_src/BiocPkgTools/R/getData.R:51-70)
    process_data: no visible binding for global variable ‘downloads_month’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/BiocPkgTools/new/BiocPkgTools.Rcheck/00_pkg_src/BiocPkgTools/R/getData.R:51-70)
    process_data: no visible binding for global variable ‘downloads_total’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/BiocPkgTools/new/BiocPkgTools.Rcheck/00_pkg_src/BiocPkgTools/R/getData.R:51-70)
    summarise_dl_stats: no visible binding for global variable ‘Package’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/BiocPkgTools/new/BiocPkgTools.Rcheck/00_pkg_src/BiocPkgTools/R/getData.R:79-84)
    summarise_dl_stats: no visible binding for global variable
      ‘Nb_of_downloads’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/BiocPkgTools/new/BiocPkgTools.Rcheck/00_pkg_src/BiocPkgTools/R/getData.R:79-84)
    Undefined global functions or variables:
      Author Description License Nb_of_downloads Package V<- any_alnums
      any_alphas any_blanks any_non_alnums any_of anything biocViews blank
      capture digit downloads_month downloads_total except_any_of gh maybe
      start tags
    Consider adding
      importFrom("stats", "start")
    to your NAMESPACE file.
    ```

# BioInstaller

Version: 0.3.7

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 11.2Mb
      sub-directories of 1Mb or more:
        doc       2.5Mb
        extdata   8.1Mb
    ```

# BIOMASS

Version: 2.1

## In both

*   R CMD check timed out
    

# ctrdata

Version: 0.17.0

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
             return(imported)
         })(queryterm = "2010-024264-18", register = "CTGOV", euctrresults = FALSE, annotation.text = "", 
             annotation.mode = "append", details = TRUE, parallelretrievals = 10, debug = FALSE, collection = "ThisNameSpaceShouldNotExistAnywhereInAMongoDB", 
             uri = "mongodb+srv://7RBnH3BF@cluster0-b9wpw.mongodb.net/dbtemp", password = "", verbose = FALSE, 
             queryupdateterm = "")
      7: ctrMongo(collection = collection, uri = uri, password = password, verbose = FALSE) at /Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/ctrdata/new/ctrdata.Rcheck/00_pkg_src/ctrdata/R/main.R:679
      8: mongolite::mongo(collection = collection, url = uri, verbose = verbose) at /Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/ctrdata/new/ctrdata.Rcheck/00_pkg_src/ctrdata/R/utils.R:96
      9: mongo_collection_command_simple(col, "{\"ping\":1}")
      
      ══ testthat results  ══════════════════════════════════════════════════════════════════════
      OK: 15 SKIPPED: 9 FAILED: 1
      1. Error: remote mongo access (@testfunctions.R#115) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

# datasus

Version: 0.4.1

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘RCurl’
      All declared Imports should be used.
    ```

# EdSurvey

Version: 2.2.3

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  5.8Mb
      sub-directories of 1Mb or more:
        R   4.1Mb
    ```

# ELMER

Version: 2.6.2

## In both

*   checking whether package ‘ELMER’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/ELMER/new/ELMER.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘ELMER’ ...
** R
** inst
** byte-compile and prepare package for lazy loading
Error in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]) : 
  there is no package called 'sesameData'
ERROR: lazy loading failed for package 'ELMER'
* removing '/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/ELMER/new/ELMER.Rcheck/ELMER'

```
### CRAN

```
* installing *source* package ‘ELMER’ ...
** R
** inst
** byte-compile and prepare package for lazy loading
Error in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]) : 
  there is no package called 'sesameData'
ERROR: lazy loading failed for package 'ELMER'
* removing '/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/ELMER/old/ELMER.Rcheck/ELMER'

```
# eurostat

Version: 3.3.1.3

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 595 marked UTF-8 strings
    ```

# ezpickr

Version: 1.0.4

## In both

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘BrailleR’
    ```

# fedregs

Version: 0.1.1

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘rvest’ ‘stringi’
      All declared Imports should be used.
    ```

# gfer

Version: 0.1.10

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘tidyr’
      All declared Imports should be used.
    ```

# helminthR

Version: 1.0.7

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘knitr’ ‘rmarkdown’
      All declared Imports should be used.
    ```

# ICD10gm

Version: 1.0.3

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  7.9Mb
      sub-directories of 1Mb or more:
        data   7.0Mb
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 252748 marked UTF-8 strings
    ```

# iemiscdata

Version: 0.6.1

## In both

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘ie2miscdata’
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 1 marked UTF-8 string
    ```

# incadata

Version: 0.6.4

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 568 marked UTF-8 strings
    ```

# jpndistrict

Version: 0.3.2

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 502 marked UTF-8 strings
    ```

# KDViz

Version: 1.3.1

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 11 marked UTF-8 strings
    ```

# newsanchor

Version: 0.1.0

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘devtools’ ‘xml2’
      All declared Imports should be used.
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 318 marked UTF-8 strings
    ```

# petro.One

Version: 0.2.3

## In both

*   checking whether package ‘petro.One’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/petro.One/new/petro.One.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘petro.One’ ...
** package ‘petro.One’ successfully unpacked and MD5 sums checked
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
Error : .onLoad failed in loadNamespace() for 'rJava', details:
  call: dyn.load(file, DLLpath = DLLpath, ...)
  error: unable to load shared object '/Users/hadley/Documents/tidyverse/rvest/revdep/library.noindex/petro.One/rJava/libs/rJava.so':
  dlopen(/Users/hadley/Documents/tidyverse/rvest/revdep/library.noindex/petro.One/rJava/libs/rJava.so, 6): Library not loaded: /Library/Java/JavaVirtualMachines/jdk-11.0.1.jdk/Contents/Home/lib/server/libjvm.dylib
  Referenced from: /Users/hadley/Documents/tidyverse/rvest/revdep/library.noindex/petro.One/rJava/libs/rJava.so
  Reason: image not found
ERROR: lazy loading failed for package ‘petro.One’
* removing ‘/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/petro.One/new/petro.One.Rcheck/petro.One’

```
### CRAN

```
* installing *source* package ‘petro.One’ ...
** package ‘petro.One’ successfully unpacked and MD5 sums checked
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
Error : .onLoad failed in loadNamespace() for 'rJava', details:
  call: dyn.load(file, DLLpath = DLLpath, ...)
  error: unable to load shared object '/Users/hadley/Documents/tidyverse/rvest/revdep/library.noindex/petro.One/rJava/libs/rJava.so':
  dlopen(/Users/hadley/Documents/tidyverse/rvest/revdep/library.noindex/petro.One/rJava/libs/rJava.so, 6): Library not loaded: /Library/Java/JavaVirtualMachines/jdk-11.0.1.jdk/Contents/Home/lib/server/libjvm.dylib
  Referenced from: /Users/hadley/Documents/tidyverse/rvest/revdep/library.noindex/petro.One/rJava/libs/rJava.so
  Reason: image not found
ERROR: lazy loading failed for package ‘petro.One’
* removing ‘/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/petro.One/old/petro.One.Rcheck/petro.One’

```
# prisonbrief

Version: 0.1.0

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 2 marked UTF-8 strings
    ```

# radtools

Version: 1.0.4

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      ==================================================
      downloaded 271 KB
      
      trying URL 'https://nifti.nimh.nih.gov/nifti-1/data//avg152T1_LR_nifti.hdr.gz'
      Error in download.file(paste(url_nimh, name_gz, sep = "/"), gz) : 
        cannot open URL 'https://nifti.nimh.nih.gov/nifti-1/data//avg152T1_LR_nifti.hdr.gz'
      Calls: test_check ... FUN -> eval -> eval -> download_nimh -> download.file
      In addition: Warning messages:
      1: In dir.create(outdir_dicom, recursive = TRUE) :
        '/private/tmp/RtmpCP7MmJ' already exists
      2: In dir.create(outdir_nifti, recursive = TRUE) :
        '/tmp/RtmpCP7MmJ' already exists
      3: In download.file(paste(url_nimh, name_gz, sep = "/"), gz) :
        cannot open URL 'https://nifti.nimh.nih.gov/nifti-1/data//avg152T1_LR_nifti.hdr.gz': HTTP status was '502 Bad Gateway'
      Execution halted
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘R.utils’ ‘TCIApathfinder’ ‘xfun’
      All declared Imports should be used.
    ```

# raustats

Version: 0.1.0

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 12 marked UTF-8 strings
    ```

# rccmisc

Version: 0.3.7

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘dplyr’
      All declared Imports should be used.
    ```

# rmd

Version: 0.1.4

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘blogdown’ ‘bookdown’ ‘bookdownplus’ ‘citr’ ‘pagedown’ ‘rticles’
      ‘tinytex’ ‘xaringan’
      All declared Imports should be used.
    ```

# RTCGA

Version: 1.12.1

## In both

*   checking examples ... ERROR
    ```
    Running examples in ‘RTCGA-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: boxplotTCGA
    > ### Title: Create Boxplots for TCGA Datasets
    > ### Aliases: boxplotTCGA
    > 
    > ### ** Examples
    > 
    > library(RTCGA.rnaseq)
    Error in library(RTCGA.rnaseq) : 
      there is no package called ‘RTCGA.rnaseq’
    Execution halted
    ```

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Complete output:
      > library(testthat)
      > library(RTCGA)
      Welcome to the RTCGA (version: 1.12.1).
      > library(RTCGA.rnaseq)
      Error in library(RTCGA.rnaseq) : 
        there is no package called 'RTCGA.rnaseq'
      Execution halted
    ```

*   checking package dependencies ... NOTE
    ```
    Packages suggested but not available for checking:
      ‘RTCGA.rnaseq’ ‘RTCGA.clinical’ ‘RTCGA.mutations’ ‘RTCGA.RPPA’
      ‘RTCGA.mRNA’ ‘RTCGA.miRNASeq’ ‘RTCGA.methylation’ ‘RTCGA.CNV’
      ‘RTCGA.PANCAN12’
    ```

*   checking R code for possible problems ... NOTE
    ```
    ...
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/RTCGA/new/RTCGA.Rcheck/00_pkg_src/RTCGA/R/ggbiplot.R:157-161)
    ggbiplot: no visible binding for global variable ‘xvar’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/RTCGA/new/RTCGA.Rcheck/00_pkg_src/RTCGA/R/ggbiplot.R:157-161)
    ggbiplot: no visible binding for global variable ‘yvar’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/RTCGA/new/RTCGA.Rcheck/00_pkg_src/RTCGA/R/ggbiplot.R:157-161)
    ggbiplot: no visible binding for global variable ‘angle’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/RTCGA/new/RTCGA.Rcheck/00_pkg_src/RTCGA/R/ggbiplot.R:157-161)
    ggbiplot: no visible binding for global variable ‘hjust’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/RTCGA/new/RTCGA.Rcheck/00_pkg_src/RTCGA/R/ggbiplot.R:157-161)
    read.mutations: no visible binding for global variable ‘.’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/RTCGA/new/RTCGA.Rcheck/00_pkg_src/RTCGA/R/readTCGA.R:383)
    read.mutations: no visible binding for global variable ‘.’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/RTCGA/new/RTCGA.Rcheck/00_pkg_src/RTCGA/R/readTCGA.R:386)
    read.rnaseq: no visible binding for global variable ‘.’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/RTCGA/new/RTCGA.Rcheck/00_pkg_src/RTCGA/R/readTCGA.R:372-375)
    survivalTCGA: no visible binding for global variable ‘times’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/RTCGA/new/RTCGA.Rcheck/00_pkg_src/RTCGA/R/survivalTCGA.R:101-137)
    whichDateToUse: no visible binding for global variable ‘.’
      (/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/RTCGA/new/RTCGA.Rcheck/00_pkg_src/RTCGA/R/downloadTCGA.R:167-168)
    Undefined global functions or variables:
      . angle hjust muted times varname xvar yvar
    ```

*   checking Rd cross-references ... NOTE
    ```
    Packages unavailable to check Rd xrefs: ‘RTCGA.rnaseq’, ‘RTCGA.clinical’, ‘RTCGA.mutations’, ‘RTCGA.CNV’, ‘RTCGA.RPPA’, ‘RTCGA.mRNA’, ‘RTCGA.miRNASeq’, ‘RTCGA.methylation’
    ```

# rtrek

Version: 0.2.0

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘memoise’ ‘tidyr’
      All declared Imports should be used.
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 988 marked UTF-8 strings
    ```

# rzeit2

Version: 0.2.3

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 841 marked UTF-8 strings
    ```

# SanFranBeachWater

Version: 0.1.0

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘tibble’
      All declared Imports should be used.
    ```

# sejmRP

Version: 1.3.4

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘cluster’ ‘factoextra’ ‘tidyr’
      All declared Imports should be used.
    ```

# sidrar

Version: 0.2.4

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘dplyr’
      All declared Imports should be used.
    ```

# stlcsb

Version: 0.1.2

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘tibble’
      All declared Imports should be used.
    ```

# TCGAbiolinks

Version: 2.10.5

## In both

*   checking whether package ‘TCGAbiolinks’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/TCGAbiolinks/new/TCGAbiolinks.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘TCGAbiolinks’ ...
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
Error in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]) : 
  there is no package called ‘sesameData’
ERROR: lazy loading failed for package ‘TCGAbiolinks’
* removing ‘/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/TCGAbiolinks/new/TCGAbiolinks.Rcheck/TCGAbiolinks’

```
### CRAN

```
* installing *source* package ‘TCGAbiolinks’ ...
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
Error in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]) : 
  there is no package called ‘sesameData’
ERROR: lazy loading failed for package ‘TCGAbiolinks’
* removing ‘/Users/hadley/Documents/tidyverse/rvest/revdep/checks.noindex/TCGAbiolinks/old/TCGAbiolinks.Rcheck/TCGAbiolinks’

```
# TCGAbiolinksGUI

Version: 1.8.1

## In both

*   checking package dependencies ... ERROR
    ```
    Package required but not available: ‘sesameData’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
    ```

# TCGAutils

Version: 1.2.2

## In both

*   checking examples ... ERROR
    ```
    Running examples in ‘TCGAutils-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: imputeAssay
    > ### Title: This function imputes assays values inside a
    > ###   'MultiAssayExperiment'
    > ### Aliases: imputeAssay
    > 
    > ### ** Examples
    > 
    > library(curatedTCGAData)
    Error in library(curatedTCGAData) : 
      there is no package called ‘curatedTCGAData’
    Execution halted
    ```

*   checking re-building of vignette outputs ... WARNING
    ```
    Error in re-building vignettes:
      ...
    Quitting from lines 16-22 (TCGAutils.Rmd) 
    Error: processing vignette 'TCGAutils.Rmd' failed with diagnostics:
    there is no package called 'curatedTCGAData'
    Execution halted
    ```

*   checking package dependencies ... NOTE
    ```
    Packages suggested but not available for checking:
      ‘curatedTCGAData’ ‘org.Hs.eg.db’
    ```

*   checking dependencies in R code ... NOTE
    ```
    Unexported objects imported by ':::' calls:
      ‘BiocGenerics:::replaceSlots’ ‘GenomicRanges:::.normarg_field’
      See the note in ?`:::` about the use of this operator.
    ```

# textreadr

Version: 0.9.0

## In both

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘tm’
    ```

# tidyverse

Version: 1.2.1

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘dbplyr’ ‘reprex’ ‘rlang’
      All declared Imports should be used.
    ```

# unpivotr

Version: 0.5.0

## In both

*   checking examples ... ERROR
    ```
    ...
    Levels: c < d
    
    > 
    > # HTML tables can be extracted from the output of xml2::read_html().  These
    > # are returned as a list of tables, similar to rvest::html_table().  The
    > # value of each cell is its standalone HTML string, which can contain
    > # anything -- even another table.
    > 
    > colspan <- system.file("extdata", "colspan.html", package = "unpivotr")
    > rowspan <- system.file("extdata", "rowspan.html", package = "unpivotr")
    > nested <- system.file("extdata", "nested.html", package = "unpivotr")
    > 
    > ## Not run: 
    > ##D browseURL(colspan)
    > ##D browseURL(rowspan)
    > ##D browseURL(nestedspan)
    > ## End(Not run)
    > 
    > as_cells(xml2::read_html(colspan))
    Error: Columns 1, 2 must not have names of the form ... or ..j.
    Execution halted
    ```

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      19: set_names(x, repaired_names(names(x), .name_repair = .name_repair))
      20: set_names_impl(x, x, nm, ...)
      21: is_function(nm)
      22: is_closure(x)
      23: repaired_names(names(x), .name_repair = .name_repair)
      24: check_unique(new_name)
      25: abort(error_column_must_not_be_dot_dot(dot_dot_name))
      
      ══ testthat results  ══════════════════════════════════════════════════════════════════════
      OK: 246 SKIPPED: 0 FAILED: 2
      1. Error: as_cells() works with html tables (@test-as_cells.R#45) 
      2. Error: tidy_table works with html tables (@test-tidy_table.R#45) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

*   checking re-building of vignette outputs ... WARNING
    ```
    Error in re-building vignettes:
      ...
    Quitting from lines 37-49 (html.Rmd) 
    Error: processing vignette 'html.Rmd' failed with diagnostics:
    Columns 1, 2 must not have names of the form ... or ..j.
    Execution halted
    ```

# waccR

Version: 0.1.0

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘lubridate’ ‘tibble’
      All declared Imports should be used.
    ```

# wikilake

Version: 0.4

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 2 marked UTF-8 strings
    ```

# ztype

Version: 0.1.0

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘dplyr’ ‘ggplot2’ ‘lubridate’
      All declared Imports should be used.
    ```

