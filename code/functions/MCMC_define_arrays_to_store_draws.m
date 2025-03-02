% Define arrays to save MCMC draws and Store the initial values 
% Input (1)
% dimensions 
% Input (2)
% Initial values (already defined) of 
% the preference params: beta,delta,b,D
% the CS params: C,class,gamma,omega,kMax,kappa
% Outputs are the arrays to store MCMC draws
function [beta_sim,delta_sim,accBeta_sim,accDelta_sim,...
b_sim,accB_sim,D_sim,...
C_sim,accC_sim,accDiffC_sim,...
gamma_sim,class_sim,omega_sim,kMax_sim,kUniq_sim,kappa_sim]=MCMC_define_arrays_to_store_draws(paramHetero,csHetero,J,n,Niter,slice,dx,dz,kGlobalMax,...
    beta,delta,b,D,...
    C,class,gamma,omega,kMax,kappa)

% If we define C_sim=zeros(J,n,Niter), it can be too large. 
% Save every 'slice"th draw of C
% Choose slice so that we only keep Niter_sliced draws 
Niter_sliced=Niter/slice;
% slice=Niter/Niter_sliced;
%C_sim=zeros(J,n,Niter);
C_sim=zeros(J,n,Niter_sliced);
accC_sim=zeros(n,Niter);
accDiffC_sim=zeros(n,Niter);

beta_sim=zeros(dx,Niter);
delta_sim=zeros(J,Niter);
accBeta_sim=zeros(Niter,1);
accDelta_sim=zeros(1,Niter);
if paramHetero==1
    b_sim=zeros(dz,n,Niter);
    accB_sim=zeros(n,Niter);
    D_sim=zeros(dz,dz,Niter);
else
    b_sim=[];accB_sim=[];D_sim=[];
end 
if csHetero==1
    gamma_sim=zeros(J,kGlobalMax,Niter);
    class_sim=zeros(n,Niter);
    omega_sim=zeros(kGlobalMax,Niter);
    kMax_sim=zeros(1,Niter);
    kUniq_sim=zeros(1,Niter);
    kappa_sim=zeros(1,Niter);
else
    gamma_sim=[];class_sim=[];omega_sim=[];
    kMax_sim=[];kUniq_sim=[];kappa_sim=[];
end 

% Store initial values 
beta_sim(:,1)=beta;
delta_sim(:,1)=delta;
if paramHetero==1
    b_sim(:,:,1)=b;
    D_sim(:,:,1)=D;
end 
if csHetero==1
    C_sim(:,:,1)=C;
    gamma_sim(:,1:kMax,1)=gamma;
    class_sim(:,1)=class;
    omega_sim(1:kMax,1)=omega;
    kMax_sim(1)=kMax;
    kUniq_sim(1)=length(unique(class));
    kappa_sim(1)=kappa;
end 


end 