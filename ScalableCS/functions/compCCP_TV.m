% Given the 'base' CS, generate time-varying CS
% C is J by n (the base CS)
% for each unit and time, with 50% prob., randomply add one from the items
% that are not included in C(:,ii)
function ccp=compCCP_TV(V,C,Ti)

% Compute V without delta
%V=getV(beta,X,b,Z,J,n);
% Add delta 
%V=delta+V;
[J,n]=size(C);
T=Ti(1);
TVCS_case=1;
CS_TV_tmp=zeros(J,T,n);
if TVCS_case==1
    for ii=1:n
    for tt=1:T
        if tt==1
            CS_TV_tmp(:,tt,ii)=C(:,ii);
        else
            CS_TV_tmp(:,tt,ii)=CS_TV_tmp(:,tt-1,ii);
        end 
        if tt==3%floor(T/2)+1
        if sum(C(:,ii))<J && rand<0.5
            item_to_add=randsample(find(C(:,ii)==0),1);
            CS_TV_tmp(item_to_add,tt,ii)=1; 
        end 
        end
    end 
    end 
elseif TVCS_case==2
    for ii=1:n
    for tt=1:T
        CS_TV_tmp(:,tt,ii)=C(:,ii);
            flip_coin=rand;
            if flip_coin<1/3
                if sum(C(:,ii))<J 
                item_to_add=randsample(find(C(:,ii)==0),1);
                CS_TV_tmp(item_to_add,tt,ii)=1;
                end 
            elseif flip_coin>2/3
                if sum(C(:,ii))>1
                item_to_remove=randsample(find(C(:,ii)==1),1);
                CS_TV_tmp(item_to_remove,tt,ii)=0;  
                end 
            end 
    end 
    end 
elseif TVCS_case==3
    for ii=1:n
    for tt=1:T
        if tt==1
        CS_TV_tmp(:,tt,ii)=C(:,ii);
        elseif tt>1
        CS_TV_tmp(:,tt,ii)=CS_TV_tmp(:,tt-1,ii); 
            if sum(CS_TV_tmp(:,tt,ii))<J && rand<0.5
            item_to_add=randsample(find(CS_TV_tmp(:,tt,ii)==0),1);
            CS_TV_tmp(item_to_add,tt,ii)=1;    
            end
        end 
    end 
    end 
end 
CS_TV=reshape(CS_TV_tmp,J,[]);



ccp=exp(V).*CS_TV;
%ccp=exp(V).*repelem(C,1,Ti');

ccp=ccp./sum(ccp);
end 