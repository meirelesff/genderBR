# Internal function to test responses
test_responses <- function(response1, response2){

  httr::stop_for_status(response1)
  httr::stop_for_status(response2)

  if(length(response1$content) == 2 & length(response2$content) == 2){

    return(TRUE)
  } else {

    return(FALSE)
  }
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
    tolower() %>%
    gsub("[^a-zA-Z]", "", .)
}




# Internal function to match state abbreviations and state codes

#states <- mapa %>%
#  select(nome, uf) %>%
#  setNames(c("state", "state_code")) %>%
#  mutate(state = iconv(state, from = "UTF-8", to = "ASCII//TRANSLIT"),
#         state = toupper(state)) %>%
#  as.tbl() %>%
#  arrange(state)


# Avoid the R CMD check note about magrittr's dot
utils::globalVariables(".")
