This is a minor update of the genderBR package that includes several improvements and, more importantly, support for Brazilian 2022 Census data. Changes in this version include:

- Added support for the 2022 IBGE names API through a new `year` argument in `get_gender`, which allows users to access the most recent data for gender prediction in Brazil for both the national and state levels. Code changes do not break backward compatibility.
- Updated the default year in `get_gender` to 2022.
- Internal dataset `nomes` now provides probabilities for both 2010 and 2022, enabling offline predictions and threshold tuning for either year when `internal = TRUE`.
- Removed the `magrittr` dependency by switching to R's native pipe (requiring R 4.1.0 or higher).
- Replaced `dplyr`/`tibble` joins with a `data.table` backend to speed up internal merges and reduce dependencies.
- Updated and added new tests to cover the new functionality and ensure no errors when using 2022 data.
- Improved documentation and examples to reflect the new functionality and changes.
- Added a new section in the README discussing ethical considerations.

## Test environments

* Fedora 43 (personal computer), R 4.5.2
* GitHub Actions - (ubuntu): release, devel, oldrel-1
* GitHub Actions - (windows-latest): release
* GitHub Actions - (macOS-latest): release

## R CMD check results

0 errors | 0 warnings | 0 note

* There was one NOTE on win-builder: X-CRAN-Comment: Archived on 2021-02-21 for policy violation.
This is a new resubmission that replaces the previous archived version.

## Reverse dependencies

There are no reverse dependencies.
