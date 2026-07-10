# Libraries

# install.packages(c("dplyr","tidyr","stringr","readr","ggplot2","vegan","tibble"))
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(ggplot2)
library(vegan)
library(tibble)


# 1) Paths / settings
setwd("/Users/delanie/Capstone TODIS Project")
base_dir  <- "NEON_tax-microbe-surfacewater"  # folder containing unzipped NEON files
sites_keep <- c("POSE","LEWI")
years_keep <- c(2019, 2021, 2022, 2023, 2024)
min_reads  <- 5000


# 2) Locate 16S taxon tables (“*_16S_map.csv”)

all_files <- list.files(base_dir, recursive = TRUE, full.names = TRUE)

taxon_16S_files <- all_files[
  grepl("_16S_map\\.csv$", all_files, ignore.case = TRUE) &
    grepl("/NEON\\.D02\\.(POSE|LEWI)\\.", all_files) &
    grepl("\\.(2018|2019|2020|2021|2022|2023|2024)-\\d{2}\\.", all_files)
]

stopifnot(length(taxon_16S_files) > 0)


# 3) File metadata (site, year, month, season, year_adj)

file_info <- tibble(
  file = taxon_16S_files,
  year_month = str_extract(taxon_16S_files, "\\d{4}-\\d{2}")
) %>%
  mutate(
    year  = as.integer(substr(year_month, 1, 4)),
    month = as.integer(substr(year_month, 6, 7)),
    season = case_when(
      month %in% c(12, 1, 2)  ~ "Winter",
      month %in% c(3, 4, 5)   ~ "Spring",
      month %in% c(6, 7, 8)   ~ "Summer",
      month %in% c(9, 10, 11) ~ "Fall",
      TRUE ~ NA_character_
    ),
    year_adj = ifelse(month == 12, year + 1, year),
    siteID = str_extract(file, "(?<=/NEON\\.D02\\.)[A-Z0-9]+(?=\\.)")
  ) %>%
  filter(siteID %in% sites_keep, year_adj %in% years_keep)

stopifnot(nrow(file_info) > 0)


# 4) Load + combine

read_taxon_file <- function(path, year, month, season, year_adj, siteID) {
  df <- read_csv(path, show_col_types = FALSE)
  df$year <- year
  df$month <- month
  df$season <- season
  df$year_adj <- year_adj
  df$siteID <- siteID
  df
}

tax_data_16S <- bind_rows(lapply(seq_len(nrow(file_info)), function(i) {
  read_taxon_file(
    path     = file_info$file[i],
    year     = file_info$year[i],
    month    = file_info$month[i],
    season   = file_info$season[i],
    year_adj = file_info$year_adj[i],
    siteID   = file_info$siteID[i]
  )
}))

# Defensive filter (16S should already be bacteria/archaea)
if ("domain" %in% names(tax_data_16S)) {
  tax_data_16S <- tax_data_16S %>% filter(domain %in% c("Bacteria","Archaea"))
}

# Required columns check
required_cols <- c("dnaSampleID","genus","individualCount","siteID","year_adj","season")
missing_cols <- setdiff(required_cols, names(tax_data_16S))
stopifnot(length(missing_cols) == 0)

# Create folder (only if it doesn't already exist)
dir.create("processed_data", showWarnings = FALSE)

# Save object
saveRDS(tax_data_16S, "processed_data/tax_data_16S.rds")