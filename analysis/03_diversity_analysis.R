library(dplyr)
library(vegan)
library(tibble)

meta_clean <- readRDS("processed_data/meta_clean.rds")
abund_rel_clean <- readRDS("processed_data/abund_rel_clean.rds")
# 9) EDA: Alpha diversity (Shannon) + richness

meta_clean$Shannon  <- diversity(abund_rel_clean, index = "shannon")
meta_clean$richness <- rowSums(abund_rel_clean > 0)

summary(meta_clean$Shannon)
summary(meta_clean$richness)


# 10) EDA: Bray–Curtis + PCoA ordination

bray_clean <- vegdist(abund_rel_clean, method = "bray")

pcoa <- cmdscale(bray_clean, eig = TRUE, k = 2)
meta_clean$PC1 <- pcoa$points[,1]
meta_clean$PC2 <- pcoa$points[,2]


# 11) EDA Plots


# A) Read depth distribution (post-filter)
ggplot(meta_clean, aes(total_reads)) +
  geom_histogram(bins = 30) +
  theme_minimal() +
  labs(title = "Read depth distribution (filtered)", x = "Total reads", y = "Number of samples")

# B) Shannon distribution
ggplot(meta_clean, aes(Shannon)) +
  geom_histogram(bins = 25) +
  theme_minimal() +
  labs(title = "Shannon diversity distribution", x = "Shannon", y = "Number of samples")

# C) Shannon by season
ggplot(meta_clean, aes(season, Shannon)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Shannon diversity by season", x = "Season", y = "Shannon")

# D) Shannon by site
ggplot(meta_clean, aes(siteID, Shannon)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Shannon diversity by site", x = "Site", y = "Shannon")

# E) Shannon by year
ggplot(meta_clean, aes(factor(year_adj), Shannon)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Shannon diversity by year", x = "Year (adjusted)", y = "Shannon")

# F) Richness by season
ggplot(meta_clean, aes(season, richness)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Observed genus richness by season", x = "Season", y = "Genus richness")

# G) PCoA colored by season, shaped by site
ggplot(meta_clean, aes(PC1, PC2, color = season, shape = siteID)) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "PCoA (Bray–Curtis) colored by season", x = "PC1", y = "PC2")

# H) PCoA colored by year
ggplot(meta_clean, aes(PC1, PC2, color = factor(year_adj))) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "PCoA (Bray–Curtis) colored by year", x = "PC1", y = "PC2")


# 12) EDA: Top genera overview (mean relative abundance)

genus_means <- colMeans(abund_rel_clean, na.rm = TRUE)
top_genera <- sort(genus_means, decreasing = TRUE)[1:20]
top_genera

# Optional: top genera by season within each site (mean relative abundance)
top_names <- names(top_genera)

top_long <- genus_counts %>%
  semi_join(meta_clean, by = c("siteID","year_adj","season","dnaSampleID")) %>% # keep filtered samples
  filter(genus %in% top_names) %>%
  group_by(siteID, season, genus) %>%
  summarise(mean_count = mean(count, na.rm = TRUE), .groups = "drop") %>%
  group_by(siteID, season) %>%
  mutate(mean_rel = mean_count / sum(mean_count)) %>%
  ungroup()

ggplot(top_long, aes(season, mean_rel, group = genus)) +
  geom_line() +
  geom_point() +
  facet_grid(siteID ~ genus, scales = "free_y") +
  theme_minimal() +
  labs(title = "Top genera: mean relative abundance by season (within site)",
       x = "Season", y = "Mean relative abundance")


# 13) Objects created (for reference)

# coverage_table    = samples per site/year/season
# meta_clean        = sample metadata + read depth + Shannon + richness + PCoA coords
# abund_rel_clean   = relative abundance matrix (samples × genera)
# bray_clean        = Bray–Curtis distance object
# genus_counts      = long genus counts table



dim(tax_data_16S)

n_distinct(tax_data_16S$dnaSampleID)

n_distinct(tax_data_16S$genus)

unique(tax_data_16S$siteID)

range(tax_data_16S$year_adj)

#Number of samples per year bar graph
meta_clean %>%
  count(year_adj) %>%
  ggplot(aes(factor(year_adj), n)) +
  geom_col(fill = "steelblue") +
  theme_minimal() +
  labs(title = "Microbial Samples Per Year",
       x = "Year",
       y = "Number of Samples")

#Sample per season
meta_clean %>%
  count(season) %>%
  ggplot(aes(season, n)) +
  geom_col(fill = "pink") +
  theme_minimal() +
  labs(title = "Number of Samples per Season",
       x = "Season",
       y = "Number of Samples")
#Sample per site
meta_clean %>%
  count(siteID) %>%
  ggplot(aes(siteID, n)) +
  geom_col(fill = "lightblue") +
  theme_minimal() +
  labs(title = "Number of Samples per Site",
       x = "Site",
       y = "Number of Samples")


## Data Analysis (Alpha & Beta Diversity) written by Delanie, modified by Ella
# Community Matrix 
tax_grouped <- tax_data_16S %>%
  group_by(dnaSampleID, siteID, season, year, genus) %>%
  summarise(count = sum(as.numeric(individualCount)), .groups = "drop")


tax_wide <- tax_grouped %>%
  pivot_wider(
    names_from = genus,
    values_from = count,
    values_fill = 0
  )


meta_data <- tax_wide %>%
  select(dnaSampleID, siteID, season, year) 


community_matrix <- tax_wide %>%
  select(-dnaSampleID, -siteID, -season, -year) %>%
  as.matrix()


rownames(community_matrix) <- tax_wide$dnaSampleID

##Shannon diversity
shannon_values <- diversity(community_matrix, index = "shannon")
#print(shannon_values)

shannon_df <- meta_data %>%
  mutate(shannon = shannon_values)

# Plot by site
ggplot(shannon_df, aes(x = season, y = shannon, fill = season)) +
  geom_boxplot(alpha = 0.8) +
  facet_wrap(~ siteID) +
  theme_minimal() +
  labs(
    title = "Seasonal Shannon Diversity by Site",
    x = "Season",
    y = "Shannon Diversity"
  ) +
  theme(legend.position = "none")


##Bray-Curtis
bray_dist <- vegdist(community_matrix, method = "bray")


## PCoA
pcoa_result <- cmdscale(bray_dist, k = 2, eig = TRUE)


pcoa_scores <- as.data.frame(pcoa_result$points)
colnames(pcoa_scores) <- c("PCoA1", "PCoA2")


pcoa_scores <- pcoa_scores %>%
  mutate(dnaSampleID = rownames(pcoa_scores)) %>%
  left_join(shannon_df %>% select(dnaSampleID, siteID, season, year),
            by = "dnaSampleID")
# Overall plot
ggplot(pcoa_scores, aes(x = PCoA1, y = PCoA2, color = season, shape = siteID)) +
  geom_point(size = 3, alpha = 0.8) +
  theme_minimal() +
  labs(
    title = "PCoA of Bray-Curtis Dissimilarity",
    x = "PCoA1",
    y = "PCoA2"
  )
# Faceted by year 
ggplot(pcoa_scores, aes(x = PCoA1, y = PCoA2, color = season)) +
  geom_point(size = 3, alpha = 0.8) +
  facet_wrap(~ year) +
  theme_minimal() +
  labs(
    title = "Seasonal Structure Within Each Year"
  )


##Variance 
eigenvalues <- pcoa_result$eig
variance_explained <- eigenvalues / sum(eigenvalues[eigenvalues > 0])

variance_table <- data.frame(
  Axis = c("PCoA1", "PCoA2"),
  Percent_Variance_Explained = round(variance_explained[1:2] * 100, 2)
)

variance_table

saveRDS(meta_clean, "processed_data/meta_clean_diversity.rds")
saveRDS(bray_clean, "processed_data/bray_clean.rds")
saveRDS(pcoa, "processed_data/pcoa.rds")
saveRDS(pcoa_scores, "processed_data/pcoa_scores.rds")

write.csv(
  variance_table,
  "processed_data/pcoa_variance_explained.csv",
  row.names = FALSE
)