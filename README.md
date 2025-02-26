# Getting Started with the ScalableCS Package

[comment]: <> (### Kenichi Shimizu)

[comment]: <> (### 2025-02-06)


 
## Introduction

This vignette discusses the basics of the scalable estimation of consideration set models the **ScalableCS** package in Matlab. The background article for it is ["Scalable Estimation of Multinomial Response Models with Random Consideration Sets
"](https://arxiv.org/pdf/2308.12470](https://anonymous.4open.science/r/jasa_reproducibility-22DF/manuscript/manuscript.pdf)).



* The **did** package allows for multiple periods and variation in treatment timing

* The **did** package allows the parallel trends assumption to hold conditional on covariates

* Treatment effect estimates coming from the **did** package do not suffer from any of the drawbacks associated with two-way fixed effects regressions or event study regressions when there are multiple periods / variation in treatment timing

* The **did** package can deliver disaggregated *group-time average treatment effects* as well as event-study type estimates (treatment effects parameters corresponding to different lengths of exposure to the treatment) and overall treatment effect estimates.a

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

# Data structure

The package requires a certain structure of the dataset. The dataset contains two matrices: Y (J by nT) and X (JnT by dx). 
* The X matrix contains information on covariates $x_{ijt}$. For example, it may include price, display, and feature (dx=3). The following shows an example here the first unit is observed for three periods and the second unit is observed for two periods:

(i,t) | price | display | feature
--- | --- | --- | --- 
(1,1) | 301 | 283 | 290  
(1,2) | 301 | 283 | 290  
(1,3) | 301 | 283 | 290  
(2,1) | 301 | 283 | 290  
(2,2) | 301 | 283 | 290  
: | : | : | :  


* Show posterior probs over the 15 points with T=5. Talk about the sparsity. 



* Show a table 




