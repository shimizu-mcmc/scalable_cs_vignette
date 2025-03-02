
% Get V without delta
function Vbar=getVbar(beta,X,b,Z,J,n)

%[J,n]=size(C);
% V=X*beta;
% V=reshape(V,J,n);
% ccp=exp(V).*C;
% ccp=ccp./sum(ccp);
if isempty(b)==1
Vbar=X*beta;
else 
dz=size(b,1);
Vbar=X*beta+Z*reshape(b,n*dz,1);
end 

Vbar=reshape(Vbar,J,[]);

end 