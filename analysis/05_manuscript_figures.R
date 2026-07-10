library(dplyr)
library(ggplot2)

# Load processed data
meta_clean <- readRDS(
  "processed_data/meta_clean_diversity.rds"
)

dir.create("figures", showWarnings = FALSE)

# Figure 7
figure7 <- ggplot(
  meta_clean,
  aes(
    x = season,
    y = Shannon,
    fill = season
  )
) +
  geom_boxplot(alpha = 0.8) +
  facet_wrap(~ siteID) +
  theme_minimal() +
  labs(
    title = "Seasonal Shannon Diversity by Site",
    x = "Season",
    y = "Shannon Diversity"
  ) +
  theme(
    legend.position = "none"
  )

figure7

ggsave(
  filename = "figures/Figure7.png",
  plot = figure7,
  width = 8,
  height = 6,
  units = "in",
  dpi = 600
)

# Figure 9
pcoa_scores <- meta_clean %>%
  select(
    dnaSampleID,
    siteID,
    season,
    year_adj,
    Shannon,
    richness,
    PC1,
    PC2
  ) %>%
  rename(
    PCoA1 = PC1,
    PCoA2 = PC2
  )

figure9 <- ggplot(
  pcoa_scores,
  aes(
    x = PCoA1,
    y = PCoA2,
    color = season,
    shape = siteID
  )
) +
  geom_point(size = 3, alpha = 0.8) +
  theme_minimal() +
  labs(
    title = "PCoA of Bray-Curtis Dissimilarity",
    x = "PCoA1",
    y = "PCoA2"
  )

figure9

ggsave(
  filename = "figures/Figure9.png",
  plot = figure9,
  width = 8,
  height = 6,
  units = "in",
  dpi = 600
)