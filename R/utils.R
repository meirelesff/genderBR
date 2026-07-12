# OnAttach message
.onAttach <-
  function(libname, pkgname) {
    packageStartupMessage("\nIf you find this package useful, please consider acknowledging it.\nUse: citation('genderBR')\n")
  }


#' State's abbreviations
#'
#' Use this function to get a \code{data.frame} with the full names, abbreviations
#' (acronym), and IBGE codes of all Brazilian states.
#'
#' @return A \code{tbl_df, tbl, data.frame} with two variables: \code{state}, \code{abb}, and \code{code}.
#' @export

get_states <- function(){

  data.frame(
    state = c("ACRE", "ALAGOAS", "AMAPA", "AMAZONAS", "BAHIA", "CEARA", "DISTRITO FEDERAL",
              "ESPIRITO SANTO", "GOIAS", "MARANHAO", "MATO GROSSO DO SUL", "MATO GROSSO",
              "MINAS GERAIS", "PARA", "PARAIBA", "PARANA", "PERNAMBUCO", "PIAUI",
              "RIO DE JANEIRO", "RIO GRANDE DO NORTE", "RIO GRANDE DO SUL", "RONDONIA",
              "RORAIMA", "SANTA CATARINA", "SAO PAULO", "SERGIPE", "TOCANTINS"),
    abb = c("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA",
            "MS", "MT", "MG", "PA", "PB", "PR","PE", "PI", "RJ", "RN",
            "RS", "RO", "RR", "SC", "SP", "SE", "TO"),
    code = c(12L, 27L, 16L, 13L, 29L, 23L, 53L, 32L, 52L, 21L, 51L, 50L,
             31L, 15L, 25L, 41L, 26L, 22L, 33L, 24L, 43L, 11L, 14L, 42L, 35L,
             28L, 17L),
    stringsAsFactors = FALSE
  )
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


# Internal function to validate the threshold argument and return one value per sex
check_threshold <- function(threshold){

  if(!is.numeric(threshold)) stop("'threshold' must be numeric, between 0 and 1.", call. = FALSE)
  if(!length(threshold) %in% 1:2 || anyNA(threshold))
    stop("'threshold' must be a vector of length 1 or 2, without missing values.", call. = FALSE)
  if(any(threshold < 0 | threshold > 1)) stop("'threshold' must be between 0 and 1.", call. = FALSE)

  # A single value sets a symmetrical threshold
  if(length(threshold) == 1) threshold <- rep(unname(threshold), 2)

  # Named values ('Female'/'Male', or 'F'/'M') may come in any order
  sexes <- substr(toupper(names(threshold)), 1, 1)
  if(length(sexes) == 2){
    if(!setequal(sexes, c("F", "M")))
      stop("'threshold' must be named 'Female' and 'Male' (or 'F' and 'M').", call. = FALSE)
    threshold <- c(threshold[sexes == "F"], threshold[sexes == "M"])
  }

  # Overlapping thresholds would make a name both female and male
  if(sum(threshold) < 1)
    stop("'threshold' values are ambiguous: the female and male thresholds must sum to at least 1.", call. = FALSE)

  c(female = threshold[[1]], male = threshold[[2]])
}


# Internal function to round numeric guess
round_guess <- function(prob, threshold){

  res <- ifelse(prob > threshold[["female"]], "Female",
                ifelse(prob < (1 - threshold[["male"]]), "Male", "Unknown"))
  as.character(res)
}


# Internal function to clean first names
clean_names <- function(name, encoding){

  name <- sub("^\\s+", "", name) # Remove leading white
  name <- sub("\\s+$", "", name) # Remove trailing white
  name <- sub("(.*?) .*", "\\1", name) # First name only
  name <- tolower(name)
  name <- chartr(
    "\u00e0\u00e1\u00e2\u00e3\u00e4\u00e5\u00e8\u00e9\u00ea\u00eb\u00ec\u00ed\u00ee\u00ef\u00f2\u00f3\u00f4\u00f5\u00f6\u00f9\u00fa\u00fb\u00fc\u00fd\u00f1\u00e7",
    "aaaaaaeeeeiiiioooooouuuuync",
    name
  )

  return(name)
}


# Internal function to prepare vector with state abbreviations
get_state <- function(state, ln){

  state <- sapply(state, function(state) state2code(state))
  if(ln > 1 & length(state) == 1) state <- rep(state, ln)

  return(unname(state))
}


# Internal function to match state abbreviations and state codes
state2code <- function(uf){

  ufs <- get_states()$abb

  uf <- toupper(uf) |>
    match.arg(ufs)

  return(get_states()$code[match(uf, ufs)])
}


# Safe GET (avoid unninformative timeouts)
#' @importFrom purrr possibly
get_safe <- purrr::possibly(httr::GET, otherwise = NULL)

