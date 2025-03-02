% Compute own elasticity
% clear
% rng(123)
% Niter=5000;
% estimation=4;%=1 MNL, =2 MNL_R, =3 MNL_C, =4 MNL_RC
% DepConsid_flag=1;%=1 if dependent consideration 0 otherwise 
% 
% if estimation==2 || estimation==4 %MNL_R or MNL_RC
%     paramHetero=1;
% else
%     paramHetero=0;
% end 
% if estimation==3 || estimation==4 %MNL_C or MNL_RC
%     csHetero=1;
% else
%     csHetero=0;
% end 
% 
% if estimation==1
% filename_own=['MNL_Niter' num2str(Niter),'.mat'];
% elseif estimation==2
% filename_own=['MNL_R_Niter' num2str(Niter),'.mat'];
% elseif estimation==3
%     if DepConsid_flag==1
%     filename_own=['MNL_C_dep_Niter' num2str(Niter),'.mat'];
%     elseif DepConsid_flag==0
%     filename_own=['MNL_C_indep_Niter' num2str(Niter),'.mat'];        
%     end 
% elseif estimation==4
%     if DepConsid_flag==1
%     filename_own=['MNL_CR_dep_Niter' num2str(Niter),'.mat'];
%     elseif DepConsid_flag==0
%     filename_own=['MNL_CR_indep_Niter' num2str(Niter),'.mat'];        
%     end 
% end 
% load(filename_own)
% 
J=dim.J;
X=data.X;
Z=data.Z;
dx=dim.dx;
dz=dim.dz;
n=dim.n;
nT=dim.nT;
Ti=dim.Ti;
house=dim.house;
Nburnin=0.3*Niter;
% 
% if csHetero==1
% C_sim=zeros(J,n,Niter);
% Howmanysegments=Niter/1000;
% 
% finish=(1:Howmanysegments+1-1)*(Niter/Howmanysegments);
% start=finish-(Niter/Howmanysegments)+1;    
%     C_sim(:,:,start(1):finish(1))=C_sim1;
%     C_sim(:,:,start(2):finish(2))=C_sim2;
%     C_sim(:,:,start(3):finish(3))=C_sim3;
%     C_sim(:,:,start(4):finish(4))=C_sim4;
%     C_sim(:,:,start(5):finish(5))=C_sim5;
%     % C_sim(:,:,start(6):finish(6))=C_sim6;
%     % C_sim(:,:,start(7):finish(7))=C_sim7;
%     % C_sim(:,:,start(8):finish(8))=C_sim8;
%     % C_sim(:,:,start(9):finish(9))=C_sim9;
%     % C_sim(:,:,start(10):finish(10))=C_sim10;
% end 


% Randomly select 100 units to compute elasticity 
% If set_elas_n=1:n, we would use all units
rng(123)
if n>100
    n_elas=100;%50
else 
    n_elas=10;
end 
indset_elas=sort(randsample(n,n_elas));
Ti_elas=Ti(indset_elas);nT_elas=sum(Ti_elas);

aa=ismember(repelem((1:n)',dim.Ti*J),indset_elas);
X_elas=X(aa==1,:);
%X_elas=X(ismember(repelem(house,J),indset_elas),:);
%house_elas=house(ismember(1:n,indset_elas));
% house_elas=ismember(repelem((1:n)',dim.Ti),indset_elas);
% dim.Ti(ismember(1:n,indset_elas))

if paramHetero==1
% Create Z_elas matrix
Z_elas=zeros(J*nT_elas,n_elas*dz);
row_start=1;
col_start=1;
for ii_elas=1:n_elas
row_finish=row_start+J*Ti_elas(ii_elas)-1;
col_finish=col_start+dz-1;
Z_elas(row_start:row_finish,col_start:col_finish)=X_elas(row_start:row_finish,:);
row_start=row_finish+1;
col_start=col_finish+1;
Z_elas=sparse(Z_elas);
end 
else 
    Z_elas=[];
end

price_elas=reshape(X_elas(:,1),J,[]);%J by nT_elas

%slice=10;
ownElas_sim=zeros(J,nT_elas,(Niter-Nburnin)/slice);
%crsElas_sim=zeros(J,J,nT_elas,(Niter-Nburnin)/slice);

count=1;
for iter=Nburnin+1:slice:Niter
    %iter
beta=beta_sim(:,iter);
beta_price=beta(1);
if paramHetero==1
    b=b_sim(:,:,iter);b_elas=b(indset_elas);
    b_elas_price=b_elas(1,:);
else
    b_elas=[];
end 

Vbar_elas=getVbar(beta,X_elas,b_elas,Z_elas,J,n_elas);
delta=delta_sim(:,iter);
if csHetero==1
    C=C_sim(:,:,count);C_elas=C(:,indset_elas);
else
    C_elas=ones(J,n_elas);
end 
ccp=compCCP(delta+Vbar_elas,C_elas,Ti_elas);%J by nT_elas

if paramHetero==1
    b_price_long=repelem(b_elas_price,Ti_elas);%1 by nT_elas
else
    b_price_long=0;
end 
ownElas_sim(:,:,count)=(beta_price+b_price_long).*price_elas.*(1-ccp);%J by nT_elas
% for jj=1:J
%     for kk=1:J
%         crsElas_sim(jj,kk,:,count)=-(beta_price+b_price_long).*price_elas(jj,:).*ccp(kk,:);%1 by nT_elas
%         if jj==kk
%         crsElas_sim(jj,kk,:,count)=(beta_price+b_price_long).*price_elas(jj,:).*(1-ccp(kk,:));%1 by nT_elas            
%         end 
%     end 
% end 
count=count+1;
end 

%pick (i,t) and iter, check if the two produced teh same own elast (J by 1)
% it=1;
% sum(ownElas_sim(:,it,iter)-diag(crsElas_sim(:,:,it,iter))~=0)

% Average over MCMC draws
meanOwnElas=mean(ownElas_sim,3);%J by nT_elas
%meanCrsElas=mean(crsElas_sim,4);%J by J by nT_elas

%pick (i,t), check if the two produced teh same own elast (J by 1)
%sum(meanOwnElas(:,it)-diag(meanCrsElas(:,:,it))~=0)

% For each i, compute the average over Ti
matOwnElas=zeros(J,n_elas);
for jj=1:J
    start=1;
    for ii_elas=1:n_elas
        finish=start+Ti_elas(ii_elas)-1;
        ii=indset_elas(ii_elas);
        matOwnElas(jj,ii_elas)=mean(meanOwnElas(jj,start:finish));
        start=finish+1;
    end 
end 
%matCrsElas=zeros(J,J,n_elas);
% for jj=1:J
%     for kk=1:J
%         for ii_elas=1:n_elas
%         ii=indset_elas(ii_elas);
%         matCrsElas(jj,kk,ii_elas)=mean(meanCrsElas(jj,kk,house_elas==ii));
%         end 
%     end 
% end 
%pick i, check if the two produced teh same own elast (J by 1)
%sum(matOwnElas(:,1)-diag(matCrsElas(:,:,1))~=0)

% Take average over units: aggregate elast 
aggOwnElas=mean(matOwnElas,2);