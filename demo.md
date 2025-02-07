# Getting Started with the ScalableCS Package

### Kenichi Shimizu

### 2025-02-06


 
## Introduction

This vignette discusses the basics of the scalable estimation of consideration set models the **ScalableCS** package in Matlab. The background article for it is [Chib and Shimizu (2025), "Scalable Estimation of Multinomial Response Models with Random Consideration Sets
"](https://arxiv.org/pdf/2308.12470).



* The **did** package allows for multiple periods and variation in treatment timing

* The **did** package allows the parallel trends assumption to hold conditional on covariates

* Treatment effect estimates coming from the **did** package do not suffer from any of the drawbacks associated with two-way fixed effects regressions or event study regressions when there are multiple periods / variation in treatment timing

* The **did** package can deliver disaggregated *group-time average treatment effects* as well as event-study type estimates (treatment effects parameters corresponding to different lengths of exposure to the treatment) and overall treatment effect estimates.a

# Examples with simulated data

Let's start with a really simple example with simulated data.  Here, there are going to be 4 time periods.  There are 4000 units in the treated group that are randomly (with equal probability) assigned to first participate in the treatment (a *group*) in each time period.  And there are 4000 ``never treated'' units.  The data generating process for untreated potential outcomes

$$
  Y_{it}(0) = \theta_t + \eta_i + X_i'\beta_t + v_{it}
$$


The dataset contains two matrices: Y (J by nT) and X (JnT by dx). 
* The X matrix contains information on covariates $x_{ijt}$. For example, it may include price, display, and feature (dx=3). The following shows an example here the first unit is observed for three periods and the second unit is observed for two periods:

(i,t) | price | display | feature
--- | --- | --- | --- 
(1,1) | 301 | 283 | 290  
(1,2) | 301 | 283 | 290  
(1,3) | 301 | 283 | 290  
(2,1) | 301 | 283 | 290  
(2,2) | 301 | 283 | 290  
: | : | : | :  







