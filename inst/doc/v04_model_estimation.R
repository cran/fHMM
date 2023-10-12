## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.dim = c(10,6),
  out.width = "80%",
  fig.align = 'center',
  fig.path = "fHMM-"
)
library("fHMM")

## ----data preparation---------------------------------------------------------
controls <- list(
  states = 3,
  sdds   = "t",
  data   = list(file        = system.file("extdata", "dax.csv", package = "fHMM"),
                date_column = "Date",
                data_column = "Close",
                from        = "2000-01-01",
                to          = "2021-12-31",
                logreturns  = TRUE),
  fit    = list("runs" = 100)
)
controls <- set_controls(controls)
data <- prepare_data(controls)

## ----fit, eval=FALSE----------------------------------------------------------
#  dax_model_3t <- fit_model(data, seed = 1, verbose = FALSE)

## ----access model-------------------------------------------------------------
data(dax_model_3t)

## ----summarize model----------------------------------------------------------
summary(dax_model_3t)

## ----plot-sdds----------------------------------------------------------------
plot(dax_model_3t, plot_type = "sdds")

## ----plot-lls-----------------------------------------------------------------
plot(dax_model_3t, plot_type = "ll")

