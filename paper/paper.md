
---
title: 'genderBR: Predicting gender from Brazilian first names'
tags:
  - R
  - gender inference
  - Brazil
  - census data
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

Quantitative social science research frequently relies on large-scale administrative or scraped datasets that lack demographic indicators -- including gender. While methods exist to impute gender from first names, existing tools predominantly depend on Anglocentric populations or commercial datasets. `genderBR` is an R package designed as an alternative to infer gender from Brazilian first names using official data from the Brazilian Institute of Geography and Statistics (IBGE) for both the 2010 and 2022 Censuses [@IBGE2022]. The package offers a fast offline mode via an internal dataset and an online mode that queries IBGE's API and supports state-level filters, allowing predictions to be calibrated to reflect both temporal and regional variations in naming-gender associations. Using large scale census microdata, `genderBR` thus enables academics, journalists, and practitioners to obtain binary gender predictions or probabilities to study aggregate demographic groups in a reproducible manner. 

# Statement of need

A common challenge in quantitative social science is the absence of demographic information in large-scale datasets. For instance, researchers frequently utilize administrative records such as electoral rolls, or scraped web data to study representation, labor market discrimination, or political behavior that lack self-reported gender indicators, which are essential for understanding topics as important as social inequalities or descriptive representation. Therefore, scholars often resort to imputing gender based on first names, exploiting naming conventions that correlate with a binary gender classification.

Despite the limitations of this approach, deriving gender labels from first names remains a popular method in the absence of direct measures. For example, solutions such as @genderAPI, @Namsor, and @genderize offer commercial APIs that allows users to query first names and obtain gender predictions based on large proprietary datasets. In the open-source domain, packages such as `gender` [@Mullen2016] rely on historical datasets from the United States or Europe, using counts of names by gender from sources like the US Social Security Administration to predict gender for English names. Yet, while useful for Anglophone contexts, these tools are not well-suited for the study of Latin American populations due to cultural and linguistic differences in naming conventions. In a comparative assessment, @vanhelene2024inferring show that these tools are highly accurate for Western populations, with both @genderAPI and @genderize achieving accuracies exceeding 98% and aggregate accuracy around 96% to a global dataset of mostly Western names. However, their performances dropped below 82% for names from South Korea, China, Singapore, and Taiwan. The open-source alternative, the `gender` package [@Mullen2016], achieved an even lower overall accuracy, of only 79.8% using the IPUMS method and 85.7% using US Social Security Administration data.

`genderBR` addresses theses gaps by offering an open-source solution to tackle this problem specifically for Brazil, whose population exceeds 200 million people and represents the largest Portuguese-speaking country in the world. The package is grounded in IBGE census microdata, which provides and standardizes Brazilian first names occurrence counts by gender -- a binary classification based on self-reported data collected in the census. The package supports both national and state-level predictions for 2010 and 2022, and exposing probabilities alongside hard labels. Unlike API-based solutions that rely on opaque or non-representative web data, `genderBR` leverages official census data to ensure accurate and reproducible gender inference for Brazilian populations.

# Method and Usage

`get_gender` is the package's core function: it cleans names (lowercases, strips accents using `ASCII//TRANSLIT`, keeps only the first token), aggregates duplicates to reduce API calls, and returns either binary labels or female-use probabilities. Users can switch between census years (`year = 2010` or `2022`), request probabilities (`prob = TRUE`), tune decision thresholds (`threshold`, default is 0.9), and choose the data source. When `internal = TRUE` and no state is provided, results come from the bundled IBGE-derived probability table (`nomes`), enabling fully offline and reproducible analyses. When a state is supplied or `internal = FALSE`, the function queries IBGE's API and, if the input vector is large, inserts small pauses to respect rate limits.

## Examples

To obtain national predictions with binary labels for a vector of names, use the following code:

```{r}
library(genderBR)

# Return labels
get_gender(c("João", "Ana"))

# Return probabilities of given names being female
get_gender(c("João", "Ana"), prob = TRUE)
```

To obtain the probabilities calibrated to specific period and Brazilian states, the main function can be used as follows:

```{r}
# Probabilities for two "Darcy" in different states in 2010
name <- rep("Ariel", 3)
states <- c("RJ", "RS", "SP")
get_gender(name, prob = TRUE, state = states, year = 2010)

# Using the `get_states` helper to get all state codes
states <- get_states()
name <- rep("Darcy", nrow(states))

# Get probabilities for "Darcy" in all states for 2010 and 2022
states$prob_10 <- get_gender(name, prob = TRUE, state = states$abb, year = 2010)
states$prob_22 <- get_gender(name, prob = TRUE, state = states$abb, year = 2022)
head(states)
```

Internally, `genderBR` computes $p_\text{female} = \frac{f}{f + m}$ for each name (and state, when provided), where $f$ and $m$ are IBGE female and male counts. The returned label applies the rule: female if $p_\text{female} > \tau$, male if $p_\text{female} < 1 - \tau$, and unknown otherwise, with the default $\tau = 0.9$. This decision treshold is deterministic, but users can tune $\tau$ to trade off precision and coverage for their applications.

# Ethical Considerations

While `genderBR` provides a practical solution for imputing gender from first names, it is crucial to acknowledge the implications of using this approach. By relying on a binary gender classification derived from naming conventions recorded at birth, the provided method is unable to differentiate between non-binary gender identities or changes in gender identity over time. In line with recommendations from similar packages [@Mullen2016], users should avoid using `genderBR` to impose binary classifications to individuals or in contexts where misclassification may lead to harm or discrimination against groups. Instead, the package should be regarded as an estimator for aggregate, large populations -- to approximate the proportion of female partisan affiliates in the whole country, for example. In sum, `genderBR` should be viewed as a last resort tool when self-identified gender data is lacking and infering it from first names does not pose risks to groups under study.

# Acknowledgements

I thank the Brazilian Institute of Geography and Statistics for providing the public census name data and API that make this work possible, and the `R` and academic community that contributed to the development of the package with feedback and suggestions.

# References
