% Niter = number of MCMC iterations
% model can be one of the 4 : 
% MNL(simple multinomial logit)
% MNL_R (MNL with random effects) 
% MNL_C (MNL with consideration set heterogeneity)
% MNL_RC (MNL with both heterogeneity, the full model)

function res=scalableCS(YData,XData,Niter,model)

if model=="MNL"
    estimation=1;
elseif model=="MNL_R"
    estimation=2;
elseif model=="MNL_C"    
    estimation=3;
elseif model=="MNL_RC"
    estimation=4;
end 

if estimation==2 || estimation==4 %MNL_R or MNL_RC
    paramHetero=1;
else
    paramHetero=0;
end 
if estimation==3 || estimation==4 %MNL_C or MNL_RC
    csHetero=1;
else
    csHetero=0;
end 

%If we define C_sim=zeros(J,n,Niter), it can be too large. Save every "slice"th draw of C so that we keep 1000 draws.
if Niter>1000
    slice=Niter/1000;
else
    slice=1;
end 
[data,dim]=prepData(YData,XData,paramHetero);

options.estimation=estimation;
options.DepConsid_flag=1;
options.includeDelta=1;
options.prior_attention_prob=1;
options.kMax=10;
options.slice=slice;
options.deltaTMH_flag=1;

tic;
[beta_sim,delta_sim,accBeta_sim,accDelta_sim,...
b_sim,accB_sim,D_sim,...
C_sim,accC_sim,accDiffC_sim,...
gamma_sim,class_sim,omega_sim,kMax_sim,kUniq_sim,kappa_sim]=runMCMC(Niter,data,dim,options);
ElapsedTime=toc;

% post MCMC analysis
% Compute posterior statistics, convergence diagnostics (ineff. factors)
run("postMCMC1.m")

if estimation==3 || estimation==4
    % Compute estimated consideration sets
    run("postMCMC2.m")
else 
    estC=[];SimilarityMatrix=[];
end 
% Compute price sensitivity wrt price 
run("postMCMC3.m")


% Display estimates
% beta and sqrt of D
if paramHetero==0
postMN=[meanPara.Beta];
postSD=[sdPara.Beta];
postLB=[lbPara.Beta];
postUB=[ubPara.Beta];
INEF=[inefPara.Beta];
ParaNames={'Beta' 'sqrtD'};
elseif paramHetero==1
postMN=[meanPara.Beta;meanPara.SqrtD];
postSD=[sdPara.Beta;sdPara.SqrtD];
postLB=[lbPara.Beta;lbPara.SqrtD];
postUB=[ubPara.Beta;ubPara.SqrtD];
INEF=[inefPara.Beta;inefPara.SqrtD];
ParaNames={'Beta' 'sqrtD'};
end 
table(postMN,postSD,postLB,postUB,INEF,'VariableNames',["Mean","SD","95LB","95UB","INEF"],'RowNames',ParaNames)

% delta (brand FEs)
postMN=[meanPara.Delta];
postSD=[sdPara.Delta(1:dim.J-1);NaN];
postLB=[lbPara.Delta(1:dim.J-1);NaN];
postUB=[ubPara.Delta(1:dim.J-1);NaN];
INEF=[inefPara.Delta;NaN];
ParaNames=cell(dim.J,1);
for jj=1:dim.J
    ParaNames(jj)=cellstr(['Delta ',num2str(jj)]);
end 
table(postMN,postSD,postLB,postUB,INEF,'VariableNames',["Mean","SD","95LB","95UB","INEF"],'RowNames',ParaNames)


% Display a table of price senssitivities
table((1:dim.J)',abs(aggOwnElas),'VariableNames',["brand","price sensitivity"])

% Store results
res.meanPara=meanPara;
res.sdPara=sdPara;
res.lbPara=lbPara;
res.ubPara=ubPara;
res.inefPara=inefPara;
res.estC=estC;
res.SimilarityMatrix=SimilarityMatrix;
res.aggOwnElas=aggOwnElas;
end 