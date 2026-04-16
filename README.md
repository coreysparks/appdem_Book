# Applied Demographic Data Analysis

**Corey S. Sparks, PhD**  
Department of Demography, University of Texas at San Antonio  
[corey.sparks.utsa@gmail.com](mailto:corey.sparks.utsa@gmail.com)

---

## About This Book

*Applied Demographic Data Analysis* is an open-access, reproducible textbook aimed at demographers, social scientists, and public health researchers who need practical training in statistical methods and data analysis using R. The book emphasizes methods that are common in demographic practice but often absent from standard social science statistics curricula — complex survey data, place-based modeling, and individual-level event history analysis.

The book is written for researchers who work with real-world data: stratified samples, hierarchically structured observations, categorical and count outcomes, and survival-time data. It is explicitly applied in orientation, grounding every method in worked examples with publicly available demographic datasets.

The rendered book is available at: **[https://coreysparks.github.io/appdem_Book](https://coreysparks.github.io/appdem_Book)**

---

## Contents

**Chapter 1 — Introduction to R**  
An introduction to R and RStudio for researchers new to programming. Covers the RStudio interface, R data types, vectors, dataframes, packages, and the tidyverse. Includes descriptive statistics, frequency tables, and data visualization with ggplot2.

**Chapter 2 — Survey Data Analysis**  
Covers the fundamentals of complex survey design and weighted analysis in R using the `survey` and `srvyr` packages. Topics include stratified and cluster sampling, replicate weights (BRR, jackknife), weighted descriptive statistics, and regression modeling with survey data, illustrated with American Community Survey (ACS) IPUMS extracts and the Behavioral Risk Factor Surveillance System (BRFSS).

**Chapter 3 — Macro-Level (Place-Based) Analysis**  
Focuses on regression models for aggregate, place-level demographic outcomes using NHGIS county-level data. Covers ordinary least squares, heteroscedasticity correction, clustered standard errors, weighted least squares, generalized least squares, and data acquisition via `tidycensus` and IPUMS NHGIS.

**Chapter 4 — Micro-Level (Individual-Level) Analysis**  
Covers regression models for individual-level outcomes common in demography: binary logistic regression, proportional odds models for ordinal outcomes, multinomial logistic regression, and Poisson and negative binomial models for counts. Includes discrete-time event history analysis and continuous-time survival analysis using the Cox proportional hazards model, with applications to DHS and BRFSS data.

---

## Data Sources

The book uses several publicly available demographic datasets, all stored locally in the `data/` folder:

- **IPUMS USA** — American Community Survey extract (2008–2012 ACS), used for survey design examples
- **IPUMS NHGIS** — County-level demographic and economic data from the US Census, used for place-based regression
- **BRFSS** — Behavioral Risk Factor Surveillance System (2017 and 2020), used for individual-level regression and event history models
- **DHS** — Demographic and Health Survey household data, used for multilevel and survival models
- **PRB World Population Data Sheet** — Used for introductory data examples

Large files are stored in [Apache Parquet](https://parquet.apache.org/) format for efficient storage and fast loading.

---

## Reproducing the Book

The book is built with [Quarto](https://quarto.org/). To render it locally:

```r
# Install required packages
install.packages(c(
  "tidyverse", "survey", "srvyr", "arrow", "haven", "ipumsr",
  "sf", "tmap", "tidycensus", "tigris", "car", "survival",
  "VGAM", "betareg", "gamlss", "emmeans", "gtsummary",
  "sjPlot", "texreg", "huxtable", "kableExtra", "pander",
  "psych", "Hmisc", "skimr", "stargazer", "patchwork"
))
```

```bash
quarto render
```

The book is automatically rendered and published to GitHub Pages via GitHub Actions on every push to `master`.

---

## License

This book is intended for educational use. Please contact the author for reuse or citation guidance.
