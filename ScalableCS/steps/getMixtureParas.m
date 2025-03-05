% Updating step for the mixture related parameters
% Inputs: 
% C: the current C 
% class: the current cluster allocations 
% kMax: the current max num of components
% aGamma_,bGamma_: hyperparameters for gamma, the component-specific attention probs
% kappa: the DP concentration para 
% DepConsid_flag=1 if K=infinity (infinite mixture of indep consid models), =0 if K=1 (indep consid model)
% dim: the dimension structure
% Outputs:
% gamma: the new gamma, the component-specific attention probs
% class: the new class
% omega: the new omega, the weights
% kMax: the new max num of components

function [gamma,class,omega,kMax]=getMixtureParas(C,class,kMax,aGamma_,bGamma_,kappa,dim,DepConsid_flag)
J=dim.J;
n=dim.n;

% 1. Update gamma
nComp = zeros(kMax, 1);
for k = 1 : kMax
    nComp(k) = length( find( class == k ) );
end    
gamma=zeros(J,kMax);
for k=1:kMax   
gamma(:,k)=betarnd( aGamma_+sum( C(:,(class==k)),2 ), bGamma_+ sum(1- C(:,(class==k)),2 ) );
end 

if DepConsid_flag==1
% 2. Update V
v=zeros(kMax,1);
for k = 1 : kMax
v(k) = betarnd(1+nComp(k), kappa+ n - sum(nComp(1:k)), [1 1]);    
end   
  
% 3. Recalculate weights 
omega=zeros(kMax,1);
for k = 1 : kMax 
omega(k) = v(k)*prod(1-v(1:k-1));
end
% 4. Sample auxiliary variable u  
u = rand(n, 1).*omega(class);  

% 6. Recompute kMax
if sum(omega) > 1-min(u)
% a. If we have more than enough components, remove excess components
    while sum(omega(1:kMax)) > 1-min(u)
        kMax = kMax - 1;
    end
    kMax  = kMax + 1;
	v 		= v(1:kMax);
	omega 		= omega(1:kMax);
	gamma 		= gamma(:,1:kMax);
else
% b. If we need more comps, sample more v's until the w's satisfy \sum_{j=1}^{kMax} w_j > 1-min(u)
    while sum(omega) <= 1-min(u)
	v_new       = betarnd(1, kappa, [1 1]);
	omega_new       = v_new * prod(1-v);
    gamma_new=betarnd(aGamma_,bGamma_);
    kMax 		= kMax + 1;
	v       	= [ v; 		v_new ];
	omega       	= [ omega ;		omega_new ];
	gamma      	= [ gamma 		gamma_new ];
    end
end

% 7. Update membership
log_prob=zeros(kMax,n);
for ii=1:n
    for k=1:kMax
        log_prob(k,ii)=sum(  C(:,ii).*log(gamma(:,k))+(1-C(:,ii)).*log(1-gamma(:,k)) );
    end 
end 

for i=1:n
   	loc  = find( omega > u(i) );
    % pr=prob(loc,i);
    % pr 	 = pr./sum(pr);
    log_pr=log_prob(loc,i);
    max_log_pr=max(log_pr);
    pr=exp(log_pr-max_log_pr)./sum(exp(log_pr-max_log_pr));
	where = rand_sample( pr );
	class(i) = loc(where);	      
end 


elseif DepConsid_flag==0
    class=ones(n,1);
    omega=1;
end 
end 