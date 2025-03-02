function [delta,prob,accept] = getDelta_RWMH(delta_old,Vdelta_,Vbar,C,data,dim,scale_constant0_delta,cand_cov0_delta)
J=dim.J;
Ti=dim.Ti;

Y=data.Y;

logLike_old= compLogLike(Y,delta_old+Vbar,C,Ti);
logPrior_old=logmvnpdf(delta_old',    zeros(1,J),diag(Vdelta_));
logPost_old=logLike_old+logPrior_old;

delta_new_tmp=delta_old(1:J-1)+scale_constant0_delta*mvnrnd(zeros(1,J-1)',cand_cov0_delta)';
delta_new=[delta_new_tmp;0];

logLike_new= compLogLike(Y,delta_new+Vbar,C,Ti);
logPrior_new=logmvnpdf(delta_new',    zeros(1,J),diag(Vdelta_));
logPost_new=logLike_new+logPrior_new;

prob=exp(logPost_new-logPost_old);

% prob_beta
accept=0;
delta=delta_old;
if rand<min(prob,1)
   
    delta=delta_new;
    accept=1;

end 





end 
