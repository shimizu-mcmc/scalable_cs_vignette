% accept_sim is Niter by 1 
% para_sim is d by Niter
% scale_constant0 is a scaler
% tuningMH_Niter is usually 200 - 500
% Output
% scale_constant0 (updated)
% good_acc_rate is 0 or 1 
% cand_cov0 is d by d 
function [scale_constant0,good_acc_rate,cand_cov0]=tuneMH(accept_sim,scale_constant0,tuningMH_Niter,iter,para_sim,cand_cov0)

acc_rate_so_far=mean(accept_sim(iter-tuningMH_Niter+1:iter));
if acc_rate_so_far<0.3
   scale_constant0=(1/2)*scale_constant0;
elseif acc_rate_so_far>0.5
    scale_constant0=2*scale_constant0;           
end 

%cand_cov0=cov(para_sim(:,iter-tuningMH_Niter+1:iter)')+0.01*eye(size(para_sim,1));

if 0.3<acc_rate_so_far && acc_rate_so_far<0.5
    good_acc_rate=1;
    if isempty(para_sim)==0
    cand_cov0=cov(para_sim(:,iter-tuningMH_Niter+1:iter)')+0.01*eye(size(para_sim,1));
    else
    cand_cov0=[];    
    end 
else 
    good_acc_rate=0;
    if isempty(para_sim)==0
    cand_cov0=cand_cov0;
    else
    cand_cov0=[];    
    end     
end 

end 