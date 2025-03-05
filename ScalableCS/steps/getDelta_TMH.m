% Tailored MH for delta, the alternative fixed effects
% Inputs: 
% delta_old: the delta at the previous iter 
% Vdelta_: the prior variance
% Vbar: the mean utility (before adding catagory FEs, delta) given beta and b  
% Outputs:
% beta: the new delta
% prob: acceptance prob
% accept: 1 if the proposed value is accepted, zero otherwise


function [delta,prob,accept] = getDelta_TMH(delta_old,Vdelta_,Vbar,Y,C,Ti)
J=length(delta_old);
delta=zeros(J,1);
prob=zeros(J,1);
accept=zeros(J,1);
for k=randperm(J-1)%k=1:J
    %k
delta_new=delta_old;

% 1. Evaluate log posterior at delta_old_k
logLike_old= compLogLike(Y,delta_old+Vbar,C,Ti);
logPrior_old=logmvnpdf(delta_old(k),    0,Vdelta_(k));
logPost_old=logLike_old+logPrior_old;

% 2. delta_new_k ~ N(delta_hat_k,H(delta_hat_k)), delta_hat_k is the mode of the conditional post
% 2.1 Compute delta_k_hat and the hessian 
[delta_k_hat,hessLogPost]=compDelta_kPostMode(Y,delta_old,Vdelta_,Vbar,C,Ti,100,k);
% 2.2 Draw beta_new
delta_k_new=delta_k_hat+draw_mvnrnd(-hessLogPost);

% 2.3 Evaluate log posterior at delta_k_new 
delta_new(k)=delta_k_new;
logLike_new= compLogLike(Y,delta_new+Vbar,C,Ti);
logPrior_new=logmvnpdf(delta_k_new,0,Vdelta_(k));
logPost_new= logLike_new+logPrior_new;

Sig_hat=inv(-hessLogPost);
tailerd_old=logmvnpdf(delta_old(k),delta_k_hat,Sig_hat);
tailerd_new=logmvnpdf(delta_k_new,delta_k_hat,Sig_hat);
% tic;
% tailerd_old=-0.5*(delta_old(k)-delta_k_hat)^2/Sig_hat';
% tailerd_new=-0.5*(delta_k_new-delta_k_hat)^2/Sig_hat';
% toc;
% tic;
% tailerd_old=0.5*hessLogPost*(delta_old(k)-delta_k_hat)^2;
% tailerd_new=0.5*hessLogPost*(delta_k_new-delta_k_hat)^2;
% toc;

prob(k)=exp(logPost_new+tailerd_old-logPost_old-tailerd_new);


delta(k)=delta_old(k);
if rand<min(prob(k),1)
   
    delta(k)=delta_k_new;
    accept(k)=1;

end 
delta_old(k)=delta(k);

end 

end 



% delta_k_new=delta_old(k)+randn;
% delta_new(k)=delta_k_new;
% logLike_new= compLogLike(Y,delta_new,beta,X,b,Z,C,Ti);%compLogLike(Y,[delta_new;beta],X1,b,Z,C,Ti); 
% logPrior_new=logmvnpdf(delta_k_new,0,Vdelta_(k));
% logPost_new= logLike_new+logPrior_new;
% prob(k)=exp(logPost_new-logPost_old);