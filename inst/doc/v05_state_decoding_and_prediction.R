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

## ----dax model----------------------------------------------------------------
data(dax_model_3t)

## ----decode states------------------------------------------------------------
dax_model_3t <- decode_states(dax_model_3t)

## ----decoded-ts---------------------------------------------------------------
plot(dax_model_3t)

## ----reorder------------------------------------------------------------------
dax_model_3t <- reorder_states(dax_model_3t, 3:1)

## ----predict------------------------------------------------------------------
predict(dax_model_3t, ahead = 10)

