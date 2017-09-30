function [tpr,fpr,acc,forged]=calculate_statistics(technique_binary_image, ground_truth)

technique_binary_image = technique_binary_image./255.0;
ground_truth = ground_truth./255.0;

false_positives=0;
false_negatives=0;
true_positives=0;
true_negatives=0;
totalCopyMove = 0;
totalNormal = 0;
forged=0;

for i=1:size(technique_binary_image,1)
	for j=1:size(technique_binary_image,2) 
		if technique_binary_image(i,j)==ground_truth(i,j) && ground_truth(i,j)~=0
			true_positives=true_positives+1;
            forged=forged+1;
            
     
            
		end
		
		if technique_binary_image(i,j)==ground_truth(i,j) && ground_truth(i,j)==0
			true_negatives=true_negatives+1;
		end

		if technique_binary_image(i,j)~=ground_truth(i,j) && ground_truth(i,j)~=0
			false_negatives=false_negatives+1;
            
            
		end
		
		if technique_binary_image(i,j)~=ground_truth(i,j) && ground_truth(i,j)==0
			false_positives=false_positives+1;
            forged=forged+1;
            
            
        end
        if ground_truth(i,j)~=0
            totalCopyMove = totalCopyMove + 1;
        end
        if ground_truth(i,j)==0
            totalNormal = totalNormal + 1;
        end
	end
end

tpr=(true_positives)/totalCopyMove;
fpr=(false_positives)/totalNormal;
acc = (tpr + (1 - fpr))/2;
f=true_negatives+false_negatives;
miss_classified=forged-totalCopyMove;
miss_classified2=abs(totalNormal-f);

if isnan(tpr)
   tpr=0; 
end

if isnan(fpr)
    fpr=0;
end

if (isnan(acc))
    acc=0;
end
fprintf('True Positives: %d \nFalse Positives: %d\nTrue Negatives: %d\nFalse Negatives: %d\nPredicted as Forged: %d \nPredicted as Not Forged: %d\nActually Forged: %d\nActually Not Forged: %d\nAccuracy %f\nTrue Positive Rate %f\nFalse Positive Rate %f\n',true_positives,false_positives,true_negatives,false_negatives,forged,f,totalCopyMove,totalNormal,acc,tpr,fpr);
dlmwrite('results/rf_lvt-Results_for_fold_2_first_image.txt',horzcat(true_positives,false_positives,true_negatives,false_negatives,forged,f,totalCopyMove,totalNormal,acc,tpr,fpr), '-append');
end


