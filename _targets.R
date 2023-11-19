library(targets)
library(tarchetypes)
library(readr)

tar_option_set(packages = c("chronicler",
                            "dplyr",
                            "forcats",
                            "ggplot2",
                            "lubridate",
                            "tidyr")
                            )

source("functions/functions.R")
source("functions/record_functions.R")

list(
  tar_target(
    avia_raw,
    as_chronicle(read_tsv("avia.tsv"))
  ),

  tar_target(
    basic_cleaning_avia,
    basic_cleaning(avia_raw)
  ),

  tar_target(
    recoded_avia,
    recodings(basic_cleaning_avia)
  ),

  tar_target(
    avia_arrivals,
    bind_record(recoded_avia,
                r_filter,
                tra_meas == "Passengers on board (arrivals)",
                !is.na(passengers)
           )
    ),

  tar_target(
    avia_monthly,
    make_monthly(avia_arrivals)
  ),

  tar_target(
    avia_quarterly,
    make_quarterly(avia_arrivals)
  ),

  tar_target(
    avia_monthly_plot,
    make_monthly_plot(avia_monthly)
  ),

  tar_render(
    analyse_data,
    "analyse_data.Rmd"
  )

)
