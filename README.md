
<!-- README.md is generated from README.Rmd. Please edit that file -->
genderBR
========

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/genderBR)](https://cran.r-project.org/package=genderBR) [![Travis-CI Build Status](https://travis-ci.org/meirelesff/genderBR.svg?branch=master)](https://travis-ci.org/meirelesff/genderBR) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/meirelesff/genderBR?branch=master&svg=true)](https://ci.appveyor.com/project/meirelesff/genderBR) [![Package-License](https://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)

`genderBR` predicts gender from Brazilian first names using data from the Instituto Brasileiro de Geografia e Estatistica's 2010 Census [API](http://censo2010.ibge.gov.br/nomes/).

How does it work?
-----------------

`genderBR`'s main function is `get_gender`, which takes a string with a Brazilian first name and predicts its gender using data from the IBGE's 2010 Census. More specifically, it extracts the number of female and male persons with a given first name and tries to predict the gender...

``` r
library(genderBR)

get_gender("joão")
#> [1] "Male"
get_gender("ana")
#> [1] "Female"
```

Multiple names can be passed at the same function call:

``` r
get_gender(c("pedro", "maria"))
#> [1] "Male"   "Female"
```

And the function accepts both full names and names written in lower or upper case:

``` r
get_gender("Mario da Silva")
#> [1] "Male"
get_gender("ANA MARIA")
#> [1] "Female"
```

Additionally, one can filter results by state with the argument `state` or get the probability that a given first name belongs to a female person by setting the `prob` argument to `TRUE` (defaults to `FALSE`).

``` r
# Get probabilities
get_gender("Ariel", prob = TRUE)
#> [1] 0.09219289

# And filter results by state
get_gender("Ariel", prob = TRUE, state = "RJ") # RJ, Rio de Janeiro
#> [1] 0.2627399
get_gender("Ariel", prob = TRUE, state = "RS") # RS, Rio Grande do Sul
#> [1] 0.05144695
get_gender("Ariel", prob = TRUE, state = "SP") # SP, Sao Paulo
#> [1] 0.1294782
```

Installing
----------

To install the package development version, use:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("meirelesff/genderBR")
```

Data
----

The data used in this package come from the Instituto Brasileiro de Geografia e Estatistica's (IBGE) 2010 Census. The surveyed population includes 190,8 million Brazilians -- with more than 130,000 unique first names.

To extracts the numer of male and female persons with a given first name in Brazil, the package uses the [API](http://censo2010.ibge.gov.br/nomes/) provided by the IBGE. In this service, names with different spelling (e.g., Ana and Anna, or Marcos and Markos) are considered different names, and only names with more than 20 occurrences, or more than 15 occurrences in a given state, were included in the database.

For more information on the IBGE's data, please check (in Portuguese): <http://censo2010.ibge.gov.br/nomes/>

Author
------

[Fernando Meireles](http://fmeireles.com)
