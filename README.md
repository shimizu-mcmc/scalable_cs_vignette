# Getting Started with the ScalableCS Package

[comment]: <> (### Kenichi Shimizu)

[comment]: <> (### 2025-02-06)


 
## Introduction

This vignette discusses the basics of the scalable estimation of consideration set models the **ScalableCS** package in Matlab. The background article for it is ["Scalable Estimation of Multinomial Response Models with Random Consideration Sets
"](https://anonymous.4open.science/r/jasa_reproducibility-22DF/manuscript/manuscript.pdf).

* The **ScalableCS** package allows for estimation of multinomial logit model with latent consideration sets.
* The **ScalableCS** package is scalable with respect to the number of alternatives while maintaining flexibility of consideration dependence across alternatives. 
* The **ScalableCS** package can deliver (1) estimated logit parameters, (2) estimated consideration sets, and (3) demand sesitivity with respect to covariates. 

# Dimensions
- $J$ = the number of alternatives (brands, products, etc).
- $n$ = the number of units (consumers, households, etc).
- Each unit is observed for $T_i$ periods. $nT$ denotes the summation $\sum_i T_i$.
- $dx$ = the number of covariates with fixed effects/slopes.
- $dz$ = the number of covariates with random effects/slopes.

# The model 

### The conditional model given latent consideration sets 

* This is the canonical multinomial logit model with $J$ alternatives.
* Let $y_{ijt}$ be an indicator that equals one if the unit $i$'s response at time $t$ is $j$.
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

### Distribution of consideration sets

* The consideration sets are random objects and follow an unknown distribution $\pi$.
* Note that its support has $2^{J}-1$ points, which exponentially increases in $J$. A direct estimation based on simulated MLE or MCMC faces a curse of dimensionality. 
* Our method offers a scalable approach. 

  
# Data structure
* The package requires a certain structure of the dataset. Although it allows a cross-sectional data, a typical dataset is longitudinal(panel).
* The dataset should contain two matrices: the response matrix $Y$ ($J$ by $nT$) and the covariate matrix $X$ ($JnT$ by $dx$).

### The covariate matrix   
* The matrix $X$ contains information on covariates $x_{ijt}$.
* For example, it may include price, display, and feature ($dx=3$).
* The following shows an example here the first unit is observed for three periods and the second unit is observed for two periods:

(i,t) | price | display | feature
--- | --- | --- | --- 
(1,1) | 301 | 283 | 290  
(1,2) | 301 | 283 | 290  
(1,3) | 301 | 283 | 290  
(2,1) | 301 | 283 | 290  
(2,2) | 301 | 283 | 290  
: | : | : | :  


### The response matrix   
* Suppose $J=4$. The following shows an example of the matrix $Y$:

Alternative | unit 1| unit 1 | unit 1 | unit 1 | unit 1 
--- | --- | --- | --- | --- | --- 
Alternative | period 1 | period 2 | period 3 | period 1 | period 2
1 | 0 | 1 | 1   | 0 | 0 
2 | 1 | 0 | 0   | 0 | 1 
3 | 0 | 0 | 0   | 1 | 0 
4 | 0 | 0 | 0   | 0 | 0 

 






* To do next
  + Reduce n in the replication data (n=100)
  + Estimate the model.
  + Show the following
    - Posterior means, INEF
    - Similarity matrix
    - Elasticity (under MNL_RC and MNL_R)
  
# Examples with simulated data

Let's start with a really simple example with simulated data. We generate a synthetic panel data consisting of $n=100$ units each observed for $T$ periods.  Here, there are going to be $J=4$ options. Note that in this small $J$ case, it is possible to enumerate and visualize all the $2^{J}-1=15$ possible consideration sets $\pi^{\ast}=\\{\pi_c^{\ast}: c=1,... ,15\\}$.  We first fix the data-generating value of the distribution $\pi^{\ast}$ of consideration sets as follows. $\pi^{\ast}\\{ 1,2\\}=\pi^{\ast}\\{ 3,4\\}=0.25$. The first two options and the last two have large consideration probabilities when considered together. For example, one can think of the first two corresponding to 'vegetarian' options and the last two being 'non-vegetarian.' The other consideration sets are assigned the same small probability of 0.0385. This induces dependence in consideration over the 4 options. Given the simulated consideration sets $\mathcal{C_i}\sim \pi^{\ast}$ for $i=1,...,n$, the responses are simulated from the following multinomial logit model.

$$
 Pr(y_{ijt}=1 \vert \mathcal{C_i}= c )=\frac{V_{ijt}}{\sum_{\ell \in c} V_{i \ell t}},
$$

where

$$
 V_{ijt}=\delta_j^{\ast}+\beta^{\ast}x_{ijt},
$$

and $x_{ijt} \sim N(0,1)$. 


* I want to show the clustering ... 



* Show posterior probs over the 15 points with T=5. Talk about the sparsity. 



* Show a table 




