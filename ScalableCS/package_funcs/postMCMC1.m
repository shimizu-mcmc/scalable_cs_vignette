% The code computes posterior statistics such as mean and sd of the
% parameters as well as computational time and inefficiency factors 

% Discard the firtst 30% of the draws as burn-in sample
Nburnin=0.3*Niter;
% Fixed slopes 
meanBeta=mean(beta_sim(:,Nburnin+1:end));
sdBeta=sqrt(var(beta_sim(:,Nburnin+1:end)));
lbBeta=quantile(beta_sim(:,Nburnin+1:end),0.025);
ubBeta=quantile(beta_sim(:,Nburnin+1:end),0.975);
% Brand fixed effects
meanDelta=mean(delta_sim(:,Nburnin+1:end),2);
sdDelta=sqrt( var(delta_sim(:,Nburnin+1:end),[],2) );
lbDelta=quantile(delta_sim(:,Nburnin+1:end)',0.025)';
ubDelta=quantile(delta_sim(:,Nburnin+1:end)',0.975)';



if paramHetero==1
% Random effect variance
sqrtD_sim=zeros(dim.dz,Niter);
    for iter=1:Niter
    sqrtD_sim(:,iter)=sqrt(diag(D_sim(:,:,iter)));
    end 

    meanSqrtD=mean(sqrtD_sim(Nburnin+1:end),2)';
    sdSqrtD=sqrt(var(sqrtD_sim(Nburnin+1:end)));
    lbSqrtD=quantile(sqrtD_sim(:,Nburnin+1:end)',0.025);
    ubSqrtD=quantile(sqrtD_sim(:,Nburnin+1:end)',0.975);
   
end 


if csHetero==1
% 1. Posterior prob of dependence (we did this in simulation)
PostProbH1=TestCSDependence(omega_sim);
end 


% Inefficiency factors 
max_lag=10;
ineff_beta = computeInefficiencyFactor(beta_sim(:,Nburnin+1:end),max_lag);

ineff_delta=zeros(dim.J-1,1);
for jj=1:dim.J-1
ineff_delta(jj) = computeInefficiencyFactor(delta_sim(jj,Nburnin+1:end),max_lag);
end

if paramHetero==1
sqrtD_sim=sqrt(D_sim(:,:,Nburnin+1:end));
ineff_sqrtD = computeInefficiencyFactor(sqrtD_sim(:),max_lag);
end



% Store values 
% Posterior means, sd, 95% credible intervals 
meanPara.Beta=meanBeta;
meanPara.Delta=meanDelta;

sdPara.Beta=sdBeta;
sdPara.Delta=sdDelta;

lbPara.Beta=lbBeta;
lbPara.Delta=lbDelta;
ubPara.Beta=ubBeta;
ubPara.Delta=ubDelta;

if paramHetero==1
    meanPara.SqrtD=meanSqrtD;
    sdPara.SqrtD=sdSqrtD;
    lbPara.SqrtD=lbSqrtD;
    ubPara.SqrtD=ubSqrtD;
end

% inefficiency factors 
inefPara.Beta=ineff_beta;
inefPara.Delta=ineff_delta;
if paramHetero==1
    inefPara.SqrtD=ineff_sqrtD;
end