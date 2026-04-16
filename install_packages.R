# install_packages.R
# -----------------------------------------------------------------------
# Installs all R packages required to render the Applied Demographic
# Data Analysis book. Run this script once before building the book.
#
# Usage:
#   source("install_packages.R")          # install only
#   source("install_packages.R"); install_book_packages(load = TRUE)
# -----------------------------------------------------------------------

install_book_packages <- function(load = FALSE) {

  # ---- Package list, grouped by chapter / purpose --------------------

  # Introduction to R (rintro.qmd)
  intro_pkgs <- c(
    "tidyverse",    # core data wrangling and visualization
    "readr",        # CSV and flat-file import
    "knitr",        # document rendering
    "kableExtra",   # table formatting
    "pander"        # plain-text table output
  )

  # Survey data analysis (survey.qmd)
  survey_pkgs <- c(
    "survey",       # complex survey design and estimation
    "srvyr",        # tidy interface to survey package
    "ipumsr",       # IPUMS data import
    "haven"         # Stata/SAS/SPSS import
  )

  # Macro-demographic analysis (macro.qmd)
  macro_pkgs <- c(
    "tidycensus",   # US Census Bureau API access
    "tigris",       # Census TIGER/Line shapefiles
    "sf",           # simple features spatial data
    "tmap",         # thematic maps
    "ggplot2",      # data visualization
    "patchwork",    # combining ggplot panels
    "broom"         # tidy model output
  )

  # Regression models for micro-outcomes (micro.qmd -- GLM section)
  glm_pkgs <- c(
    "car",          # recoding, companion to applied regression
    "gtsummary",    # publication-ready model tables
    "emmeans",      # estimated marginal means and contrasts
    "sjPlot",       # coefficient plots and model visualization
    "VGAM",         # vector generalized additive models
    "svyVGAM",      # survey-corrected VGAM (ordinal, multinomial)
    "MASS"          # negative binomial and other GLMs
  )

  # Event history analysis (micro.qmd -- survival sections)
  survival_pkgs <- c(
    "survival",     # Surv objects, coxph, survfit, survSplit
    "eha",          # event history analysis utilities
    "splines"       # natural splines for nonlinear time effects
  )

  # General modeling and diagnostics (across chapters)
  modeling_pkgs <- c(
    "lmtest",       # likelihood ratio and other model tests
    "sandwich",     # robust (heteroskedasticity-consistent) SEs
    "nlme",         # linear and nonlinear mixed-effects models
    "betareg",      # beta regression for proportional outcomes
    "gamlss",       # generalized additive models for location/scale
    "dispmod",      # dispersion models
    "texreg",       # LaTeX/HTML regression tables
    "gt",           # grammar of tables
    "ggfortify"     # autoplot methods for survival and other objects
  )

  # Utilities
  utility_pkgs <- c(
    "data.table",   # fast data manipulation
    "magrittr",     # pipe operators
    "forcats"       # factor handling (also in tidyverse)
  )

  # ---- Combine all packages ------------------------------------------
  all_pkgs <- unique(c(
    intro_pkgs,
    survey_pkgs,
    macro_pkgs,
    glm_pkgs,
    survival_pkgs,
    modeling_pkgs,
    utility_pkgs
  ))

  # ---- Identify what is not yet installed ----------------------------
  missing_pkgs <- all_pkgs[!all_pkgs %in% rownames(installed.packages())]

  if (length(missing_pkgs) == 0) {
    message("All ", length(all_pkgs), " packages are already installed.")
  } else {
    message(
      "Installing ", length(missing_pkgs), " missing package(s) of ",
      length(all_pkgs), " required:\n",
      paste(" -", missing_pkgs, collapse = "\n")
    )
    install.packages(
      missing_pkgs,
      dependencies = TRUE,
      repos        = "https://cloud.r-project.org"
    )
    message("\nInstallation complete.")
  }

  # ---- Optionally load all packages ---------------------------------
  if (load) {
    message("\nLoading all packages...")
    invisible(lapply(all_pkgs, function(pkg) {
      tryCatch(
        library(pkg, character.only = TRUE, quietly = TRUE),
        error = function(e) {
          warning("Could not load package: ", pkg, "\n  ", conditionMessage(e))
        }
      )
    }))
    message("Done.")
  }

  invisible(all_pkgs)
}

# Run immediately when sourced
install_book_packages()
