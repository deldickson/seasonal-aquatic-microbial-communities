# Analysis

This folder contains the R scripts used to process, analyze, and visualize freshwater microbial community data from the National Ecological Observatory Network (NEON).

The workflow is organized into sequential scripts that reproduce the analyses and figures presented in the manuscript.

---

## Workflow

### 01_import_data.R

- Imports NEON 16S rRNA taxonomy data
- Assigns study site, sampling season, and adjusted year
- Combines individual monthly datasets into a single analysis dataset

---

### 02_quality_control.R

- Constructs the genus-level community matrix
- Calculates sequencing depth
- Removes low-depth samples (< 5,000 reads)
- Converts abundance data to relative abundance

---

### 03_diversity_analysis.R

Calculates ecological diversity metrics, including:

- Shannon diversity (Alpha Diversity)
- Observed genus richness
- Bray–Curtis dissimilarity
- Principal Coordinates Analysis (PCoA)

---

### 04_statistical_analysis.R

Performs statistical analyses used in the manuscript, including:

- Factorial ANOVA
- Tukey's HSD post hoc comparisons
- PERMANOVA
- Tests of multivariate dispersion

---

### 05_manuscript_figures.R

Generates the primary manuscript figures:

- Figure 7 – Seasonal Shannon Diversity by Site
- Figure 9 – PCoA of Bray–Curtis Dissimilarity

---

### 06_sampling_figure.R

Generates Figure 2, illustrating sampling effort across years, seasons, and study sites.

---

## Software

Analyses were performed in **R** using:

- dplyr
- tidyr
- ggplot2
- vegan
- readr
- stringr
- tibble
- ggh4x

---

## Reproducibility

Scripts are intended to be run in numerical order.

The workflow begins with importing raw NEON data and concludes with statistical analyses and publication-quality figures.
