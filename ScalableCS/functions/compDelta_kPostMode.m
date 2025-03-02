% beta_init= initial value of beta 
% Compute the conditional posterior mode of beta 
function [delta_k,hessLogPost]=compDelta_kPostMode(Y,delta,Vdelta_,Vbar,C,Ti,Nstep,k)

delta_k=delta(k);
step_size=0.5;%1;Aug 23,2024
for step=1:Nstep
    %step
delta(k)=delta_k;    
[gradLogLike,hessLogLike]=compLogLikeGrad_delta_k(Y,delta,Vbar,C,Ti,k);
[gradLogPrior,hessianLogPrior] = logmvnpdfGrad(delta_k,0,Vdelta_(k));
gradLogPost=gradLogLike+gradLogPrior;
hessLogPost=hessLogLike+hessianLogPrior;

change = -step_size*(hessLogPost\gradLogPost);
delta_k=delta_k + change;
if norm(change)<1
    break;
end 
%step
end 



end 