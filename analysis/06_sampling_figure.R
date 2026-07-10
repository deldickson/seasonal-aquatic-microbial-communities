###############################################################
# Figure 2: Sample Counts by Year, Season, and Site
###############################################################

library(tidyverse)
library(ggh4x)

# Load imported 16S data
tax_data_16S <- readRDS(
  "processed_data/tax_data_16S.rds"
)

# Create figures folder if needed
dir.create("figures", showWarnings = FALSE)

# Set chronological order
year_order <- c(2018, 2019, 2021, 2022, 2023, 2024)
season_order <- c("Winter", "Spring", "Summer", "Fall")

# Create Figure 2 dataset
fig2_data <- tax_data_16S %>%
  distinct(siteID, year_adj, season, dnaSampleID) %>%
  filter(
    !is.na(siteID),
    !is.na(year_adj),
    !is.na(season),
    year_adj %in% year_order,
    season %in% season_order
  ) %>%
  count(year_adj, season, siteID, name = "Samples") %>%
  mutate(
    year_adj = factor(year_adj, levels = year_order),
    season = factor(season, levels = season_order),
    siteID = factor(siteID, levels = c("LEWI", "POSE"))
  )

# Create exact chronological year-season order
x_order <- unlist(
  lapply(
    year_order,
    function(y) paste(y, season_order, sep = ".")
  )
)

fig2_data <- fig2_data %>%
  mutate(
    year_season = paste(year_adj, season, sep = "."),
    year_season = factor(
      year_season,
      levels = x_order
    )
  ) %>%
  filter(!is.na(year_season))

# Create Figure 2
fig2 <- ggplot(
  fig2_data,
  aes(
    x = year_season,
    y = Samples,
    fill = siteID
  )
) +
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.7,
    na.rm = TRUE
  ) +
  scale_fill_manual(
    values = c(
      "LEWI" = "#1f5a7a",
      "POSE" = "#ed7d31"
    ),
    na.translate = FALSE
  ) +
  scale_x_discrete(
    guide = guide_axis_nested(),
    drop = TRUE,
    na.translate = FALSE
  ) +
  scale_y_continuous(
    breaks = 0:5,
    limits = c(0, 5)
  ) +
  labs(
    title = "Number of Samples Collected, 2019–2024",
    x = NULL,
    y = NULL,
    fill = NULL
  ) +
  theme_classic(base_size = 14) +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      size = 20
    ),
    axis.text.x = element_text(
      angle = 90,
      vjust = 0.5,
      hjust = 1
    ),
    axis.text.y = element_text(size = 12),
    legend.position = "right",
    panel.grid.major.y = element_line(
      colour = "grey85"
    ),
    panel.grid.minor = element_blank()
  )

# Display figure
fig2

# Save as TIFF
ggsave(
  filename = "figures/Figure2.tiff",
  plot = fig2,
  device = "tiff",
  width = 8,
  height = 6,
  units = "in",
  dpi = 600,
  compression = "lzw"
)

# Save as PNG
ggsave(
  filename = "figures/Figure2.png",
  plot = fig2,
  device = "png",
  width = 8,
  height = 6,
  units = "in",
  dpi = 600
)