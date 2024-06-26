% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_and_models.R
\docType{data}
\name{dax_vw_model}
\alias{dax_vw_model}
\title{DAX/VW hierarchical HMM with t-distributions}
\format{
An object of class \code{\link{fHMM_model}}.
}
\usage{
data("dax_vw_model")
}
\description{
A pre-computed HHMM with monthly averaged closing prices of the
DAX from 2010 to 2022 on the coarse scale, Volkswagen AG stock data on the
fine scale, two hidden fine-scale and coarse-scale states, respectively, and
state-dependent t-distributions for demonstration purpose.
}
\details{
The model was estimated via:
\preformatted{
controls <- set_controls(
  hierarchy = TRUE,
  states    = c(2, 2),
  sdds      = c("t", "t"),
  period    = "m",
  data      = list(
    file       = list(dax, vw),
    from       = "2010-01-01",
    to         = "2022-12-31",
    logreturns = c(TRUE, TRUE)
  ),
  fit       = list(
    runs       = 200, 
    iterlim    = 300,
    gradtol    = 1e-6,
    steptol    = 1e-6
  )
)
dax_vw_data <- prepare_data(controls)
dax_vw_model <- fit_model(dax_vw_data, seed = 1, ncluster = 10)
dax_vw_model <- decode_states(dax_vw_model)
dax_vw_model <- compute_residuals(dax_vw_model)
summary(dax_vw_model)
}
}
\keyword{model}
