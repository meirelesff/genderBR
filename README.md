
# genderBR

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/genderBR)](https://cran.r-project.org/package=genderBR)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/genderBR)](https://cran.r-project.org/package=genderBR)
[![Codecov test
coverage](https://codecov.io/gh/meirelesff/genderBR/graph/badge.svg)](https://app.codecov.io/gh/meirelesff/genderBR)
[![Package-License](https://img.shields.io/badge/License-GPL-brightgreen.svg)](https://www.gnu.org/licenses/gpl-2.0.html)
[![R-CMD-check](https://github.com/meirelesff/genderBR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/meirelesff/genderBR/actions/workflows/R-CMD-check.yaml)

`genderBR` predicts gender from Brazilian first names using data from
the Instituto Brasileiro de Geografia e Estatistica’s Census (2010 and
2022), covering over 142 thousand unique names. For names absent from
the IBGE Censuses, the package offers a character-level neural network
model backend to predict the gender of rare or unknown names.

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

To use the neural network model, `genderBR` relies on [R
torch](https://torch.mlverse.org/packages/) that can be installed with:

``` r
install.packages("torch")
```

Please, check the [R torch installation
guide](https://torch.mlverse.org/docs/articles/installation) for more
details on how to install it.

## How does it work?

`genderBR`’s main function is `get_gender`, which takes a string with a
Brazilian first name and predicts its gender using data from the IBGE’s
Census (2010 or 2022) – specifically, from its API and from an internal
dataset.

By default, `get_gender` uses 2022 data, but the `year` argument can be
used to specify a different year:

``` r
library(genderBR)
#> 
#> If you find this package useful, please consider acknowledging it.
#> Use: citation('genderBR')

get_gender("joão", year = 2010)
#> [1] "Male"
get_gender("joão", year = 2022)
#> [1] "Male"
```

The function calculates the proportion of females with a given name in
Brazil or a specific state using IBGE Census data. It classifies a name
as female or male only when this proportion exceeds a specified
threshold (e.g., `female if proportion > 0.9`, or
`male if proportion <= 0.1`); proportions below those thresholds are
classified as missing (`NA`, or `Unkown`). The `threshold` argument also
takes two values, the first for females and the second for males (e.g.,
`threshold = c(0.9, 0.8)`, or `threshold = c(Female = 0.9, Male = 0.8)`),
which is useful to calibrate each side of the classification separately.
An example:

``` r
get_gender("Ana")
#> [1] "Female"
get_gender("Darcy")
#> [1] "Unknown"
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
or obtain the probability that a name is female by setting `prob = TRUE`
(defaults to `FALSE`).

The `year` argument is available for both API and internal data. When
`internal = TRUE` (the default and fastest option for national-level
queries), the package uses an internal dataset with probabilities for
both 2010 and 2022. When `state` is specified, the function always uses
the IBGE API for the selected year.

``` r
# What is the probability that the name Ariel belongs to a female person in Brazil?
get_gender("Ariel", prob = TRUE)
#> [1] 0.09887588

# What about differences between Brazilian states?
get_gender("Ariel", prob = TRUE, state = "RJ") # RJ, Rio de Janeiro
#> [1] 0.3423689
get_gender("Ariel", prob = TRUE, state = "RS") # RS, Rio Grande do Sul
#> [1] 0.05841056
get_gender("Ariel", prob = TRUE, state = "SP") # SP, Sao Paulo
#> [1] 0.1399795
```

Note that a vector with states’ abbreviations is a valid input for
`get_gender` function, so this also works:

``` r
name <- rep("Ariel", 3)
states <- c("rj", "rs", "sp")
get_gender(name, prob = T, state = states)
#> [1] 0.34236889 0.05841056 0.13997952
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

### Classifying uncommon Brazilian first names

For names that are not present in the IBGE’s Census, the package now
also allows users to predict gender with a character-level neural
network model that generalises to unseen names. This model was trained
on the IBGE’s Census data and is available on [Hugging
Face](https://huggingface.co/fmeireles/genderBR). Download it with:

``` r
download_gender_model()
```

To use this feature, set the `nn` argument to `TRUE` in the `get_gender`
function (defaults to `FALSE`):

``` r
get_gender("Zusjane", nn = TRUE)
#> [1] "Female"
get_gender(c("Lusjane", "Joao"), nn = TRUE, prob = TRUE)
#> [1] 0.9991980195 0.0007058178
```

Or use the `get_gender_nn` function directly:

``` r
get_gender_nn("Zusjane")
#> [1] "Female"
get_gender_nn(c("Maria", "Joao"), prob = TRUE)
#> [1] 0.9993317723 0.0007058178
```

### Brazilian state abbreviations

The `genderBR` package relies on Brazilian state abbreviations
(acronyms) to filter results. To get a complete dataset with the full
name, IBGE code, and abbreviations of all 27 Brazilian states, use the
`get_states` function:

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

### Geographic distribution of Brazilian first names

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

Internally, `genderBR` uses the
[data.table](https://cran.r-project.org/package=data.table) backend for
joins and merges. This keeps user-facing outputs as base data.frames
while speeding up repeated lookups for large vectors of names (mainly
when aggregating duplicates before querying the IBGE API or matching
against the internal dataset).

### Benchmarks

The three backends (internal dataset, IBGE API, and neural network)
differ in speed. Here is a comparison using 20 common names:

``` r
nomes <- c(
  "João", "Maria", "Pedro", "Ana", "Lucas",
  "Juliana", "Gabriel", "Fernanda", "Rafael", "Camila",
  "Bruno", "Patrícia", "Carlos", "Larissa", "Felipe",
  "Beatriz", "Gustavo", "Aline", "Rodrigo", "Mariana"
)

bench <- data.frame(
  Method = c("Internal dataset", "Neural network", "IBGE API"),
  Time = c(
    format(system.time(get_gender(nomes))["elapsed"], digits = 3),
    format(system.time(get_gender_nn(nomes))["elapsed"], digits = 3),
    format(system.time(get_gender(nomes, internal = FALSE))["elapsed"], digits = 3)
  )
)

names(bench)[2] <- "Time (seconds)"
knitr::kable(bench, align = "lr")
```

| Method           | Time (seconds) |
|:-----------------|---------------:|
| Internal dataset |          0.002 |
| Neural network   |          0.009 |
| IBGE API         |            1.2 |

For classification tasks with a large number of names, the internal
dataset is the fastest option, followed by the neural network model –
that could be used to classify only the names that are not present in
the internal dataset.

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

## Neural network model

The neural network model used to predict gender from Brazilian first
names is a 2-layer bidirectional GRU with attention pooling (embedding
dim = 64, hidden dim = 192) that operates at the character level. It was
trained on all 141742 names from the IBGE dataset with targets defined
as the probability of a name being female in the 2022 Census (or 2010
when the name is absent from the 2022 Census). The model was trained
using the `luz` framework with an 80/10/10 train/validation/test split
and early stopping. On the held-out test set, it achieves 96.5% accuracy
and 0.110 BCE loss. Model weights and vocabulary are hosted on [Hugging
Face](https://huggingface.co/fmeireles/genderBR) and downloaded on first
use via `download_gender_model()`.

## Ethical considerations

As the description of the package states, `genderBR` infers gender from
Brazilian first names based on data from the IBGE’s Census. In this
sense, the package uses a binary classification derived from state
imposed naming conventions recorded at birth. The package’s
functionality, therefore, is unable to differentiate between non-binary
gender identities or changes in gender identity over time. Because of
that, and in line with recommendations from similar packages (e.g.,
[`gender`](https://github.com/lmullen/gender)), users should avoid using
`genderBR` to impose binary classifications on individuals or in
contexts where misclassification may lead to harm or discrimination
against groups. Instead, the package works better as an estimator for
aggregate, large populations – such as the proportion of female partisan
affiliates in the whole country. Even then, `genderBR` should be
considered a last resort tool to be used only when self-identified
gender data is lacking and inferring it from first names does not pose
risks to groups under study.

## Author

[Fernando Meireles](https://fmeireles.com)
