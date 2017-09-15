#'@title Load csv data into R in data frame tbl format
#'
#'@description  This function uses the read_csv function from the readr package to load a given
#'          .csv file into R, and then converts the imported data into the data frame tbl structure.
#'          If the file does not exist, the function will stop and return an error.
#'
#'@importFrom  readr read_csv
#'@importFrom  dplyr tbl_df
#'
#'@param filename a character string for the file name input of the .csv file
#'
#'@return this function either returns a data frame tbl of the .csv data, or an error,
#'        if a file for the given year does not exist
#'
#'@examples \dontrun{
#'fars_read(filename="accident_2013.csv.bz2")
#'fars_read("accident_2014.csv.bz2")
#'}
#'
#'@export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#'@title Print file name for given year
#'
#'@description This function outputs a specific .csv.bz2 file name based on a a given year. The
#'             The input can be in any format.
#'
#'@param year an integer or string of any format of a year value
#'
#'@return this function will return a string of a compressed .csv file name specific to the
#'        accidents recorded in the given year
#'
#'@examples \dontrun{
#'make_filename(year=2013)
#'make_filename(2014)
#'}
#'
#'@export
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#'@title Load and tidy all accident data for given years
#'
#'@description For each year input, this function first calls the make_filename function to generate
#'           the files name for the data on accidents in that year, then loads the generated filename
#'           into R using the fars_read function, and finally reduces the data to just month and
#'           years columns.  If a file with a given year does not exist, it will return an error.
#'
#'@importFrom magrittr %>%
#'@importFrom dplyr mutate
#'@importFrom dplyr select
#'
#'@param years the years to find files for to load data into R. can be a vector or a single year
#'
#'@return a list of data frame tbls, for given years, each with month and year columns, or an error,
#'        if a file for the given year does not exist.
#'
#'@examples \dontrun{
#'fars_read_years(years=c(2013,2014,2015))
#'fars_read_years(c(2013,2014,2015))
#'}
#'
#'@export
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#'@title Summarize the number of accidents per month in a table of years
#'
#'@description This function first calls the fars_read_years function to read in data from accident
#'           records for a given set of years.  It then compiles all of the data frame tbls it's
#'           read in into a single data frame table by binding all the rows.  It then creates a
#'           a summary count of accidents per month, per year, and spreads the data frame tbl into
#'           a data frame in the form of a table of months vs years.
#'
#'@importFrom magrittr %>%
#'@importFrom dplyr bind_rows
#'@importFrom dplyr group_by
#'@importFrom dplyr summarize
#'@importFrom dplyr n
#'@importFrom tidyr spread
#'
#'@param years the years to find files for to load data into R. can be a vector or a single year
#'
#'@return a data frame of accident counts by month, spread according to the years factor
#'
#'@examples \dontrun{
#'fars_summarize_years(years=c(2013,2014,2015))
#'fars_summarize_years(c(2013,2014,2015))
#'}
#'
#'@export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#'@title Vizualize traffic accidents happening in given states during specific years
#'
#'@description This function creates a graph of the traffic accidents that have happened
#'          during given years in given states, plotted by location over an outline of the state.
#'
#'@importFrom dplyr filter
#'@importFrom maps map
#'@importFrom graphics points
#'
#'@param state.num the code number of a state, which can be in any format, but should be singular
#'@param year a year in which to search for traffic accidents, which can be in any format, but
#'            should be singular
#'
#'@return a plot with the locations of accidents in a given state in a given year, mapped over the
#'        outline of the state. if a state number does not exist or if the given state has no
#'        accidents in that year, it returns an error message.
#'
#'@examples \dontrun{
#'fars_map_state(state.num=1,year=2013)
#'fars_map_state(1,2013)
#'}
#'
#'@export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
