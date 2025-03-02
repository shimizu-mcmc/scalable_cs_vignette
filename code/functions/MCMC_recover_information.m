%Recover selected options, dimensions, and data
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
J=dim.J;
n=dim.n;
Ti=dim.Ti;
%house=dim.house;
nT=dim.nT;
JnT=dim.JnT;
dx=dim.dx;
dz=dim.dz;

% Recover data
Y=data.Y;
YY=data.YY;
X=data.X;
XX=data.XX;
%tempZ=data.tempZ;
Z=data.Z;


end 