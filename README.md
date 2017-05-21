
<!-- README.md is generated from README.Rmd. Please edit that file -->
genderBR
========

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/genderBR)](https://cran.r-project.org/package=genderBR) [![Package-License](https://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)

`genderBR` predicts gender from Brazilian first names using data from the Instituto Brasileiro de Geografia e Estatistica's 2010 Census [API](http://censo2010.ibge.gov.br/nomes/).

How does it work?
-----------------

`genderBR` has only one function, `get_gender`, that takes a string with a Brazilian name and predicts its gender.

``` r
library(genderBR)

get_gender("João")
#> [1] 0
get_gender("Lucas da Silva")
#> [1] NA
get_gender("ANA MARIA")
#> [1] NA
```

Installing
----------

To install the package development version, use:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("meirelesff/genderBR")
```

Author
------

[Fernando Meireles](http://fmeireles.com)
