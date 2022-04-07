#' Checking events
#'
#' @description
#' This function checks the input \code{events}.
#'
#' @param events
#' A list of two elements.
#' The first element is named \code{"dates"} and contains characters in format
#' "YYYY-MM-DD".
#' The second element is named \code{"labels"} and is a character vector of the
#' same length as \code{"dates"}.
#'
#' @return
#' An object of class \code{fHMM_events}.
#'
#' @examples
#' events <- list(
#'   dates = c("2001-09-11", "2008-09-15", "2020-01-27"),
#'   labels = c(
#'     "9/11 terrorist attack", "Bankruptcy Lehman Brothers",
#'     "First COVID-19 case Germany"
#'   )
#' )
#' events <- fHMM_events(events)
#' 
#' @export

fHMM_events <- function(events) {
  if (inherits(events, "fHMM_events")) {
    warning("This element already is of class 'fHMM_events'.")
  } else {
    if (!inherits(events,"list")) {
      stop("'events' must be a list.")
    }
    if (length(events) != 2) {
      stop("'events' must be a list of two elements.")
    }
    if (!identical(names(events), c("dates", "labels"))) {
      stop("'events' must be a list containing the elements 'dates' and 'labels'.")
    }
    events$dates <- check_date(events$dates)
    class(events) <- "fHMM_events"
  }
  return(events)
}

#' Print method for \code{fHMM_events}.
#' @description
#' This function is the print method for an object of class \code{fHMM_events}.
#' @param x
#' An object of class \code{fHMM_events}.
#' @param ...
#' Ignored.
#' @return
#' Returns \code{x} invisibly.
#' @export
#' @noRd

print.fHMM_events <- function(x, ...) {
  print(data.frame("dates" = x$dates, "labels" = x$labels))
  return(invisible(x))
}