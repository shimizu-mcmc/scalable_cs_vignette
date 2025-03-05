% Random-Walk MH for b, the random-effects
% Inputs: 
% b_old: the b at the previous iter 
% delta,beta,D,C: other parameters 
% data,dim: data and dimension structures
% Outputs:
% b: the new b
% prob: acceptance prob
% accept: 1 if the proposed value is accepted, zero otherwise
function [b,prob,accept] = getB(delta,beta,b_old,D,C,data,dim)
J=dim.J;
n=dim.n;
Ti=dim.Ti;
dz=dim.dz;

Y=data.Y;
X=data.X;
tempZ=data.tempZ;


b=zeros(dz,n);
accept=zeros(n,1);
prob=zeros(n,1);

Ystart=1;
Xstart=1;
for ii=1:n
Yfinish=Ystart+Ti(ii)-1;
Y_i=Y(:,Ystart:Yfinish);
Ystart=Yfinish+1;

Xfinish=Xstart+J*Ti(ii)-1;
X_i=X(Xstart:Xfinish,:);   
tempZ_i=tempZ(Xstart:Xfinish,:);   
Xstart=Xfinish+1;
 

C_i=C(:,ii);

b_old_i=b_old(:,ii);

% 1. Evaluate log posterior at b_old_i
Vbar_old_i=getVbar(beta,X_i,b_old_i,tempZ_i,J,1);
logLike_old=compLogLike(Y_i,delta+Vbar_old_i,C_i,Ti(ii));
% 2. Draw b_i_new
%b_i_new=draw_mvnrnd(inv(D));
b_new_i=b_old_i+draw_mvnrnd(inv(D));
% 3. Evaluate log posterior at b_new_i
Vbar_new_i=getVbar(beta,X_i,b_new_i,tempZ_i,J,1);
logLike_new=compLogLike(Y_i,delta+Vbar_new_i,C_i,Ti(ii));
% 4. Accept/reject
%prob(ii)=exp(logLike_new-logLike_old);
logPrior_old=logmvnpdf(b_old_i',    zeros(dz,1)',D);
logPrior_new=logmvnpdf(b_new_i',    zeros(dz,1)',D);
prob(ii)=exp(logLike_new+logPrior_new-logLike_old-logPrior_old);

b_i=b_old_i;
if rand<min(prob(ii),1)
    b_i=b_new_i;
    accept(ii)=1;
end 

b(:,ii)=b_i;
end 
end 
