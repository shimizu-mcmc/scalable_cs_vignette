% Making a smaller sample from the replication data for Github demo
function [data,dim]=prepData(YData,XData,paramHetero)


y=YData(:,{'brand'});y=y{:,:};
X=[XData(:,{'price'})];X=X{:,:};

house_set=unique(YData.household);
J=length(unique(XData.brand));
n=length(unique(YData.household));
dx=1;

JnT=size(X,1);
nT=size(y,1);

XX=reshape(X',dx,1,JnT).*permute(reshape(X',dx,1,JnT),[2 1 3]);
XX=reshape(XX,dx*dx,JnT)';


Y=zeros(J,nT);
for ii=1:nT
    Y(y(ii),ii)=1;
end 
YY=zeros(J,n);
start=1;
house=YData(:,{'household'});house=house{:,:};
purch=YData(:,{'brand'});purch=purch{:,:};
for ii=1:n
    hh=house_set(ii);
    num_purch=sum(house==hh);
    finish=start+num_purch-1;
    bought=purch(start:finish);
    for jj=1:J
        YY(jj,ii)=(sum(bought==jj)>0);
    end 
    start=finish+1;
end 

%Compute Ti's 
Ti=zeros(n,1);
for ii=1:n
    hh=house_set(ii);    
    Ti(ii)=sum(house==hh);
end 

house_index=repelem((1:n)',Ti);

if paramHetero==1
dz=1;    
% Create Z matrix
tempZ=[XData(:,{'price'})];tempZ=tempZ{:,:};
Z=zeros(JnT,n*dz);
row_start=1;
col_start=1;
for ii=1:n
row_finish=row_start+J*Ti(ii)-1;
col_finish=col_start+dz-1;
Z(row_start:row_finish,col_start:col_finish)=tempZ(row_start:row_finish,:);
row_start=row_finish+1;
col_start=col_finish+1;
Z=sparse(Z);
end 

elseif paramHetero==0
dz=[];
tempZ=[];
Z=[];  

end 

dim.J=J;
dim.n=n;
dim.Ti=Ti;
dim.house=house_index;
dim.nT=nT;
dim.JnT=JnT;
dim.dx=dx;
dim.dz=dz;

data.Y=Y;
data.YY=YY;
data.X=X;
data.XX=XX;
data.tempZ=tempZ;
data.Z=Z;


end 