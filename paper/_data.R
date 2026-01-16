# Obtain validation data

library(tidyverse)
library(electionsBR)


# Get data on running candidates in the 2024 municipal elections
candidates <- elections_tse("candidate", year = 2024) %>%
    select(name = NM_CANDIDATO, reported_gender = DS_GENERO)
    
# Exclude 46 entries with undisclosed gender
candidates <- candidates %>%
    filter(reported_gender != "NÃO DIVULGÁVEL")


# Export data
saveRDS(candidates, file = "paper/candidates_2024.rds")
