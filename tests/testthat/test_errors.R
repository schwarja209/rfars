library(testthat)
library(rfars)

test_that("object classes are correct",{
    expect_error(fars_read("accident_2014.csv.bz2"),"file 'accident_2014.csv.bz2' does not exist")
    expect_warning(fars_read_years(2014),"invalid year: 2014")
    expect_error(fars_map_state(1,2014),"file 'accident_2014.csv.bz2' does not exist")
})
