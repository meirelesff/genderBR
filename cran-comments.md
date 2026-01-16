This is a patch intended to fix a minor issue in the main code that was found after the previous release.

## Test environments

* Fedora 43 (personal computer), R 4.5.2
* GitHub Actions - (ubuntu): release, devel, oldrel-1
* GitHub Actions - (windows-latest): release
* GitHub Actions - (macOS-latest): release

## R CMD check results

0 errors | 0 warnings | 0 note

* There is one NOTE on CRAN Package Check Results online for version 1.1.2: r-devel-linux-x86_64-fedora-gcc: "Namespace in Imports field not imported from: ‘purrr’". This is a false positive, as the package does import and use functions from purrr in 'r/utils.R'.

## Reverse dependencies

There are no reverse dependencies.
