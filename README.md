# Getting Started with the ScalableCS Package

[comment]: <> (### Kenichi Shimizu)

[comment]: <> (### 2025-02-06)


 
## Introduction

This vignette discusses the basics of the scalable estimation of consideration set models the **ScalableCS** package in Matlab. The background article for it is ["Scalable Estimation of Multinomial Response Models with Random Consideration Sets
"](https://anonymous.4open.science/r/jasa_reproducibility-22DF/manuscript/manuscript.pdf).

* The **ScalableCS** package allows for estimation of multinomial logit model with latent consideration sets.
* The **ScalableCS** package is scalable with respect to the number of alternatives while maintaining flexibility of consideration dependence across alternatives. 
* The **ScalableCS** package can deliver (1) estimated logit parameters, (2) estimated consideration sets, and (3) demand sesitivity with respect to covariates. 

## Dimensions
- $J$ = the number of alternatives (brands, products, etc).
- $n$ = the number of units (consumers, households, etc).
- Each unit is observed for $T_i$ periods. $nT$ denotes the summation $\sum_i T_i$.
- $dx$ = the number of covariates with fixed effects/slopes.
- $dz$ = the number of covariates with random effects/slopes.

## The model 

### 1. The conditional model given latent consideration sets 

* This is the canonical multinomial logit model with $J$ alternatives.
* Let $y_{ijt}$ be an indicator that equals one if the response of unit $i$ at time $t$ is $j$.
* For each unit $i$, its latent consideration set $\mathcal{C_i}$ is a subset of the collection $\\{ 1,...,J \\}$.
* The response probability given that $\mathcal{C_i}=c$ is 

$$
 Pr(y_{ijt}=1 \vert \mathcal{C_i}= c )=\frac{V_{ijt}}{\sum_{\ell \in c} V_{i \ell t}},
$$

where

$$
 V_{ijt}=\delta_j+\beta x_{ijt}+b_i z_{ijt},
$$

where 
- $\beta$ is a vector of fixed effects/slopes,
- $b_i\sim N(0, D)$ is a vector of random effects,
-  $x_{ijt}$ and $z_{ijt}$ are observed covariates,
-  $\delta_j$ is the alternative fixed effect (by default, $\delta_J$ is normalized to zero).
-  Note that the time $t$ is specific to the units. Hence, the first period for unit 1 might be different from the first period for unit 2 in the real time. 

### 2. Distribution of consideration sets

* The consideration sets are random objects and follow an unknown distribution $\pi$.
* Note that its support has $2^{J}-1$ points, which exponentially increases in $J$. A direct estimation based on simulated MLE or MCMC faces a curse of dimensionality. 
* Our method offers a scalable approach. 

  
## Data structure
* The package requires a certain structure of the dataset. Although it allows a cross-sectional data, a typical dataset is longitudinal(panel).
* The dataset should contain two matrices: the response matrix $Y$, of dimension $J$ by $nT$, and the covariate matrix $X$ of dimension $JnT$ by $dx$.

### The response matrix   
* The matrix $Y$ contains information on the responses $y_{ijt}$.
* Let $J=3$. Suppose that the first unit is observed for three periods and the second unit is observed for two periods.
*  The following shows an example of the matrix $Y$:

Unit | Time | Response 
--- | --- | --- 
 1 | 1 | 2
 1 | 2 | 1
 1 | 3 | 2
 2 | 1 | 2
 2 | 2 | 3
: | : | : 
* In this table, we see that unit 1's responses were 2, 1, and 2; those for unit 2 were 2 and 3.

  
### The covariate matrix   
* The matrix $X$ contains information on covariates $x_{ijt}$.
* For example, it may include price, display, and feature ($dx=3$).
* The following shows an example of the matrix $X$:

Unit | Time | Alternative | price | display | feature
--- | --- | --- | ---  | --- | --- 
1 | 1 | 1 | 2.2 | 0   | 0 | 
1 | 1 | 2 | 3.1 | 0   | 0 |  
1 | 1 | 3 | 1.5 | 1   | 1 |  
1 | 2 | 1 | 2.3 | 1   | 0 |  
1 | 2 | 2 | 3.0 | 0   | 1 | 
1 | 2 | 3 | 1.6 | 0   | 0 | 
1 | 3 | 1 | 2.3 | 0   | 0 | 
1 | 3 | 2 | 3.3 | 1   | 0 | 
1 | 3 | 3 | 1.4 | 0   | 0 | 
2 | 1 | 1 | 2.5 | 0   | 0 | 
2 | 1 | 2 | 3.1 | 0   | 0 |  
2 | 1 | 3 | 1.5 | 1   | 1 |  
2 | 2 | 1 | 2.6 | 1   | 0 |  
2 | 2 | 2 | 3.0 | 0   | 1 | 
2 | 2 | 3 | 1.6 | 0   | 0 | 
: | : | : | :  | :  | :  


# Demonstration: An analysis on cereal purchase data
* This is a synthetic data of smaller scale of the actual data set considered in the paper.
* It is a panel data consisting of $n=25$ households's purchases from $J=50$ cereal brands (in the application in the paper, we use a larger data set with $n=1880, J=101$).
* In each period, household's purchased brand is recorded.
* On average, there are 13 periods of observation for each household. 
* The data also contains information on price of the brands at each of the purchasing occations ($dx=1$) for which a random effect is considered ($dz=1$).

* Let's run MCMC (Markov Chain Monte Carlo) for 1000 iterations.

## Implementation

```
YData = readtable('myDataDemonstration/YData_DEMO.txt');
XData = readtable('myDataDemonstration/XData_DEMO.txt');
[meanPara,sdPara,lbPara,ubPara,inefPara,estC,SimilarityMatrix,aggOwnElas]=scalableCS(YData,XData,2000,"MNL_RC");
```

## Parameter estimates
![title](Figures/beta_sqrtD.png)
![title](Figures/delta.png)


## Latent grouping structure 
![title](Figures/SimilarityMatrix.png)
<img src="Figures/SimilarityMatrix.png" width="200">

## Price sensitivity
![title](Figures/sensitivity.png)



  




