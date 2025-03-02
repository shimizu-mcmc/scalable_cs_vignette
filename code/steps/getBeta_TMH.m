% Tailored MH
function [beta,prob,accept] = getBeta_TMH(beta_old,Vbeta_,delta,b,C,data,dim,scale_constant0_beta)
J=dim.J;
n=dim.n;
Ti=dim.Ti;
nT=dim.nT;
JnT=dim.JnT;

Y=data.Y;
X=data.X;
XX=data.XX;
Z=data.Z;
% 1. Evaluate log posterior at beta_old
Vbar_old=getVbar(beta_old,X,b,Z,J,n);
logLike_old= compLogLike(Y,delta+Vbar_old,C,Ti);
logPrior_old=logmvnpdf(beta_old',    zeros(1,length(beta_old)),Vbeta_);
logPost_old=logLike_old+logPrior_old;
% 2. beta_new ~ N(beta_hat,H(beta_hat)), beta_hat is the mode of the conditional post
% 2.1 Compute beta_hat
[beta_hat,hessLogPost]=compBetaPostMode(Y,beta_old,Vbeta_,X,XX,delta,b,Z,C,Ti,nT,JnT,100);
% 2.2 Draw beta_new
beta_new=beta_hat+scale_constant0_beta*draw_mvnrnd(-hessLogPost);

% 2.3 Evaluate log posterior at beta_new 
Vbar_new=getVbar(beta_new,X,b,Z,J,n);
logLike_new=compLogLike(Y,delta+Vbar_new,C,Ti);
logPrior_new=logmvnpdf(beta_new',zeros(1,length(beta_new)),Vbeta_);
logPost_new= logLike_new+logPrior_new;

Sig_hat=inv(-hessLogPost);
tailerd_old=logmvnpdf(beta_old',beta_hat',Sig_hat);
tailerd_new=logmvnpdf(beta_new',beta_hat',Sig_hat);

prob=exp(logPost_new+tailerd_old-logPost_old-tailerd_new);
% prob_beta
accept=0;
beta=beta_old;
if rand<min(prob,1)
   
    beta=beta_new;
    accept=1;

end 


end 
