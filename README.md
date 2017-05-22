
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

And both full names and names written in lower or upper case are accepted as inputs:

``` r
get_gender("Mario da Silva")
#> [1] "Male"
get_gender("ANA MARIA")
#> [1] "Female"
```

Additionally, one can filter results by state with the argument `state` or get the probability that a given first name belongs to a female person by setting the `prob` argument to `TRUE` (defaults to `FALSE`).

``` r
# What is the probability that the name Ariel belongs to a female person in Brazil?
get_gender("Ariel", prob = TRUE)
#> [1] 0.09219289

# What about differences between Brazilian states?
get_gender("Ariel", prob = TRUE, state = "RJ") # RJ, Rio de Janeiro
#> [1] 0.2627399
get_gender("Ariel", prob = TRUE, state = "RS") # RS, Rio Grande do Sul
#> [1] 0.05144695
get_gender("Ariel", prob = TRUE, state = "SP") # SP, Sao Paulo
#> [1] 0.1294782
```

### Brazilian state abbreviations

The `genderBR` package relies on Brazilian state abbreviations (acronyms) to filter results. To get a complete dataset with the full name, IBGE code, and abbreviations of all 27 Brazilian states, use the `br_states` functions:

``` r
br_states()
#> # A tibble: 27 × 3
#>               state   abb  code
#>               <chr> <chr> <int>
#> 1              ACRE    AC    12
#> 2           ALAGOAS    AL    27
#> 3             AMAPA    AP    16
#> 4          AMAZONAS    AM    13
#> 5             BAHIA    BA    29
#> 6             CEARA    CE    23
#> 7  DISTRITO FEDERAL    DF    53
#> 8    ESPIRITO SANTO    ES    32
#> 9             GOIAS    GO    52
#> 10         MARANHAO    MA    21
#> # ... with 17 more rows
```

Geographic distribution of Brazilian first names
------------------------------------------------

The `genderBR` package can also be used to get information on the relative and total number of persons with a given name by gender and by state in Brazil. To that end, use the `map_gender` function:

``` r
map_gender("maria")
#> # A tibble: 27 × 6
#>                   nome    uf    freq populacao  sexo     prop
#> *                <chr> <int>   <int>     <int> <chr>    <dbl>
#> 1                Piauí    22  363139   3118360       11645.19
#> 2                Ceará    23  967042   8452381       11441.06
#> 3              Paraíba    25  423026   3766528       11231.19
#> 4  Rio Grande do Norte    24  341940   3168027       10793.47
#> 5              Alagoas    27  321330   3120494       10297.41
#> 6           Pernambuco    26  838534   8796448        9532.64
#> 7              Sergipe    28  188619   2068017        9120.77
#> 8             Maranhão    21  574689   6574789        8740.80
#> 9                 Acre    12   63172    733559        8611.71
#> 10        Minas Gerais    31 1307650  19597330        6672.59
#> # ... with 17 more rows
```

To specify gender in the consultation, use the optional argument `gender` (valid inputs are `f`, for female; `m`, for male; or `NULL`, the default option).

``` r
map_gender("iris", gender = "m")
#> # A tibble: 23 × 6
#>                nome    uf  freq populacao  sexo  prop
#> *             <chr> <int> <int>     <int> <chr> <dbl>
#> 1             Goiás    52   840   6003788     m 13.99
#> 2         Tocantins    17   156   1383445     m 11.28
#> 3             Bahia    29   422  14016906     m  3.01
#> 4       Mato Grosso    51    91   3035122     m  3.00
#> 5      Minas Gerais    31   512  19597330     m  2.61
#> 6  Distrito Federal    53    65   2570160     m  2.53
#> 7    Espírito Santo    32    69   3514952     m  1.96
#> 8          Rondônia    11    28   1562409     m  1.79
#> 9              Pará    15   129   7581051     m  1.70
#> 10   Rio de Janeiro    33   225  15989929     m  1.41
#> # ... with 13 more rows
```

Installing
----------

`genderBR` is not yet available on CRAN. To install a development version, use:

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
