
% Get the mean utility without delta, the alternative fixed effects
function Vbar=getVbar(beta,X,b,Z,J,n)

if isempty(b)==1
Vbar=X*beta;
else 
dz=size(b,1);
Vbar=X*beta+Z*reshape(b,n*dz,1);
end 

Vbar=reshape(Vbar,J,[]);

end 