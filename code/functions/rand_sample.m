% A generic function 
% Kenichi Shimizu
% July 17, 2021
% Univeristy of Glasgow

% Input: 
% a (S by n) matrix weights =(W_1,...,W_n)
% W_i is a column vector of S elements. W_i sum to 1.

% Output
% n draws X = (x_1,...x_n)'
% where x_i follows the pmf W_i 

% As a demonstration, consider the simplest case: n=1.
% x has a pmf (p_1,...,p_S)'
% 1. Draw u ~ Unif(0,1)
% 2. Note that Pr( u < sum_{k=1}^K p_k ) = sum_{k=1}^K p_k
% 3. Find the first K such that u < sum_{k=1}^K p_k and set x=K

% Y is a (S by n) matrix of dummy's
function [x,Y]=rand_sample(weights)

%weights=probCS;

w_cdf = cumsum(weights,1);
u = rand(1,size(weights,2));
C =  repmat(u,size(weights,1),1)<w_cdf ;
[~,x]=max(C',[],2);

% 
Y=zeros(size(weights,1),size(weights,2));
for ii=1:size(weights,2)
    Y(x(ii),ii)=1;
end 
end 