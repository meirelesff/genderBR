#' Map the use of Brazilian first names by gender and by state
#'
#' \code{map_gender} retrieves data on the number of male or female uses of a given first name
#' by state from the Instituto Brasileiro de Geografia e Estatistica's 2010 Census API.
#'
#' @param name A string with a Brazilian first name. The name can also be passed to the function
#' as a full name (e.g., Ana Maria de Souza). \code{get_gender} is case insensitive.
#' @param gender A string with the gender to look for. Valid inputs are \code{m}, for males, \code{f},
#' for females, and \code{NULL}, in which case the function returns results for all persons with a given name.
#'
#' @details Information on the gender associated with Brazilian first names was collect in the 2010 Census
#' (Censo Demografico de 2010, in Portuguese), in July of that year, by the Instituto Brasileiro de Demografia
#' e Estatistica (IBGE). The surveyed population includes 190,8 million Brazilians living in all 27 states.
#' According to the IBGE, there are more than 130,000 unique first names in this population.
#'
#' @note Names with different spell (e.g., Ana and Anna, or Marcos and Markos) are considered different names.
#' Additionally, only names with more than 20 occurrences, or more than 15 occurrences in a given state,
#' are considered.
#'
#' @references For more information on the IBGE's data, please check (in Portuguese):
#' \url{http://censo2010.ibge.gov.br/nomes/}
#'
#' @seealso \code{\link{get_gender}}
#'
#' @return \code{get_gender} returns a \code{tbl_df, tbl, data.frame} with the following variables:
#'
#' \itemize{
#'   \item \code{nome} State's name.
#'   \item \code{uf} State's abbreviation.
#'   \item \code{freq} Total number of persons with the name provided.
#'   \item \code{populacao} State's total population.
#'   \item \code{sexo} Same as the \code{sexo} argument provided.
#'   \item \code{prop} Persons with the name and gender provided per 100,000 inhabitants.
#' }
#'
#' @examples
#' # Map the use of the name 'Joao' for
#' # males in Brazil by state
#' map_gender('Joao', gender = 'm')
#'
#' \donttest{
#' # Map the use of the name 'Maria'
#' map_gender('maria')
#'
#' # The function accepts full names
#' map_gender('Maria da Silva Santos')
#'
#' # Or names in uppercase
#' map_gender('MARIA DA SILVA SANTOS')
#' }
#'
#' \dontshow{
#' map_gender('AUGUSTO ROBERTO', gender = 'm')
#' map_gender('John da Silva', gender = 'm')
#' }
#'
#'
#' @import jsonlite
#' @import dplyr
#' @import httr
#' @export


map_gender <- function(name, gender = NULL){


  # Clean name
  name <- clean_names(name)

  # GET
  total <- "http://servicodados.ibge.gov.br/api/v1/censos/nomes/mapa" %>%
    httr::GET(query = list(nome = name, sexo = gender))

  # Test response
  httr::stop_for_status(total)

  # Parse and return
  httr::content(total, as = "text") %>%
    jsonlite::fromJSON() %>%
    dplyr::as.tbl()
}
