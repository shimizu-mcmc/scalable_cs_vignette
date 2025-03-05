% Updating step for D, the covariance matrix of the random effects, b
% Inputs: 
% b: the current value of b
% v_,R_: hyperparas
function invD=getInvD(b,v_,R_)
n=size(b,2);
invD = wishrnd(inv(R_+b*b'),v_+ n);
end 