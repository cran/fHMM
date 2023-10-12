## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "fHMM-"
)

## ----load fHMM, message = FALSE-----------------------------------------------
library("fHMM")

## -----------------------------------------------------------------------------
download_data(symbol = "^GDAXI", file = "dax.csv")

## ----set controls emp hmm-----------------------------------------------------
controls <- list(
  states = 3,
  sdds   = "t",
  data   = list(file        = "dax.csv",
                date_column = "Date",
                data_column = "Close",
                logreturns  = TRUE),
  fit    = list(runs        = 50)
)
set_controls(controls)

## ----set controls sim hmm-----------------------------------------------------
controls <- list(
  states  = 2,
  sdds    = "gamma(mu = 0.5|2)",
  horizon = 500
)
set_controls(controls)

## ----set controls hhmm--------------------------------------------------------
controls <- list(
  hierarchy = TRUE,
  horizon   = c(100, 10),
  sdds      = c("t(df = 1)", "t(df = Inf)"),
  period    = "m"
)
set_controls(controls)

