basic_cleaning <- function(avia_raw){

  avia_raw |>
    select(contains("TIME"), contains("20")) |>
    pivot_longer(cols = contains("20"),
                 names_to = "date",
                 values_to = "passengers") |>
    separate(col = `freq,unit,tra_meas,airp_pr\\TIME_PERIOD`,
             into = c("freq", "unit", "tra_meas", "air_pr\\time"), sep = ",")

}


recodings <- function(basic_cleaning_avia){
  basic_cleaning_avia %>%  
    mutate(tra_meas = fct_recode(tra_meas,
             `Passengers on board` = "PAS_BRD",
             `Passengers on board (arrivals)` = "PAS_BRD_ARR",
             `Passengers on board (departures)` = "PAS_BRD_DEP",
             `Passengers carried` = "PAS_CRD",
             `Passengers carried (arrival)` = "PAS_CRD_ARR",
             `Passengers carried (departures)` = "PAS_CRD_DEP",
             `Passengers seats available` = "ST_PAS",
             `Passengers seats available (arrivals)` = "ST_PAS_ARR",
             `Passengers seats available (departures)` = "ST_PAS_DEP",
             `Commercial passenger air flights` = "CAF_PAS",
             `Commercial passenger air flights (arrivals)` = "CAF_PAS_ARR",
             `Commercial passenger air flights (departures)` = "CAF_PAS_DEP")) %>%

    mutate(unit = fct_recode(unit,
             Passenger = "PAS",
             Flight = "FLIGHT",
             `Seats and berths` = "SEAT")) %>%

    mutate(destination = fct_recode(`air_pr\\time`,
             `WIEN-SCHWECHAT` = "LU_ELLX_AT_LOWW",
             `BRUSSELS` = "LU_ELLX_BE_EBBR",
             `GENEVA` = "LU_ELLX_CH_LSGG",
             `ZURICH` = "LU_ELLX_CH_LSZH",
             `FRANKFURT/MAIN` = "LU_ELLX_DE_EDDF",
             `HAMBURG` = "LU_ELLX_DE_EDDH",
             `BERLIN-TEMPELHOF` = "LU_ELLX_DE_EDDI",
             `MUENCHEN` = "LU_ELLX_DE_EDDM",
             `SAARBRUECKEN` = "LU_ELLX_DE_EDDR",
             `BERLIN-TEGEL` = "LU_ELLX_DE_EDDT",
             `KOBENHAVN/KASTRUP` = "LU_ELLX_DK_EKCH",
             `HURGHADA / INTL` = "LU_ELLX_EG_HEGN",
             `IRAKLION/NIKOS KAZANTZAKIS` = "LU_ELLX_EL_LGIR",
             `FUERTEVENTURA` = "LU_ELLX_ES_GCFV",
             `GRAN CANARIA` = "LU_ELLX_ES_GCLP",
             `LANZAROTE` = "LU_ELLX_ES_GCRR",
             `TENERIFE SUR/REINA SOFIA` = "LU_ELLX_ES_GCTS",
             `BARCELONA/EL PRAT` = "LU_ELLX_ES_LEBL",
             `ADOLFO SUAREZ MADRID-BARAJAS` = "LU_ELLX_ES_LEMD",
             `MALAGA/COSTA DEL SOL` = "LU_ELLX_ES_LEMG",
             `PALMA DE MALLORCA` = "LU_ELLX_ES_LEPA",
             `SYSTEM - PARIS` = "LU_ELLX_FR_LF90",
             `NICE-COTE D'AZUR` = "LU_ELLX_FR_LFMN",
             `PARIS-CHARLES DE GAULLE` = "LU_ELLX_FR_LFPG",
             `STRASBOURG-ENTZHEIM` = "LU_ELLX_FR_LFST",
             `KEFLAVIK` = "LU_ELLX_IS_BIKF",
             `MILANO/MALPENSA` = "LU_ELLX_IT_LIMC",
             `BERGAMO/ORIO AL SERIO` = "LU_ELLX_IT_LIME",
             `ROMA/FIUMICINO` = "LU_ELLX_IT_LIRF",
             `AGADIR/AL MASSIRA` = "LU_ELLX_MA_GMAD",
             `AMSTERDAM/SCHIPHOL` = "LU_ELLX_NL_EHAM",
             `WARSZAWA/CHOPINA` = "LU_ELLX_PL_EPWA",
             `PORTO` = "LU_ELLX_PT_LPPR",
             `LISBOA` = "LU_ELLX_PT_LPPT",
             `STOCKHOLM/ARLANDA` = "LU_ELLX_SE_ESSA",
             `MONASTIR/HABIB BOURGUIBA` = "LU_ELLX_TN_DTMB",
             `ENFIDHA-HAMMAMET INTERNATIONAL` = "LU_ELLX_TN_DTNH",
             `ENFIDHA ZINE EL ABIDINE BEN ALI` = "LU_ELLX_TN_DTNZ",
             `DJERBA/ZARZIS` = "LU_ELLX_TN_DTTJ",
             `ANTALYA (MIL-CIV)` = "LU_ELLX_TR_LTAI",
             `ISTANBUL/ATATURK` = "LU_ELLX_TR_LTBA",
             `SYSTEM - LONDON` = "LU_ELLX_UK_EG90",
             `MANCHESTER` = "LU_ELLX_UK_EGCC",
             `LONDON GATWICK` = "LU_ELLX_UK_EGKK",
             `LONDON/CITY` = "LU_ELLX_UK_EGLC",
             `LONDON HEATHROW` = "LU_ELLX_UK_EGLL",
             `LONDON STANSTED` = "LU_ELLX_UK_EGSS",
             `NEWARK LIBERTY INTERNATIONAL, NJ.` = "LU_ELLX_US_KEWR",
             `O.R TAMBO INTERNATIONAL` = "LU_ELLX_ZA_FAJS")) %>%
  mutate(passengers = as.numeric(passengers)) %>%
  select(unit, tra_meas, destination, date, passengers)
}

make_quarterly <- function(avia){
  avia %>%  
   filter(grepl("Q", date)) %>%
    mutate(date = yq(date))
}

make_monthly <- function(avia){
  avia %>%  
   filter(grepl(".*-(0|1)", date)) %>%
   mutate(date = paste0(date, "-01")) %>%
   mutate(date = ymd(date)) %>%
   select(destination, date, passengers)
}

make_monthly_plot <- function(avia_monthly){
  avia_monthly %>%
    group_by(date) %>%
    summarise(total = sum(passengers)) %>%
    ggplot() +
    ggtitle("Raw data") +
    geom_line(aes(y = total, x = date), colour = "#82518c") +
    scale_x_date(date_breaks = "1 year", date_labels = "%m-%Y")
}
