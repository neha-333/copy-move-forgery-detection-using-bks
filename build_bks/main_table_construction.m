function [BKS]=main_table_construction(database, fold_train)

	%BKS Table: 2^k x 3
	BKS=cell(2^8,3);

	%First Column: Binary 8 bit outputs
	for k=1:256
		BKS{k,1}=dec2mvl(k-1,8);
	end

	%Second column: frequency of the binary combination of outputs as being a copy move forgery according to the ground truth
        BKS(:,2)={0};

	%Third column: total frequency of that binary combination
	BKS(:,3)={0};

[BKS] = bks_table_construction_scale1(BKS, database, fold_train);
[BKS] = bks_table_construction_scale1_2(BKS, database, fold_train);
[BKS] = bks_table_construction_scale1_4(BKS, database, fold_train);


	[nrows, NCOLS]= size(BKS);
filename = ['bks_original_tables/bks-train-' int2str(fold_train) 'database-' database '.csv'];
fid = fopen(filename, 'w');
for row=1:nrows
    fprintf(fid, '%s %d %d \n', BKS{row,:});
end
fclose(fid);
end
