
<!-- README.md is generated from README.Rmd. Please edit that file -->

# genderBR

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/genderBR)](https://cran.r-project.org/package=genderBR)
[![Codecov test
coverage](https://codecov.io/gh/meirelesff/genderBR/graph/badge.svg)](https://app.codecov.io/gh/meirelesff/genderBR)
[![Package-License](https://img.shields.io/badge/License-GPL-brightgreen.svg)](http://www.gnu.org/licenses/gpl-2.0.html)
[![R-CMD-check](https://github.com/meirelesff/genderBR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/meirelesff/genderBR/actions/workflows/R-CMD-check.yaml)

`genderBR` predicts gender from Brazilian first names using data from
the Instituto Brasileiro de Geografia e Estatistica’s Census (2010 and
2022).

## How does it work?

`genderBR`’s main function is `get_gender`, which takes a string with a
Brazilian first name and predicts its gender using data from the IBGE’s
Census (2010 or 2022) – specifically, from its API and from an internal
dataset.

By default, `get_gender` uses 2010 data, but you can now specify the
`year` argument to use 2022 data:

``` r
library(genderBR)
#> 
#> To cite genderBR in publications, use: citation('genderBR')
#> To learn more, visit: fmeireles.com/genderbr

get_gender("joão", year = 2022)
#> [1] "Male"
get_gender("ana", year = 2022)
#> [1] "Female"
```

The function uses data on the number of females and males with the same
name in Brazil, or in a given Brazilian state, and calculates the
proportion of female uses of it. The function then classifies a name as
male or female only when that proportion is higher than a given
threshold (e.g., `female if proportion > 0.9`, or
`male if proportion <= 0.1`); proportions below those thresholds are
classified as missing (`NA`). An example:

``` r
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

And both full names and names written in lower or upper case are
accepted as inputs:

``` r
get_gender("Mario da Silva")
#> [1] "Male"
get_gender("ANA MARIA")
#> [1] "Female"
```

Additionally, one can filter results by state with the argument `state`;
or get the probability that a given first name belongs to a female
person by setting the `prob` argument to `TRUE` (defaults to `FALSE`).

The `year` argument is available for both API and internal data. When
`internal = TRUE` (the default and fastest option for national-level
queries), the package uses an internal dataset with probabilities for
both 2010 and 2022. When `state` is specified, the function always uses
the IBGE API for the selected year.

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

Note that a vector with states’ abbreviations is a valid input for
`get_gender` function, so this also works:

``` r
name <- rep("Ariel", 3)
states <- c("rj", "rs", "sp")
get_gender(name, prob = T, state = states)
#> [1] 0.26273991 0.05144695 0.12947819
```

This can be useful also to predict the gender of different individuals
living in different states:

``` r
df <- data.frame(name = c("Alberto da Silva", "Maria dos Santos", "Thiago Rocha", "Paula Camargo"),
                 uf = c("AC", "SP", "PE", "RS"),
                 stringsAsFactors = FALSE
                 )

df$gender <- get_gender(df$name, df$uf)

df
#>               name uf gender
#> 1 Alberto da Silva AC   Male
#> 2 Maria dos Santos SP Female
#> 3     Thiago Rocha PE   Male
#> 4    Paula Camargo RS Female
```

### Brazilian state abbreviations

The `genderBR` package relies on Brazilian state abbreviations
(acronyms) to filter results. To get a complete dataset with the full
name, IBGE code, and abbreviations of all 27 Brazilian states, use the
`get_states` functions:

``` r
get_states()
#>      state abb code
#> 1     ACRE  AC   12
#> 2  ALAGOAS  AL   27
#> 3    AMAPA  AP   16
#> 4 AMAZONAS  AM   13
#> 5    BAHIA  BA   29
#> 6    CEARA  CE   23
#>  [ reached 'max' / getOption("max.print") -- omitted 21 rows ]
```

## Geographic distribution of Brazilian first names

The `genderBR` package can also be used to get information on the
relative and total number of persons with a given name by gender and by
state in Brazil. To that end, use the `map_gender` function:

``` r
map_gender("maria")
#>      nome uf   freq populacao sexo     prop
#> 1   Piauí 22 363139   3118360      11645.19
#> 2   Ceará 23 967042   8452381      11441.06
#> 3 Paraíba 25 423026   3766528      11231.19
#>  [ reached 'max' / getOption("max.print") -- omitted 24 rows ]
```

To specify gender in the consultation, use the optional argument
`gender` (valid inputs are `f`, for female; `m`, for male; or `NULL`,
the default option).

``` r
map_gender("iris", gender = "m")
#>        nome uf freq populacao sexo  prop
#> 1     Goiás 52  840   6003788    m 13.99
#> 2 Tocantins 17  156   1383445    m 11.28
#> 3     Bahia 29  422  14016906    m  3.01
#>  [ reached 'max' / getOption("max.print") -- omitted 20 rows ]
```

## Backend and performance

Internally, `genderBR` now uses the `data.table` backend for joins and
merges. This keeps user-facing outputs as base data.frames while
speeding up repeated lookups for large vectors of names (mainly when
aggregating duplicates before querying the IBGE API or matching against
the internal dataset).

## Installing

To install `genderBR`’s last stable version on CRAN, use:

``` r
install.packages("genderBR")
```

To install a development version, use:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("meirelesff/genderBR")
```

## Data

The surveyed population in the Instituto Brasileiro de Geografia e
Estatistica’s (IBGE) 2010 and 2022 Census included over 190 million
individuals.

|                 Year | Unique names |
|---------------------:|:-------------|
|                 2010 | 125294       |
|                 2022 | 123733       |
| Unique (2010 & 2022) | 141742       |

The Census recorded the first names of all individuals, along with their
self-declared biological gender (male or female) and their state of
residence. To extract the number of male or female uses of a given first
name in Brazil, the package employs the IBGE’s
[API](https://censo2022.ibge.gov.br/nomes/) and, since version 1.1.0,
also an internal dataset containing all the names recorded in the IBGE’s
Census. As of version 1.2.0, this internal dataset includes
probabilities for both 2010 and 2022, allowing fast offline predictions
for either year. In this service, different spellings (e.g., Ana and
Anna, or Marcos and Markos) imply different occurrences, and only names
with more than 20 occurrences, or more than 15 occurrences in a given
state, are included in the database.

For more information on the IBGE’s data, please check (in Portuguese):
<https://censo2022.ibge.gov.br/nomes/>

## Author

[Fernando Meireles](https://fmeireles.com)
