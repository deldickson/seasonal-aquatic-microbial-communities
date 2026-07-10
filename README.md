# Seasonal Patterns in Aquatic Microbial Communities Across Freshwater Ecosystems

Graduate capstone project completed as part of the Master of Science in Biological Data Science program at Arizona State University.

---

## Project Overview

Freshwater microbial communities play a critical role in nutrient cycling and ecosystem function, yet the consistency of seasonal microbial turnover across years and between nearby freshwater systems remains poorly understood.

This project evaluated seasonal patterns in microbial diversity and community composition using publicly available 16S rRNA sequencing data from the National Ecological Observatory Network (NEON). Analyses were performed using samples collected from two freshwater streams in Virginia: Posey Creek (POSE) and Lewis Run (LEWI).

---

## Research Objectives

This study addressed two primary questions:

- Does microbial alpha diversity differ by season and site?
- Do freshwater microbial communities exhibit repeatable seasonal community structure across years?

---

## Study Sites

- **Posey Creek (POSE)**
- **Lewis Run (LEWI)**

Data Source:

**NEON Data Product DP1.20141.002**

Surface Water Microbe Community Taxonomy

---

## Methods

The analytical workflow included:

- Data cleaning and quality control
- Community matrix construction
- Relative abundance calculations
- Shannon Diversity Index (Alpha Diversity)
- Bray–Curtis Dissimilarity (Beta Diversity)
- Principal Coordinates Analysis (PCoA)
- PERMANOVA
- Statistical analyses performed in R

---

## Key Results

After quality filtering, the final dataset contained:

- 106 microbial samples
- 3,752 microbial genera

Major findings included:

- Significant differences in alpha diversity by site, year, and season.
- Higher Shannon diversity at POSE compared to LEWI.
- Significant differences in community composition by season and site.
- Seasonal effects explained only a portion of microbial community variation, suggesting additional environmental drivers influence community structure.

---

## Repository Structure

```
analysis/
```

R scripts for data processing, statistical analyses, and figure generation.

```
figures/
```

Publication-quality figures used in the manuscript.

```
manuscript/
```

Final capstone manuscript.

```
data/
```

Documentation describing the publicly available NEON data source.

---

## Skills Demonstrated

- R Programming
- Statistical Analysis
- Data Cleaning
- Data Visualization
- Community Ecology
- Microbial Ecology
- Reproducible Research
- Scientific Writing

---

## Authors

- Kathryn Boyd
- Delanie Dickson
- Azriella Turkdogan
- Tyler Jernigan

---

## Repository Note

This repository highlights the analytical workflow and project materials developed as part of a collaborative graduate capstone completed at Arizona State University. The manuscript represents the combined contributions of all project authors.
