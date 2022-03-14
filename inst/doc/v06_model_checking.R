## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.dim = c(10,6),
  out.width = "80%",
  fig.align = 'center'
)
library(fHMM)

## ----dax model----------------------------------------------------------------
data(dax_model_3t)

## ----res----------------------------------------------------------------------
dax_model_3t <- compute_residuals(dax_model_3t)

## ----plot res-----------------------------------------------------------------
plot(dax_model_3t, plot_type = "pr")

## -----------------------------------------------------------------------------
res <- dax_model_3t$residuals
tseries::jarque.bera.test(res)

