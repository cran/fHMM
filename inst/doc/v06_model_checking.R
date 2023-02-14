## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.dim = c(10,6),
  out.width = "80%",
  fig.align = 'center',
  tidy = TRUE
)
library("fHMM")

## ----dax model----------------------------------------------------------------
data(dax_model_3t)

## ----res----------------------------------------------------------------------
dax_model_3t <- compute_residuals(dax_model_3t)

## ----plot res-----------------------------------------------------------------
plot(dax_model_3t, plot_type = "pr")

## ---- message=FALSE-----------------------------------------------------------
tseries::jarque.bera.test(residuals(dax_model_3t))

