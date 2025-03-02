function PostProbH1=TestCSDependence(omega_sim)
% Posterior prob of dependence
% omega*=max{omega_k, k=1,...,kMax}
Niter=size(omega_sim,2);
Nburnin=0.5*Niter;
max_omega_sim=max(omega_sim);
small_val=0.1;%0.05;
% H0: omega*>1-small_val i.e. independence
PostProbH1=mean(max_omega_sim(Nburnin+1:end)<=1-small_val);
%PostProbH0=1-PostProbH1;%reject H0
%RejectH0=(PostProbH1/PostProbH0>1);%0 or 1 
end 