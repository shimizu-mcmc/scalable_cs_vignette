# Getting Started with the ScalableCS Package

#### Kenichi Shimizu

#### 2024-09-10


 
## Introduction

This vignette discusses the basics of the scalable estimation of consideration set models the **ScalableCS** package in Matlab. The background article for it is [Chib and Shimizu (2025), "Scalable Estimation of Multinomial Response Models with Random Consideration Sets
"](https://arxiv.org/pdf/2308.12470).


This vignette discusses the basics of using Difference-in-Differences (DiD) designs to identify and estimate the average effect of participating in a treatment with a particular focus on tools from the **did** package. The background article for it is [Callaway and Sant'Anna (2021), "Difference-in-Differences with Multiple Time Periods"](https://doi.org/10.1016/j.jeconom.2020.12.001).


* The **did** package allows for multiple periods and variation in treatment timing

* The **did** package allows the parallel trends assumption to hold conditional on covariates

* Treatment effect estimates coming from the **did** package do not suffer from any of the drawbacks associated with two-way fixed effects regressions or event study regressions when there are multiple periods / variation in treatment timing

* The **did** package can deliver disaggregated *group-time average treatment effects* as well as event-study type estimates (treatment effects parameters corresponding to different lengths of exposure to the treatment) and overall treatment effect estimates.a

# Examples with simulated data

Let's start with a really simple example with simulated data.  Here, there are going to be 4 time periods.  There are 4000 units in the treated group that are randomly (with equal probability) assigned to first participate in the treatment (a *group*) in each time period.  And there are 4000 ``never treated'' units.  The data generating process for untreated potential outcomes

$$
  Y_{it}(0) = \theta_t + \eta_i + X_i'\beta_t + v_{it}
$$
