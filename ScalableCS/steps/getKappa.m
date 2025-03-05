% Update the DP concentraion parameter kappa as in Escobar and West (1995)
% Inputs:
% kappa: the current kappa
% prior_a,prior_b: the hyperparas for kappa
% class: cluster allocations 
% dim: the dimension structure
% Output: 
% kappa: the new kappa

function kappa=getKappa(kappa,class,prior_a,prior_b,dim)
n=dim.n;
        eta = betarnd(kappa+1, n);
        %simulate alpha given eta
        temp_wg = (length(unique(class))+prior_a-1)/(n*(prior_b-log(eta)));
        wg=temp_wg/(1+temp_wg);
        %wg is the mixture weight in the mixture of Gamma's 
        kappa = gamrnd(prior_a+length(unique(class))-(rand_sample([wg; 1-wg])-1),1/(prior_b-log(eta))); 
        
end 