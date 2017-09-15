library(testthat)
library(rfars)

WD<-getwd()
setwd(system.file("data-raw",package="rfars"))

test_that("object classes are correct",{
    expect_is(fars_read("accident_2014.csv.bz2"),c("tbl_df","tbl","data.frame"))
    expect_is(fars_summarize_years(2014),c("tbl_df","tbl","data.frame"))
    expect_is(fars_read_years(2014),"list")
    expect_is(make_filename(2014),"character")
    expect_is(fars_map_state(1,2013),"NULL")
})

setwd(WD)
