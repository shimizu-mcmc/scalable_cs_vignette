% Suppose you have A=[A1;...;AT], where At is dt by K
% i.e. they are concatenated vertically 
% dall=[d1,...,dT]';
% The goal is to make a block diagonal matrix out of this 
% blkA=[A1, 0,  ...  0
%       0,  A2, ...  0
%       0,  0,  ..., AT]
function blkA=blk_diagonalize(A,dall)
K=size(A,2);
cell_array_of_matrices=mat2cell(A,dall,K);%{cell array of all of your matrices}
blkA=blkdiag(cell_array_of_matrices{:});
%blkA=sparse(blkA);
end



% Example 
% K=3;T=3;
% Jall=[3 5 2]';
% cdindex=[3 8 10]';
% cdid=[1 1 1 2 2 2 2 2 3 3]';
% A=randn(length(cdid),K);A(:,1)=1;



