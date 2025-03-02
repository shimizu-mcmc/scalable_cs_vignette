
function ccp=compCCP(V,C,Ti)

% Compute V without delta
%V=getV(beta,X,b,Z,J,n);
% Add delta 
%V=delta+V;

ccp=exp(V).*repelem(C,1,Ti');

ccp=ccp./sum(ccp);
end 