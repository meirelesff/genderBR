This is a new version of the genderBR package that includes several improvements and new features. The most notable changes in this release are:

- Added support for the 2022 IBGE names API through a new `year` argument in `get_gender`, which allows users to access the most recent data for gender prediction in Brazil
- Internal dataset `nomes` now provides probabilities for both 2010 and 2022, enabling offline predictions for either year when `internal = TRUE`.
- Removed the `magrittr` dependency by switching to R's native pipe.
- Replaced `dplyr`/`tibble` joins with a `data.table` backend to speed up internal merges.


## Test environments

* Ubuntu 20.04 (personal computer), R 4.0.5
* Windows server 2012 R2 x64 (on Appveyor), 4.0.3 Patched
* GitHub Actions - (ubuntu-20.04): release, devel
* GitHub Actions - (windows-latest): release
* GitHub Actions - (macOS-latest): release

## R CMD check results

0 errors | 0 warnings | 0 note

* There was one NOTE on win-builder: X-CRAN-Comment: Archived on 2021-02-21 for policy violation.
This is a new resubmission that replaces the previous archived version.

## Reverse dependencies

There are no reverse dependencies.
