% The code recovers selected options, dimensions, and data

% Inputs:
% <Niter> number of MCMC draws
% <data> the data structure
% <dim> the dimension structure
% <options> the option structure 

% Outputs:
% The information in the structures. See the header of runMCMC.m.

function [J,n,Ti,nT,JnT,dx,dz,Y,YY,X,XX,Z,...
    paramHetero,csHetero,DepConsid_flag,includeDelta,deltaTMH_flag,prior_attention_prob,kMax,slice]=MCMC_recover_information(data,dim,options)
% Recover the selected options 
estimation=options.estimation;
DepConsid_flag=options.DepConsid_flag;
includeDelta=options.includeDelta;
deltaTMH_flag=options.deltaTMH_flag;
prior_attention_prob=options.prior_attention_prob;
kMax=options.kMax;
slice=options.slice;

% Recover the selected model
if estimation==2 || estimation==4 %MNL_R or MNL_RC
    paramHetero=1;%Include random effects (i.e. parameter heterogeneity)
else
    paramHetero=0;
end 
if estimation==3 || estimation==4 %MNL_C or MNL_RC
    csHetero=1;%Incluide consid sets (i.e. CS heterogeneity)
else
    csHetero=0;
end 

% Recover information regarding dimensions
J=dim.J;%Number of alternatives
n=dim.n;%Number of units 
Ti=dim.Ti;%Numbers of unit-specific periods 
nT=dim.nT;%Sum of Ti's
JnT=dim.JnT;%J times nT
dx=dim.dx;%Number of covariates with fixed slopes 
dz=dim.dz;%Number of covariates with random slopes 

% Recover data
Y=data.Y;%Observed resposes
YY=data.YY;%Indicators: 1(j was ever chosen by i)
X=data.X;%Covariates with fixed slopes
XX=data.XX;%Squares of the X
%tempZ=data.tempZ;
Z=data.Z;%Covariates with random effects 


end 