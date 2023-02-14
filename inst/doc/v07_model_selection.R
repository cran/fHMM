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

## ----compare------------------------------------------------------------------
data(dax_model_2n)
data(dax_model_3t)
compare_models(dax_model_2n, dax_model_3t)

