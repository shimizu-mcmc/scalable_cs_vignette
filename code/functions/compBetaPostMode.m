% beta_init= initial value of beta 
% Compute the conditional posterior mode of beta 
function [beta,hessLogPost]=compBetaPostMode(Y,beta_init,Vbeta_,X,XX,delta,b,Z,C,Ti,nT,JnT,Nstep)

beta=beta_init;
%Nstep=10;
step_size=1;
for step=1:Nstep
    %step
[gradLogLike,hessLogLike]=compLogLikeGrad_beta(Y,beta,X,XX,delta,b,Z,C,Ti,nT,JnT);
[gradLogPrior,hessianLogPrior] = logmvnpdfGrad(beta',zeros(1,length(beta)),Vbeta_);
gradLogPost=gradLogLike+gradLogPrior';
hessLogPost=hessLogLike+hessianLogPrior;

change = -step_size*(hessLogPost\gradLogPost);
beta=beta + change;
if norm(change)<0.1
    break;
end 

end 
%step


end 