%options
%estimation=1;%=1 MNL, =2 MNL_R, =3 MNL_C, =4 MNL_RC
%DepConsid_flag=1 if K=infinity, =0 if K=1
%includeDelta=1 if include delta's (product fixed effects), =0 otherwise
%deltaTMH_flag=1 if update delta using Tailerd MH (TMH), 0 if Random Walk MH (RWMH)
%prior_attention_prob=1 if sparsity inducing prior for attention probs "q",=0 if uninformative 
%kMax is the initial value of the max number of components (=1 if DepConsid_flag==0)
%slice: every "slice"th MCMC draw of CSs is saved. Too large to save all draws.
function [beta_sim,delta_sim,accBeta_sim,accDelta_sim,...
b_sim,accB_sim,D_sim,...
C_sim,accC_sim,accDiffC_sim,...
gamma_sim,class_sim,omega_sim,kMax_sim,kUniq_sim,kappa_sim]=runMCMC(Niter,data,dim,options)
 

% I. Recover selected options, dimensions, and data
[J,n,Ti,nT,JnT,dx,dz,Y,YY,X,XX,Z,...
    paramHetero,csHetero,DepConsid_flag,includeDelta,deltaTMH_flag,prior_attention_prob,kMax,slice]=MCMC_recover_information(data,dim,options);

% II. Set priors
[Vbeta_,Vdelta_,v_,R_,aGamma_,bGamma_,prior_a,prior_b]=MCMC_set_priors(paramHetero,csHetero,prior_attention_prob,J,dx,dz);

% III. Initialize parameters
 [beta,delta,b,D,...
    C,class,gamma,omega,kMax,kGlobalMax,kappa]=MCMC_initialize_params(paramHetero,csHetero,DepConsid_flag,kMax,n,J,dx,dz,Vbeta_,Y,YY,X,XX,Z,Ti,nT,JnT);

% IV. Define arrays to save MCMC draws and save the initial values
[beta_sim,delta_sim,accBeta_sim,accDelta_sim,...
    b_sim,accB_sim,D_sim,C_sim,accC_sim,accDiffC_sim,...
gamma_sim,class_sim,omega_sim,kMax_sim,kUniq_sim,kappa_sim]=...
MCMC_define_arrays_to_store_draws(paramHetero,csHetero,J,n,Niter,slice,dx,dz,kGlobalMax,beta,delta,b,D,C,class,gamma,omega,kMax,kappa);


tuningMH_Niter=200;
good_acc_rate_delta=0;
scale_constant0_delta=2.38/sqrt(J-1);
cand_cov0_delta=0.1*eye(J-1);%initialize the candidate covariance matrix 

%good_acc_rate_beta=0;
scale_constant0_beta=1;%2.38/sqrt(length(beta));


% V. Run Markov chain Monte Carlo
for iter=2:Niter
   %iter
  if mod(iter,100) == 0
    fprintf('At iteration %d...\n',iter);
  end
  if mod(iter,tuningMH_Niter)==0 
        if good_acc_rate_delta==0
            [scale_constant0_delta,good_acc_rate_delta,cand_cov0_delta]=tuneMH(accDelta_sim,scale_constant0_delta,tuningMH_Niter,iter,delta_sim(1:J-1,:),cand_cov0_delta);        
        end 
  end 
% 1. Update beta
[beta,~,accBeta] = getBeta_TMH(beta,Vbeta_,delta,b,C,data,dim,scale_constant0_beta);

% 2. Update b, if requested 
if paramHetero==1
    [b,~,accB] = getB(delta,beta,b,D,C,data,dim);
    invD=getInvD(b,v_,R_);D=inv(invD);
end 

% 3. Compute the mean utility (before adding catagory FEs, delta) given beta and b 
Vbar=getVbar(beta,X,b,Z,J,n);

% 4. Update delta (category fixed effects), if requested 
if includeDelta==1 
    if deltaTMH_flag==1 %Use a tailored MH to update delta
    [delta,~,accDelta] = getDelta_TMH(delta,Vdelta_,Vbar,Y,C,Ti);accDelta=mean(accDelta);
    elseif deltaTMH_flag==0 %Use a random-walk MH to update delta
    [delta,~,accDelta] = getDelta_RWMH(delta,Vdelta_,Vbar,C,data,dim,scale_constant0_delta,cand_cov0_delta);
    end 
end 

% 5. Update  consideration sets (CSs) and the associated parameters, if requested
if csHetero==1
    [C,accC,accDiffC]=getC(delta,Vbar,C,gamma,class,data,dim); %Update CSs
    [gamma,class,omega,kMax]=getMixtureParas(C,class,kMax,aGamma_,bGamma_,kappa,dim,DepConsid_flag); %Update the parameters in the CS model
    kappa=getKappa(kappa,class,prior_a,prior_b,dim);% Update mass population parameter kappa as in Escobar and West (1995), if specified in the option
end

% 6. Save MCMC draws
beta_sim(:,iter)=beta;
delta_sim(:,iter)=delta;
accBeta_sim(iter)=accBeta;
if includeDelta==1
    accDelta_sim(:,iter)=accDelta;
end

if paramHetero==1
    b_sim(:,:,iter)=b;
    accB_sim(:,iter)=accB;
    D_sim(:,:,iter)=D;
else
    b_sim=[];accB_sim=[];D_sim=[];
end

if csHetero==1
    if mod(iter,slice)==0
    C_sim(:,:,iter/slice)=C;
    end
    accC_sim(:,iter)=accC;
    accDiffC_sim(:,iter)=accDiffC;
    gamma_sim(:,1:kMax,iter)=gamma;
    class_sim(:,iter)=class;
    omega_sim(1:kMax,iter)=omega;
    kMax_sim(iter)=kMax;
    kUniq_sim(iter)=length(unique(class));
    kappa_sim(iter)=kappa;
else 
    C_sim=[];accC_sim=[];accDiffC_sim=[];
    gamma_sim=[];class_sim=[];omega_sim=[];
    kMax_sim=[]; kUniq_sim=[];kappa_sim=[];
end 

end 






end 