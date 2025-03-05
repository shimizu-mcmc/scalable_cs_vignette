% The code computes objects related to the estimated clustering structure 
% It computes the similarity matrix, and estimated consideration sets

% Similarity matrix
n=dim.n;
SimilarityMatrix_sim=zeros(n,n,(Niter-Nburnin)/slice);
count=1;
for iter=Nburnin+1:slice:Niter
    %iter
    for ii=1:n
        for jj=1:n
            SimilarityMatrix_sim(ii,jj,count)=(class_sim(ii,iter)==class_sim(jj,iter));
        end 
    end 
    count=count+1;
end 
SimilarityMatrix=mean(SimilarityMatrix_sim,3);
figure; heatmap(SimilarityMatrix(1:min(n,100),1:min(n,100)),'ColorLimits',[0 1],Colormap=sky(30));%set(gca,'fontsize', 3);
Ax = gca;
Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
Ax.YDisplayLabels = nan(size(Ax.YDisplayData));

set(gcf, 'PaperPosition', [0 0 6 5]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6 5]); %Set the paper to have width 5 and height 5.    
ylabel('household k');
xlabel('household i');
set(gca,'FontSize',12)
filename=['SimilarityMatrix']
saveas(gcf, filename, 'png');

% Estimated consideration sets
% posterior means 
meanC=mean(C_sim,3);
% Use the prior mean/median inclusion prob as a threshold
estC=(meanC>=0.2658);
