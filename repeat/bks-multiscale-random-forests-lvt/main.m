function [mean_acc,mean_tpr,mean_fpr,std_acc,std_tpr,std_fpr]=main (nt, mtry, database_name, fold_train, fold_test)

	disp('Step 1: Load the bks model : (multiscale) for the trained BKS classifier');
	BKS = importdata(['../../aux/built_bks_tables/multiscale_bks_rf/UNCOMPRESSED/bks-train-' int2str(fold_train) 'database-' database_name '_' num2str(nt) '_' num2str(mtry) '.csv']);

	disp('Step 2: Do the test and apply the Local Variable Threshold to improve classification');
	[mean_acc,mean_tpr,mean_fpr,std_acc,std_tpr,std_fpr]=bks_table_test_LVT(BKS, fold_test);
	
end
