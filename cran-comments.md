## Test environments
* Windows 10 (personal computer), R 3.3.2 
* Ubuntu 12.04.5 LTS (on travis-ci), R 3.3.2
* Windows server 2012 R2 x64 (on appveyor), 3.3.3 Patched
* Win-builder (release and devel)

## R CMD check results

0 errors | 0 warnings | 0 note

* There is one note on win-builder about a possibly mis-spelled word: API. That is not the case.
* On win-builder devel there is one warning related to dplyr package version, "Rcpp (0.12.11) different from Rcpp used to build dplyr (0.12.10)".

## Reverse dependencies

This is a new release, so there are no reverse dependencies.
