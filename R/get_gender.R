#' Predicts gender from Brazilian first names using IBGE API
#'
#' \code{get_gender} consults...
#'
#' @param name A string specifying a person's first name. The name can also be passed to the function
#' as a full name (e.g., Ana Maria de Souza). \code{get_gender} is case insensitive.
#' @param state A string with the state of federation abbreviation (e.g., \code{RJ} for Rio de Janeiro).
#' @param prob Report the result as the probability of a given name be from a female person?
#' Defaults to \code{FALSE}.
#' @param threshold Numeric indicating the threshold used in predictions. Defaults to 0.9.
#'
#' @return \code{get_gender} returns three values only: \code{Female}, if the name provided is from a female person;
#' \code{Male}, if the name provided is from a male person; \code{NA}, if the probability of the name
#' provided be from a female or male person can not be infered given the chosen threshold.
#'
#'
#' @import dplyr
#' @import httr
#' @export


get_gender <- function(name, state = NULL, prob = FALSE, threshold = 0.9){


  # API endpoint
  ibge <- "http://servicodados.ibge.gov.br/api/v1/censos/nomes/basica"

  # GET
  females <- httr::GET(ibge, query = list(nome = name, regiao = state, sexo = "f"))
  total <- httr::GET(ibge, query = list(nome = name, regiao = state))

  # Test responses
  if(test_responses(females, total)) return(NA)

  # Parse freq
  total <- httr::content(total, as = "parsed")[[1]]$freq
  females <- httr::content(females, as = "parsed")[[1]]$freq

  # Return
  fprob <- females / total
  if(prob) return(fprob)
  round_guess(fprob, threshold)
}
