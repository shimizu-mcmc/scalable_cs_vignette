% Compute grad&hessian of the log-likelihood wrt beta
function [gradLogLike,hessLogLike]=compLogLikeGrad_beta(Y,beta,X,XX,delta,b,Z,C,Ti,nT,JnT)
[J,n]=size(C);
dx=size(X,2);
% Compute ccp
%ccp=compCCP(beta,X,b,Z,C,Ti);
Vbar=getVbar(beta,X,b,Z,J,n);
ccp=compCCP(delta+Vbar,C,Ti);
%ccp=compCCP_delta(delta,beta,X,b,Z,C,Ti);
P_vertical=reshape(ccp,JnT,1);
part2=reshape(sum(reshape((P_vertical.*X)',dx,J,nT),2),dx,nT);

Y_vertical=reshape(Y,JnT,1);
part1=reshape(sum(reshape((Y_vertical.*X)',dx,J,nT),2),dx,nT);

gradLogLike=sum(part1-part2,2);
% 2. Hessian 
if nargout>1
part4=reshape(part2,dx,1,nT).*permute(reshape(part2,dx,1,nT),[2 1 3]);%check% part2(:,1).*part2(:,1)'
% XX=reshape(X',dx,1,J*n*T).*permute(reshape(X',dx,1,J*n*T),[2 1 3]);
% XX=reshape(XX,dx*dx,n*T*J)';
%X(1,:)'.*X(1,:);X(2,:)'.*X(2,:)

part3=reshape(sum(reshape((P_vertical.*XX)',dx*dx,J,nT),2),dx*dx,nT);%SLOW 
hessLogLike=-( reshape(sum(part3,2),dx,dx)-sum(part4,3) );
end 

% [gradLogPrior,hessianLogPrior] = logmvnpdfGrad(beta',zeros(1,length(beta)),V_);
% gradLogPost=gradLogLike+gradLogPrior';
% hessLogPost=hessLogLike+hessianLogPrior;


end 