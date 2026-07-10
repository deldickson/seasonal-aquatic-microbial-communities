library(vegan)

meta_clean <- readRDS("processed_data/meta_clean_diversity.rds")
bray_clean <- readRDS("processed_data/bray_clean.rds")
## Statistical tests
meta_clean$season <- as.factor(meta_clean$season)
meta_clean$siteID <- as.factor(meta_clean$siteID)
meta_clean$year_adj <- as.factor(meta_clean$year_adj)

# Alpha diversity / Shannon ANOVA
anova_result <- aov(Shannon ~ year_adj * siteID * season, data = meta_clean)
summary(anova_result)

# Post-hoc test
TukeyHSD(anova_result, "season")
TukeyHSD(anova_result, "year_adj")

# Beta diversity / Bray-Curtis PERMANOVA
adonis2(bray_clean ~ season, data = meta_clean)
adonis2(bray_clean ~ siteID, data = meta_clean)
adonis2(bray_clean ~ year_adj, data = meta_clean)
adonis2(bray_clean ~ season + siteID + year_adj, data = meta_clean)

# Dispersion check
dispersion_season <- betadisper(bray_clean, meta_clean$season)
anova(dispersion_season)
dispersion_year <- betadisper(bray_clean, meta_clean$year_adj)
anova(dispersion_year)
dispersion_site <- betadisper(bray_clean, meta_clean$siteID)
anova(dispersion_site)

permanova_season <- adonis2(
  bray_clean ~ season,
  data = meta_clean
)

permanova_site <- adonis2(
  bray_clean ~ siteID,
  data = meta_clean
)

permanova_year <- adonis2(
  bray_clean ~ year_adj,
  data = meta_clean
)

permanova_full <- adonis2(
  bray_clean ~ season + siteID + year_adj,
  data = meta_clean
)

capture.output(
  summary(anova_result),
  TukeyHSD(anova_result, "season"),
  TukeyHSD(anova_result, "year_adj"),
  permanova_season,
  permanova_site,
  permanova_year,
  permanova_full,
  anova(dispersion_season),
  anova(dispersion_year),
  anova(dispersion_site),
  file = "processed_data/statistical_results.txt"
)