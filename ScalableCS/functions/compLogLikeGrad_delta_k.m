% Compute grad&hessian of the log-likelihood wrt delta_k

function [gradLogLike,hessLogLike]=compLogLikeGrad_delta_k(Y,delta,Vbar,C,Ti,k)
    

ccp=compCCP(delta+Vbar,C,Ti);

gradLogLike=sum(Y(k,:)-ccp(k,:),2);
hessLogLike=-sum(ccp(k,:).*(1-ccp(k,:)),2);

end 