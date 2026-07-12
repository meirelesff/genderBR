# genderBR 1.4.0

This is a new version that introduces a new feature: asymmetrical thresholds for gender classification. In the previous versions, users could set a single threshold to classify names as female or male -- and they could overlap if the threshold was too low. Now, users can set a different threshold for each sex, and there is a new check to prevent overlapping thresholds. The release also includes other improvements and bug fixes.

- The `threshold` argument of `get_gender()` and `get_gender_nn()` now accepts a vector with two values, allowing users to set a different threshold for each sex: the first value is used to classify females and the second, males (e.g., `threshold = c(0.9, 0.8)`). The two values can also be named, in any order (`c(Female = 0.9, Male = 0.8)` or `c(F = 0.9, M = 0.8)`). A single value keeps setting a symmetrical threshold, as before.
- Thresholds that sum to less than 1 are now rejected with an informative error. These values make the female and male bands overlap, so a name could be classified as both. This also applies to a single `threshold` below 0.5, which was silently accepted before and gave inconsistent results between `get_gender()` and `get_gender_nn()`.
- Added an `nn_size` argument to `get_gender_nn()` and `get_gender(nn = TRUE)` that splits a large input vector of names into batches. This keeps avoids out-of-memory crashes on big vectors. Defaults to `NULL` (all names classified in a single pass).
- Added a `device` argument to `get_gender_nn()` and `get_gender(nn = TRUE)` to run neural network inference on a GPU (`"cuda"` or `"mps"`) instead of the default CPU for faster predictions.
- Fixed a vocabulary mismatch in the neural network encoder: characters not in the model vocabulary were mapped to `<PAD>` instead of the `<UNK>`. Names containing rare characters are now handled correctly.
- Moved `torch` from `Imports` to `Suggests`. The neural network model is now built only when the NN backend (`get_gender_nn()` or `get_gender(nn = TRUE)`) is used. A clear message tells users to install `torch` when it is not available. The default methods no longer require `torch`.
- Added new tests for the new features and fixes.


# genderBR 1.3.0

This is a new version of the genderBR package that includes a new function: `get_gender_nn()`, which uses a character-level neural network to predict gender from Brazilian first names. This model can generalise to names not present in the IBGE census dataset, so it can be used as a complement to the existing functionality in the package. The release also includes some improvements, tests, and documentation updates.

- `get_gender_nn()` is a new exported function that uses a character-level neural network to predict gender from Brazilian first names. Unlike `get_gender()`, this function can generalise to names not present in the IBGE census dataset.
- Added `clear_nn_cache()` to manage the in-memory model cache.
- Added `download_gender_model()`, an internal function that handles downloading and caching the neural network model weights and vocabulary from Hugging Face.
- Replaced `iconv()` with `chartr()` for stripping accents in name cleaning. The previous approach relied on `iconv(name, to = "ASCII//TRANSLIT")`, which is platform-dependent and returns `NA` on macOS for accented names (e.g., "joão"). The `encoding` argument in `get_gender`, `get_gender_nn`, and `map_gender` is now deprecated and will be removed in a future version.
- Improved test coverage for the new function and edge cases.
- Added `torch` to `Imports`; `luz` and `httr2` to `Suggests`.


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
* Fixed a problem on vectorization in the internal `round_guess` function.
* Included an internal dataset with all Brazilian first names and their predicted gender extracted from the IBGE.
* Update the `get_gender` function to work with internal data.



