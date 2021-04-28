# OnAttach message
.onAttach <-
  function(libname, pkgname) {
    packageStartupMessage("\nTo cite genderBR in publications, use: citation('genderBR')")
    packageStartupMessage("To learn more, visit: fmeireles.com/genderbr\n")
  }


#' State's abbreviations
#'
#' Use this function to get a \code{data.frame} with the full names, abbreviations
#' (acronym), and IBGE codes of all Brazilian states.
#'
#' @return A \code{tbl_df, tbl, data.frame} with two variables: \code{state}, \code{abb}, and \code{code}.
#' @export

get_states <- function(){

  tibble::tibble(state = c("ACRE", "ALAGOAS", "AMAPA", "AMAZONAS", "BAHIA", "CEARA", "DISTRITO FEDERAL",
                       "ESPIRITO SANTO", "GOIAS", "MARANHAO", "MATO GROSSO DO SUL", "MATO GROSSO",
                       "MINAS GERAIS", "PARA", "PARAIBA", "PARANA", "PERNAMBUCO", "PIAUI",
                       "RIO DE JANEIRO", "RIO GRANDE DO NORTE", "RIO GRANDE DO SUL", "RONDONIA",
                       "RORAIMA", "SANTA CATARINA", "SAO PAULO", "SERGIPE", "TOCANTINS"),
             abb = c("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA",
                     "MS", "MT", "MG", "PA", "PB", "PR","PE", "PI", "RJ", "RN",
                     "RS", "RO", "RR", "SC", "SP", "SE", "TO"),
             code = c(12L, 27L, 16L, 13L, 29L, 23L, 53L, 32L, 52L, 21L, 51L, 50L,
                      31L, 15L, 25L, 41L, 26L, 22L, 33L, 24L, 43L, 11L, 14L, 42L, 35L,
                      28L, 17L))
}


# Internal function to test void names
test_responses <- function(response1, response2, prob){

  httr::stop_for_status(response1, task = "retrieve IBGE's API data.")
  httr::stop_for_status(response2, task = "retrieve IBGE's API data.")

  if(length(response1$content) == 2 & length(response2$content) == 2) return(NA)
  if(length(response1$content) == 2 & length(response2$content) > 2 & prob == TRUE) return(0)
  if(length(response1$content) > 2 & length(response2$content) == 2 & prob == TRUE) return(1)
  if(length(response1$content) == 2 & length(response2$content) > 2 & prob == FALSE) return("Male")
  if(length(response1$content) > 2 & length(response2$content) == 2 & prob == FALSE) return("Female")

  NULL
}


# Internal function to round numeric guess
round_guess <- function(prob, threshold){

  dplyr::case_when(prob > threshold ~ "Female",
                   prob < (1 - threshold) ~ "Male",
                   TRUE ~ as.character(NA)
                   )
}


# Internal function to clean first names
clean_names <- function(name, encoding){

  name <- sub("^\\s+", "", name) # Remove leading white
  name <- sub("\\s+$", "", name) # Remove trailing white
  name <- sub("(.*?) .*", "\\1", name) # First name only
  name <- iconv(name, to = encoding) # Remove accents
  name <- tolower(name)

  return(name)
}


# Internal function to prepare vector with state abbreviations
get_state <- function(state, ln){

  state <- sapply(state, function(state) state2code(state))
  if(ln > 1 & length(state) == 1) state <- rep(state, ln)

  return(state)
}


# Internal function to match state abbreviations and state codes
state2code <- function(uf){

  ufs <- get_states()$abb

  uf <- toupper(uf) %>%
    match.arg(ufs)

  return(get_states()$code[match(uf, ufs)])
}


# Safe GET (avoid unninformative timeouts)
get_safe <- purrr::possibly(httr::GET, otherwise = NULL)

