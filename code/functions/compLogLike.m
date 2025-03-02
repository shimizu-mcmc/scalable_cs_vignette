function [logLike]= compLogLike(Y,V,C,Ti)
% Compute ccp
ccp=compCCP(V,C,Ti);
logccp=log(ccp.*Y+1.*(1-Y));

logLike=sum(sum(logccp));


end 