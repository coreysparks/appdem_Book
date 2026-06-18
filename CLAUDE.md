# Memory

_Last updated: 2026-04-09_

## Me
**Corey Sparks** — Senior Research Scientist / Faculty, Demographer  
Email: corey.sparks.utsa@gmail.com (UTSA affiliation)  
PhD in Demography

## Role & Work
Academic research and teaching. Primary work involves demographic data analysis, statistical modeling, and writing/teaching materials.

## Tools & Stack
- **Primary languages:** R / RStudio, SQL
- **Learning:** Python (wants to use more)
- **Version control:** Git / GitHub
- **Connected repos:** appdem_Book, DEM7223, DEM7283

## Preferences
- Professional tone
- No bullet points or dashes in responses — use commas or semicolons instead
- Prefers prose over lists
- Code primarily in R and SQL; open to Python

## People
| Who | Role |
|-----|------|
| (Add collaborators as we work) | |

## Terms
| Term | Meaning |
|------|---------|
| (Add acronyms and shorthand as we encounter them) | |

## Projects
| Name | What |
|------|------|
| appdem_Book | Applied demography book (GitHub repo) |
| DEM7223 | Course or project repo |
| DEM7283 | Course or project repo |

---

# Book Scope: appdem_Book

_Last updated: 2026-06-18_

## Overview

This is an applied demography textbook written in Quarto (`.qmd` files), aimed at graduate students and professionals in demography and related social science fields. The book's central argument is that demographers need specialized statistical training beyond standard social science methods because their work requires population-level inference from complex survey designs, and because demographic data frequently take non-standard forms (counts, categorical outcomes, hierarchically structured observations, longitudinal records, spatially referenced data).

All code examples are written in R. The book deliberately avoids mathematical proofs and algebraic exposition in favor of applied, reproducible demonstrations using real demographic datasets.

## Audience

Students and working researchers with some prior statistics exposure who need to develop a demographer's analytic toolkit. The book assumes familiarity with basic regression but not with survey-weighted estimation, generalized linear models, or event history methods.

## Chapters and Content

**Preface / index.qmd** — Motivates the book with three core reasons demographers need specialized methods: making population-level inferences beyond the sample, working with complex survey designs rather than simple random samples, and handling the variety of "weird" data types common in the field. Defines demography, applied demography, and makes the case for R as the primary tool.

**Introduction to R / rintro.qmd** — Introduces R and RStudio for readers new to the language; covers history, comparison to SAS/SPSS/Stata, and installation setup.

**Survey Data Analysis / survey.qmd** — Covers the analysis of complex survey data, including sampling terminology (target population, sampling frames, strata, clusters), weighting, and methods for producing representative population estimates from survey microdata.

**Macrodemographic Analysis / macro.qmd** — Focuses on aggregate, place-level analysis (counties, census tracts, ZIP codes). Introduces generalized linear models for demographic rates and outcomes measured at the area level rather than the individual level.

**Microdemographic Analysis / micro.qmd** — Covers individual-level analysis with an emphasis on event history (survival/duration) models: time-to-event outcomes, transitions, and timing of demographic events such as births, deaths, and migration.

**References / references.qmd** — Bibliography.

## Data Sources

The book uses demographic datasets typical of applied work in the field, including IPUMS microdata (an IPUMS parquet file with replicate weight columns is present in the repo). Survey data with complex designs and replicate weights are a recurring theme.

## Technology

Built with Quarto. All analysis code is in R. Rendered as a book (likely HTML and/or PDF output). The repo uses Git for version control and is hosted on GitHub.
