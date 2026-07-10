library(dplyr)
library(tidyr)
library(vegan)

tax_data_16S <- readRDS("processed_data/tax_data_16S.rds")

min_reads <- 5000

# 5) EDA Table 1: Sampling coverage (counts of samples by site/year/season)

coverage_table <- tax_data_16S %>%
  distinct(siteID, year_adj, season, dnaSampleID) %>%
  count(siteID, year_adj, season) %>%
  arrange(siteID, year_adj, season)

coverage_table


# 6) Build community matrix at genus level (sample × genus)

genus_counts <- tax_data_16S %>%
  group_by(siteID, year_adj, season, dnaSampleID, genus) %>%
  summarise(count = sum(individualCount, na.rm = TRUE), .groups = "drop")

community_matrix <- genus_counts %>%
  pivot_wider(names_from = genus, values_from = count, values_fill = 0)

meta <- community_matrix %>% select(siteID, year_adj, season, dnaSampleID)
abund <- community_matrix %>% select(-siteID, -year_adj, -season, -dnaSampleID)
abund_matrix <- as.matrix(abund)


# 7) EDA: Read depth & filtering low-depth samples

meta$total_reads <- rowSums(abund_matrix)

# Read depth summaries (before filtering)
summary(meta$total_reads)

# Filter
keep <- meta$total_reads >= min_reads
meta_clean <- meta[keep, , drop = FALSE]
abund_matrix_clean <- abund_matrix[keep, , drop = FALSE]

# Summaries (after filtering)
summary(meta_clean$total_reads)
sum(!keep)  # number removed


# 8) Relative abundance transform (recommended for composition EDA)

abund_rel_clean <- abund_matrix_clean / rowSums(abund_matrix_clean)
summary(rowSums(abund_rel_clean))

saveRDS(genus_counts, "processed_data/genus_counts.rds")
saveRDS(meta_clean, "processed_data/meta_clean.rds")
saveRDS(abund_matrix_clean, "processed_data/abund_matrix_clean.rds")
saveRDS(abund_rel_clean, "processed_data/abund_rel_clean.rds")
