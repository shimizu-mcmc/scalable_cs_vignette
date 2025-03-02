% Kenichi Shimizu 
% University of Glasgow 
% Last modified: July 13, 2021

% Take a sample from a dirichlet distribution
 
% para is a vector, matrix, or 3D array of parameters

% Output: the second dimnensions will sum to one 

% 1. Draw from gamma 
% shape = scalar, vector,  matrix, or 3d array 
% scale = 1 (fixed)
% 2. Normalize 

function x = drchrnd(para)

r=gamrnd(para,1);
x=r./sum(r,2);

end 