% Initialize parameters
% Inputs can be recovered from the structures dim,data,options
% Outputs
% preference parameters: beta,delta,b,D
% consideration set parameters: C,class,gamma,omega,kMax,kGlobalMax,kappa
function [beta,delta,b,D,...
    C,class,gamma,omega,kMax,kGlobalMax,kappa]=MCMC_initialize_params(paramHetero,csHetero,DepConsid_flag,kMax,n,J,dx,dz,Vbeta_,Y,YY,X,XX,Z,Ti,nT,JnT)

% 1. Initialize the parameters related to consideration sets
if csHetero==1
    if DepConsid_flag==1
        kGlobalMax=30;%Initialize the maximum number of components (will be updated within MCMC if needed)
    elseif DepConsid_flag==0
        kMax=1;
        kGlobalMax=1;
    end 
    kappa=1;% dirichlet process prior parameter        
    v=zeros(kMax,1);
    for k = 1 : kMax
        v(k)=betarnd(1, kappa, [1 1]);	
    end
    % calculate weights
    omega=zeros(kMax,1);
    for k = 1 : kMax 
	    omega(k) = v(k)*prod( 1-v(1:k-1) );
    end
    class = ceil(kMax*rand(1, n))';% initialise allocation and hidden state vectors
    gamma=rand(J,kMax);% initialize the component-spexific consideration probs

    C=YY;% Initialize the unit-specific consideration set as the set of responses made by the unit
elseif csHetero==0
    C=ones(J,n);%All products are in everyone's CS
    class=[];
    gamma=[];
    omega=[];
    kMax=[];
    kGlobalMax=[];
    kappa=[];
end 
% 2. Initialize preference parameters
if paramHetero==1
    D=1*eye(dz);
    b=randn(dz,n);
elseif paramHetero==0
    b=[];
    D=[];    
end  
delta=zeros(J,1);%ones(J,1)+randn(J,1);%ones(J,1)+randn(J,1);
delta(J)=0;
beta_init=0.1*randn(dx,1);
%beta=beta_init;
beta=compBetaPostMode(Y,beta_init,Vbeta_,X,XX,delta,b,Z,C,Ti,nT,JnT,100);



end 