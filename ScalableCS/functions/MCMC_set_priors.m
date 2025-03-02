% Fixed slope coefficients
% beta ~ N(0,Vbeta_)
% Random slopes 
% b ~ N(0,D), invD ~ Wishart(v_,R_)
% Consideration probabilities 
% gamma_{hj} ~ Beta(aGamma_,bGamma_), j=1:J, j=1,...,infty
% DP concentraion parameter 
% kappa ~ beta(prior_a,prior_b)


function [Vbeta_,Vdelta_,v_,R_,aGamma_,bGamma_,prior_a,prior_b]=MCMC_set_priors(paramHetero,csHetero,prior_attention_prob,J,dx,dz)
% beta ~ N(0,Vbeta_)
Vbeta_=3*eye(dx);
Vdelta_=2*ones(J,1);
if paramHetero==1
    % b ~ N(0,D), invD ~ Wishart(v_,R_)
    v_=9;
    R_=(1/9)*eye(dz);
else 
    v_=[];R_=[];
end 

if csHetero==1
    if prior_attention_prob==0 %Uninformative prior on attention probs "q"
        a_=1; b_=1;
    elseif prior_attention_prob==1%sparsity inducing prior
        r0=30;30;s=5;
        r=r0/J;
        a_=s*r;
        b_=s*(1-r);
    end 

    
    aGamma_=a_*ones(J,1);
    bGamma_=b_*ones(J,1);

    prior_a     = 1/4; %parameters on Gamma prior for kappa
    prior_b     = 4;
else
    aGamma_=[];bGamma_=[];prior_a=[];prior_b=[];
end 




end 



% pMed_gamma=(a_-1/3)/(a_+b_-2/3);%median 
% pMean_gamma=a_/(a_+b_);
% pVar_gamma=a_*b_/((a_+b_)^2*(a_+b_+1));

% prob_based_on_mean=binopdf(0:J,J,pMean_gamma);sum(prob_based_on_mean)
% figure;plot(0:J,prob_based_on_mean)

%display('       a        b        mean     var')
%display([a_ b_ pMean_gamma pVar_gamma])

%figure;plot(0.01:0.01:0.99,betapdf(0.01:0.01:0.99,a_,b_));ylim([0 10])
% title(['r0=',num2str(r0),'s=',num2str(s),'a=',num2str(a_),'b=',num2str(b_)])
