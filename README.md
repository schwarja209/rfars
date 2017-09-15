rfars
=====

This is a package developed for the course "Building R Packages" on Coursera, as part of the Mastering Software Development in R specialization offered by Johns Hopkins University. It consists of a set of functions used to analyze and visualize the data from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System (FARS).

This R package is available on Github and can be installed by calling the following function in R:

devtools::install\_github("<https://github.com/schwarja209/rfars>")

Purpose
-------

The aim of this project was to combine the skills of creating, writing, and testing an R package, using the R files provided in the course Building R Packages offered by the Johns Hopkins University through the Coursera's platform.

For this assessment, it was required that we perform the following tasks:

-   Write a vignette to be included in the package using knitr and R Markdown;
-   Formulate at least one test using the testthat package;
-   Put the package on Github;
-   Set up the package's repository so that can be checked and built on Travis;
-   Add the Travis badge to the package's README.md file, as soon as your package has built on Travis and the build is passing without errors, warnings, or notes.

Example
-------

The functions in rfars can be used as follows (using raw test data in the "data-raw" folder):

``` r
fars_read(filename="accident_2013.csv.bz2")

make_filename(year=2013)

fars_read_years(years=c(2013,2014,2015))

fars_summarize_years(years=c(2013,2014,2015))

fars_map_state(state.num=1,year=2013)
```

Help files describing what each function does with the given inputs can be found in the "man" folder.

R Session
---------

The session in which I have created this package was the following:

    R version 3.4.1 (2017-06-30)
    Platform: x86_64-w64-mingw32/x64 (64-bit)
    Running under: Windows 10 x64 (build 15063)

    Matrix products: default

    locale:
    [1] LC_COLLATE=English_United States.1252 
    [2] LC_CTYPE=English_United States.1252   
    [3] LC_MONETARY=English_United States.1252
    [4] LC_NUMERIC=C                          
    [5] LC_TIME=English_United States.1252    

    attached base packages:
    [1] stats     graphics  grDevices utils     datasets  methods   base     

    loaded via a namespace (and not attached):
     [1] compiler_3.4.1  backports_1.1.0 magrittr_1.5    rprojroot_1.2  
     [5] tools_3.4.1     htmltools_0.3.6 yaml_2.1.14     Rcpp_0.12.12   
     [9] stringi_1.1.5   rmarkdown_1.6   knitr_1.17      stringr_1.2.0  
    [13] digest_0.6.12   evaluate_0.10.1
