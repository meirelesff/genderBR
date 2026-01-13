
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
#>                  state abb code
#> 1                 ACRE  AC   12
#> 2              ALAGOAS  AL   27
#> 3                AMAPA  AP   16
#> 4             AMAZONAS  AM   13
#> 5                BAHIA  BA   29
#> 6                CEARA  CE   23
#> 7     DISTRITO FEDERAL  DF   53
#> 8       ESPIRITO SANTO  ES   32
#> 9                GOIAS  GO   52
#> 10            MARANHAO  MA   21
#> 11  MATO GROSSO DO SUL  MS   51
#> 12         MATO GROSSO  MT   50
#> 13        MINAS GERAIS  MG   31
#> 14                PARA  PA   15
#> 15             PARAIBA  PB   25
#> 16              PARANA  PR   41
#> 17          PERNAMBUCO  PE   26
#> 18               PIAUI  PI   22
#> 19      RIO DE JANEIRO  RJ   33
#> 20 RIO GRANDE DO NORTE  RN   24
#> 21   RIO GRANDE DO SUL  RS   43
#> 22            RONDONIA  RO   11
#> 23             RORAIMA  RR   14
#> 24      SANTA CATARINA  SC   42
#> 25           SAO PAULO  SP   35
#> 26             SERGIPE  SE   28
#> 27           TOCANTINS  TO   17
```

## Geographic distribution of Brazilian first names

The `genderBR` package can also be used to get information on the
relative and total number of persons with a given name by gender and by
state in Brazil. To that end, use the `map_gender` function:

``` r
map_gender("maria")
#>                   nome uf    freq populacao sexo     prop
#> 1                Piauí 22  363139   3118360      11645.19
#> 2                Ceará 23  967042   8452381      11441.06
#> 3              Paraíba 25  423026   3766528      11231.19
#> 4  Rio Grande do Norte 24  341940   3168027      10793.47
#> 5              Alagoas 27  321330   3120494      10297.41
#> 6           Pernambuco 26  838534   8796448       9532.64
#> 7              Sergipe 28  188619   2068017       9120.77
#> 8             Maranhão 21  574689   6574789       8740.80
#> 9                 Acre 12   63172    733559       8611.71
#> 10        Minas Gerais 31 1307650  19597330       6672.59
#> 11           Tocantins 17   87040   1383445       6291.54
#> 12                Pará 15  472891   7581051       6237.80
#> 13    Distrito Federal 53  146770   2570160       5710.54
#> 14               Bahia 29  766238  14016906       5466.53
#> 15               Amapá 16   35298    669526       5272.09
#> 16               Goiás 52  314352   6003788       5235.89
#> 17           São Paulo 35 2143232  41262199       5194.18
#> 18            Amazonas 13  173034   3483985       4966.55
#> 19      Espírito Santo 32  169081   3514952       4810.34
#> 20      Rio de Janeiro 33  752021  15989929       4703.09
#> 21            Rondônia 11   72579   1562409       4645.33
#> 22             Roraima 14   20848    450479       4627.96
#> 23         Mato Grosso 51  125984   3035122       4150.87
#> 24              Paraná 41  432175  10444526       4137.81
#> 25  Mato Grosso do Sul 50  100649   2449024       4109.76
#> 26      Santa Catarina 42  210558   6248436       3369.77
#> 27   Rio Grande do Sul 43  322238  10693929       3013.28
```

To specify gender in the consultation, use the optional argument
`gender` (valid inputs are `f`, for female; `m`, for male; or `NULL`,
the default option).

``` r
map_gender("iris", gender = "m")
#>                   nome uf freq populacao sexo  prop
#> 1                Goiás 52  840   6003788    m 13.99
#> 2            Tocantins 17  156   1383445    m 11.28
#> 3                Bahia 29  422  14016906    m  3.01
#> 4          Mato Grosso 51   91   3035122    m  3.00
#> 5         Minas Gerais 31  512  19597330    m  2.61
#> 6     Distrito Federal 53   65   2570160    m  2.53
#> 7       Espírito Santo 32   69   3514952    m  1.96
#> 8             Rondônia 11   28   1562409    m  1.79
#> 9                 Pará 15  129   7581051    m  1.70
#> 10      Rio de Janeiro 33  225  15989929    m  1.41
#> 11  Mato Grosso do Sul 50   32   2449024    m  1.31
#> 12      Santa Catarina 42   77   6248436    m  1.23
#> 13           São Paulo 35  485  41262199    m  1.18
#> 14              Paraná 41  122  10444526    m  1.17
#> 15            Maranhão 21   59   6574789    m  0.90
#> 16             Alagoas 27   27   3120494    m  0.87
#> 17               Piauí 22   27   3118360    m  0.87
#> 18            Amazonas 13   28   3483985    m  0.80
#> 19   Rio Grande do Sul 43   79  10693929    m  0.74
#> 20             Paraíba 25   24   3766528    m  0.64
#> 21          Pernambuco 26   53   8796448    m  0.60
#> 22               Ceará 23   45   8452381    m  0.53
#> 23 Rio Grande do Norte 24   16   3168027    m  0.51
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
Estatistica’s (IBGE) 2010 Census includes 190,8 million Brazilians –
with more than 130,000 unique first names.

To extract the number of male or female uses of a given first name in
Brazil, the package employs the IBGE’s
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
