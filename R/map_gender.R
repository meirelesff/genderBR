#' Maps gender predictions from Brazilian first names by state
#'
#' \code{map_gender} consults the Instituto Brasileiro de Geografia e Estatistica's 2010 Census API
#' to extract the number of male or female persons with a given name in a given state.
#'
#' @param name A string specifying a person's first name. The name can also be passed to the function
#' as a full name (e.g., Ana Maria de Souza). \code{get_gender} is case insensitive.
#' @param gender A string with the gender to loop for. Valid inputs are \code{male}, \code{female}, and \code{NULL},
#' in which case the functions returns results for all persons with a given name.
#'
#' @return \code{get_gender} returns ...
#'
#'
#' @import dplyr
#' @import httr
#' @export


map_gender <- function(name, gender = NULL){


  # Clean name
  name <- clean_names(name)

  # Gender input
  if(is.null(gender)) gender <- NULL
  else if(tolower(gender) == "female") gender <- "f"
  else if(tolower(gender) == "male") gender <- "m"

  # API endpoint
  ibge <- "http://servicodados.ibge.gov.br/api/v1/censos/nomes/mapa"

  # GET
  total <- httr::GET(ibge, query = list(nome = name, sexo = gender))

  # Test response
  httr::stop_for_status(total)

  # Parse and return
  httr::content(total, as = "text") %>%
    jsonlite::fromJSON()
}
