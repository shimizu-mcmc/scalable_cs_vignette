% Suppose you have a block diagonal matrix 
% blkA=[A1, 0,  ...  0
%       0,  A2, ...  0
%       0,  0,  ..., AT]
% where At are the same dimensions Jt by K
% The goal is to concatenate At vertically
% A=[A1;...;AT]

function A=unblk_diagonalize(blkA,T)
K=size(blkA,2)/T;
A=blkA*repmat(eye(K),T,1);
end 



