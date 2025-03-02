% Draw x from dx dimensional normal with mean 0 and covariance Sigma
% Sigma is dx by dx
% invSigma is the inverse
% https://calvinmccarter.wordpress.com/2015/01/06/multivariate-normal-random-number-generation-in-matlab/

function x=draw_mvnrnd(invSigma)
dx=size(invSigma,1);
z = randn(dx,1); % univariate random
L_Sigma = chol(invSigma,'lower'); % sparse
x = L_Sigma'\z;
end 


% Test
% J=3;
% rho0=0.5;
% Sigma0=eye(J)+rho0*ones(J,J);
% for sim=1:1000
% samp(:,sim)=draw_mvnrnd(inv(Sigma0));
% end 
% cov(samp')
% Sigma0

