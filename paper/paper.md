
---
title: 'genderBR: Predicting gender from Brazilian first names'
tags:
  - R
  - gender inference
  - Brazil
  - census data
  - names
authors:
  - name: Fernando Meireles
    orcid: 0000-0002-7027-2058
    affiliation: "1"
    corresponding: true
affiliations:
 - name: Instituto de Estudos Sociais e Politicos, Universidade do Estado do Rio de Janeiro, Brazil
   index: 1
date: 13 January 2026
bibliography: paper.bib
---

# Summary

`genderBR` is an R package that predicts gender from Brazilian first names using official data from the Instituto Brasileiro de Geografia e Estatistica (IBGE) for both the 2010 and 2022 Censuses [@IBGE2022]. The package offers a fast offline mode via an internal dataset and an online mode that queries IBGE's API, supports state-level filters, and exposes a simple interface through `get_gender`, `map_gender`, and `get_states`. By combining reproducible census data with vectorized lookups and data.table joins, `genderBR` enables social science, public health, and survey researchers to add gender labels or probabilities to large Brazilian name lists with minimal effort [@genderBR].

# Statement of need

Research on Brazilian populations frequently requires gender labels to audit representation, balance survey samples, or study demographic trends. Existing gender inference tools such as `gender` [@Mullen2016] rely on historical datasets from the United States or Europe and perform poorly for Portuguese names and diacritics. Commercial APIs provide limited transparency, inconsistent coverage of Brazilian data, and no state-level detail. `genderBR` addresses this gap by delivering a free, open-source solution grounded in IBGE census microdata, offering both national and state-level predictions for 2010 and 2022, and exposing probabilities alongside hard labels. The package is aimed at researchers, journalists, and practitioners working with Brazilian administrative or survey data who need a documented, reproducible, and locally accurate approach to gender inference.

# State of the field

The `gender` package [@Mullen2016] and other general-purpose services estimate gender using historical Anglo-centric datasets or crowd-sourced corpora. These tools underperform for Brazilian names because they lack contemporary Portuguese spellings, handle accents inconsistently, and provide no federative breakdowns. `genderBR` builds directly on IBGE's official census series [@IBGE2022], adds an internal probability table for offline use, and supplies a state filter that re-queries the API when regional variation matters. This fills a distinct niche where existing packages either cannot ingest the IBGE endpoints or do not expose Brazilian-specific probabilities, making `genderBR` the appropriate choice when working with Brazilian populations.

# Software design

`genderBR` centers on three user-facing functions. `get_gender` cleans input strings, normalizes encodings, aggregates duplicates, and returns either gender labels or female-use probabilities based on a configurable threshold. When `internal = TRUE` and no state is provided, it reads from the bundled `nomes` dataset (2010 and 2022 probabilities); otherwise it calls IBGE's API with robust error handling and optional pauses to respect rate limits. `map_gender` retrieves state-level counts and per-capita rates, while `get_states` returns canonical abbreviations and IBGE codes for validation and convenience. Internally, the package uses `data.table` for fast joins, `httr` and `jsonlite` for HTTP and parsing, and `purrr::possibly` to guard against transient API failures. Input validation and deterministic rounding are centralized in helper utilities (e.g., `clean_names`, `round_guess`, `state2code`), and automated tests in `tests/testthat` cover API plumbing, input handling, and offline predictions. Continuous integration (R CMD check) and coverage reporting (Codecov) keep the CRAN and GitHub releases aligned with current R tooling.

# Research impact statement

`genderBR` makes recent IBGE gender distributions immediately usable for reproducible research pipelines. The inclusion of the 2022 census probabilities enables up-to-date audits of gender balance in administrative datasets, while the state-level API path supports regional analyses not feasible with global tools. Open distribution on CRAN and GitHub, GPL (>= 2) licensing, and maintained automated checks lower the barrier for adoption in survey operations and academic workflows. Because the package bundles the offline probability table, analyses remain reproducible even when API access is intermittent, and test coverage provides assurance when integrating into larger R projects. Collectively these design choices position `genderBR` as a sustainable research asset for Brazilian demographic and social science studies [@genderBR].

# AI usage disclosure

No generative AI tools were used in developing the software or its documentation. This manuscript text was drafted with assistance from GitHub Copilot/ChatGPT and will be reviewed and verified by the authors.

# Acknowledgements

We thank the Instituto Brasileiro de Geografia e Estatistica for providing the public census name data and API that make this work possible, and the R community for packages that simplify HTTP, parsing, and testing workflows.

# References
