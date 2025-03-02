function [grad,hessian] = logmvnpdfGrad(x,mu,Sigma)
% outputs gradient/hessian of log likelihood array for observations x  where x_n ~ N(mu,Sigma)
% x is NxD, mu is 1xD, Sigma is DxD

[n,d] = size(x);

invSigma=eye(d)/Sigma;
grad=-(x-mu)*invSigma;

hessian=-invSigma;

end 
