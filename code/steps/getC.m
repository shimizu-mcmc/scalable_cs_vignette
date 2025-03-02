% C*_i is J by 1 
% Update one component after another 
function [C,accept,diffC_accept]=getC(delta,Vbar,C_old,gamma,class,data,dim)
J=dim.J;
n=dim.n;
Ti=dim.Ti;
house=dim.house;

Y=data.Y;
YY=data.YY;

M=gamma(:,class);

accept_mat=zeros(n,J);
diffC_accepted_mat=zeros(n,J);

for jj=randperm(J)%1:J
C_new=C_old;
C_new(jj,:)=(rand(1,n)<=M(jj,:));
%C_new(jj,:)=C_new(jj,:).*(1-YY(jj,:))+1.*YY(jj,:);%If jj was ever chosen by i, propose to include jj in C_i; %commented out, Sep 16, 2023
diffC_proposed=(C_new(jj,:)~=C_old(jj,:));
ccp_old=compCCP(delta+Vbar,C_old,Ti);
ccp_new=compCCP(delta+Vbar,C_new,Ti);

ccp_new_Y=sum(ccp_new.*Y);
ccp_old_Y=sum(ccp_old.*Y);

prob=cellfun(@prod,accumarray(house(:),ccp_new_Y(:),[],@(n){n}))./...
    cellfun(@prod,accumarray(house(:),ccp_old_Y(:),[],@(n){n}));prob=prob';
% If YY(jj,ii)=1 and C_new(jj,ii)=0, then reject it by setting prob(ii)=0. Otherwise prob(jj,ii) = NaN
prob(logical(YY(jj,:).*(1-C_new(jj,:))))=0;

accept=(rand(1,n)<min(prob,1));

%accept.*(C_old(jj,:)==0).*(C_new(jj,:)==1)% { Accept C_{ij}=1  | Now C_{ij}=0 and propose C_{ij}=1 }


C_old(jj,accept)=C_new(jj,accept);
accept_mat(:,jj)=accept';

diffC_accepted=(diffC_proposed==1 & accept==1);
diffC_accepted_mat(:,jj)=diffC_accepted;

end 
C=C_old;

accept=mean(accept_mat,2);
diffC_accept=mean(diffC_accepted_mat,2);

end 