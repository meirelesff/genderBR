#' State's abbreviations
#'
#' Use this function to get a \code{data.frame} with the full names, abbreviations
#' (acronym), and IBGE codes of all Brazilian states.
#'
#' @return A \code{tbl_df, tbl, data.frame} with two variables: \code{state}, \code{abb}, and \code{code}.
#' @export

br_states <- function(){

  dplyr::tibble(state = c("ACRE", "ALAGOAS", "AMAPA", "AMAZONAS", "BAHIA", "CEARA", "DISTRITO FEDERAL",
                       "ESPIRITO SANTO", "GOIAS", "MARANHAO", "MATO GROSSO DO SUL", "MATO GROSSO",
                       "MINAS GERAIS", "PARA", "PARAIBA", "PARANA", "PERNAMBUCO", "PIAUI",
                       "RIO DE JANEIRO", "RIO GRANDE DO NORTE", "RIO GRANDE DO SUL", "RONDONIA",
                       "RORAIMA", "SANTA CATARINA", "SAO PAULO", "SERGIPE", "TOCANTINS"),
             abb = c("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA",
                     "MS", "MT", "MG", "PA", "PA", "PR","PE", "PI", "RJ", "RN",
                     "RS", "RO", "RR", "SC", "SP", "SE", "TO"),
             code = c(12L, 27L, 16L, 13L, 29L, 23L, 53L, 32L, 52L, 21L, 51L, 50L,
                      31L, 15L, 25L, 41L, 26L, 22L, 33L, 24L, 43L, 11L, 14L, 42L, 35L,
                      28L, 17L))
}


# Internal function to test void names
test_responses <- function(response1, response2, prob){

  httr::stop_for_status(response1)
  httr::stop_for_status(response2)

  if(length(response1$content) == 2 & length(response2$content) == 2) return(NA)
  if(length(response1$content) == 2 & length(response2$content) > 2 & prob == TRUE) return(0)
  if(length(response1$content) > 2 & length(response2$content) == 2 & prob == TRUE) return(1)
  if(length(response1$content) == 2 & length(response2$content) > 2 & prob == FALSE) return("Male")
  if(length(response1$content) > 2 & length(response2$content) == 2 & prob == FALSE) return("Female")

  NULL
}


# Internal function to round numeric guess
round_guess <- function(prob, threshold){

  if(threshold < 0 | threshold > 1) stop("Threshold must be between 0 and 1.")

  if(prob > threshold) return("Female")
  else if(prob < 1 - threshold) return("Male")
  else return(as.character(NA))
}


# Internal function to clean first names
clean_names <- function(name){

  sub("(.*?) .*", "\\1", name) %>%
    tolower()
}


# Internal function to match state abbreviations and state codes
state2code <- function(uf){

  ufs <- br_states()$abb

  uf <- toupper(uf) %>%
    match.arg(ufs)

  br_states()$code[match(uf, ufs)]
}


# Avoid the R CMD check note about magrittr's dot
utils::globalVariables(".")
