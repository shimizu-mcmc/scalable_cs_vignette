---
title: "Getting Started with the did Package"
author: "Brantly Callaway and Pedro H.C. Sant'Anna"
date: "`r Sys.Date()`"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Getting Started with the did Package}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

```{r setup, include = FALSE}
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
```

# Introduction

This vignette discusses the basics of using Difference-in-Differences (DiD) designs to identify and estimate the average effect of participating in a treatment with a particular focus on tools from the **did** package. The background article for it is [Callaway and Sant'Anna (2021), "Difference-in-Differences with Multiple Time Periods"](https://doi.org/10.1016/j.jeconom.2020.12.001).

* The **did** package allows for multiple periods and variation in treatment timing

* The **did** package allows the parallel trends assumption to hold conditional on covariates

* Treatment effect estimates coming from the **did** package do not suffer from any of the drawbacks associated with two-way fixed effects regressions or event study regressions when there are multiple periods / variation in treatment timing

* The **did** package can deliver disaggregated *group-time average treatment effects* as well as event-study type estimates (treatment effects parameters corresponding to different lengths of exposure to the treatment) and overall treatment effect estimates.a
