## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.dim = c(10,6),
  out.width = "80%",
  fig.align = 'center',
  fig.path = "fHMM-"
)

## ----load fHMM, message = FALSE-----------------------------------------------
library("fHMM")

## ----head dax, results = FALSE------------------------------------------------
system.file("extdata", "dax.csv", package = "fHMM")
system.file("extdata", "vw.csv", package = "fHMM")

## ----prepare_data example-----------------------------------------------------
controls <- list(
  states = 3,
  sdds   = "t",
  data   = list(file        = system.file("extdata", "dax.csv", package = "fHMM"),
                date_column = "Date",
                data_column = "Close",
                logreturns  = TRUE)
)
controls <- set_controls(controls)
data <- prepare_data(controls)
summary(data)

## ----eval = FALSE-------------------------------------------------------------
#  download_data(symbol, from, to, file)

## -----------------------------------------------------------------------------
dax <- download_data(symbol = "^GDAXI", from = "2000-01-01", to = Sys.Date())
head(dax)

## ----events-------------------------------------------------------------------
events <- fHMM:::fHMM_events(
  list(
    dates = c("2001-09-11","2008-09-15","2020-01-27"),
    labels = c("9/11 terrorist attack","Bankruptcy of Lehman Brothers","First COVID-19 case in Germany")
    )
  )
print(events)
plot(data, events = events)

