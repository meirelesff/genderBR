% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_gender.R
\name{get_gender}
\alias{get_gender}
\title{Predict gender from Brazilian first names}
\usage{
get_gender(
  names,
  state = NULL,
  prob = FALSE,
  threshold = 0.9,
  internal = TRUE,
  encoding = "ASCII//TRANSLIT"
)
}
\arguments{
\item{names}{A character vector specifying a person's first name. Names can also be passed to the function
as a full name (e.g., Ana Maria de Souza). \code{get_gender} is case insensitive.
In addition, multiple names can be passed in the same function call.}

\item{state}{A string with the state of federation abbreviation
(e.g., \code{RJ} for Rio de Janeiro). If state is set to a value different
from \code{NULL}, the \code{internal} argument is ignored.}

\item{prob}{Report the proportion of female uses of the name? Defaults to \code{FALSE}.}

\item{threshold}{Numeric indicating the threshold used in predictions. Defaults to 0.9.}

\item{internal}{Use internal data to predict gender? Allowing this option makes
the function faster, but it does not support getting results by State.
Defaults to \code{TRUE}.}

\item{encoding}{Encoding used to read Brazilian names and stip accents.
Defaults to \code{ASCII//TRANSLIT}.}
}
\value{
\code{get_gender} may returns three different values: \code{Female},
if the name provided is female; \code{Male}, if the name provided is male;
or \code{NA}, if we can not predict gender from the name given the chosen threshold.

If the \code{prob} argument is set to \code{TRUE}, then the function returns
the proportion of females uses of the provided name.
}
\description{
\code{get_gender} uses the IBGE's 2010 Census data to predict gender from Brazilian first names.
In particular, the function exploits data on the number of females and males with the same name
in Brazil, or in a given Brazilian state, to calculate the proportion of females using it.

The function classifies a name as *male* or *female* only when that proportion is higher than
a given threshold (e.g., \code{female if proportion > 0.9, the default}, or \code{male if proportion < 0.1});
proportions below this threshold are classified as missings (\code{NA}). The method is based on the \code{gender}
functionality developed by Lincon Mullen in:
Mullen (2016). gender: Predict Gender from Names Using Historical Data.

Multiple names can be passed to the function call. To speed the calculations,
the package aggregates equal first names to make fewer requests to the IBGE's API.
Also, the package contains an internal dataset with all the names reported by the
IBGE to make faster classifications -- although this option does not support getting results by State.
}
\note{
Names with different spell (e.g., Ana and Anna, or Marcos and Markos) are considered different names.
In addition, only names with more than 20 occurrences, or more than 15 occurrences in a given state,
are included in the IBGE's data.

Also note that UTF-8 special characters, common in Portuguese words and names, are not supported by the IBGE's API.
Users are encouraged to convert strings to ASCII (it is also possible to set the \code{encoding} argument
to a different value).
}
\section{Data}{


Information on the Brazilian first names uses by gender was collect in the 2010 Census
(Censo Demografico de 2010, in Portuguese), in July of that year, by the Instituto Brasileiro de Demografia
e Estatistica (IBGE). The surveyed population includes 190,8 million Brazilians living in all 27 states.
According to the IBGE, there are more than 130,000 unique first names in this population.
}

\examples{
#' # Use get_gender to predict the gender of a person based on her/his first name
get_gender('MARIA DA SILVA SANTOS')
get_gender('joao')

# To change the employed threshold
get_gender('ariel', threshold = 0.8)

# Or to get the proportion of females
# with the name provided
get_gender('iris', prob = TRUE)

# Multiple names can be predict at the same time
get_gender(c('joao', 'ana', 'benedita', 'rafael'))

\dontrun{

# In different states (using API data, must have internet connection)
get_gender(rep('Ana', 3), c('sp', 'am', 'rs'))
 }
}
\references{
For more information on the IBGE's data, please check (in Portuguese):
\url{https://censo2010.ibge.gov.br/nomes/}
}
\seealso{
\code{\link{map_gender}}
}
