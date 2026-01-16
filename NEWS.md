# genderBR 1.2.1


# genderBR 1.2.0

- Added support for IBGE's 2022 census data API, updating the default year to 2022 in `get_gender`.
- Internal dataset `nomes` now includes probabilities for 2010 and 2022 (`prob_fem10`, `prob_fem22`) and is used when `internal = TRUE`. This data covers 141,742 unique Brazilian first names.
- Replaced all uses of `%>%` with the base `|>` operator, thus removing the `magrittr` dependency (requires R 4.1.0 or higher).
- Switched data manipulation backend to `data.table` for faster joins and removed `dplyr`/`tibble` dependencies.
- Updated tests to cover new features and changes.
- Added a section on ethical considerations in the README.


# genderBR 1.1.1

In this version, a few improvements and bug fixed were introduced. Most important, connection errors now return informative messages to users.

- `map_gender` and `get_gender` now return informative error messages when reach timeout
- `get_gender` function better handles non-ASCII characters
- Documentation expanded to notify users that IBGE's API does not work with UTF-8 special characters
- Magritte's pipe exported


# genderBR 1.1.0

In this minor release, the genderBR package was improved in two ways. First, bugs and some minor issues were fixed, making the package's functions more stable. Second, the package now contains an internal dataset with all the names reported by the IBGE's Census that is used by the get_gender function to predict gender from Brazilian first names. Therefore, classifying a vector with more than 1,000 names takes no more than a few seconds now. Overall, these are the improvements:

* Added a `NEWS.md` file to track changes to the package.
* Added input checks to the `get_gender` function.
* Reduce the time between requests to the IBGE's Census API.
* Fixed a problem on vectorization in the internal `round_guess` funcion.
* Included an internal dataset with all Brazilian first names and their predicted gender extracted from the IBGE.
* Update the `get_gender` function to work with internal data.



