function [BKS] = bks_table_construction_scale1_2(BKS, database_name, fold_train)

	images_per_fold=csvread('../aux/5x2data/CPH_ALL.csv');

	disp('Using scale 1/2 to fill bks tables');
  
	for k=1:size(images_per_fold,2) 
		
		name_image=images_per_fold(fold_train,k);

		disp(['Image ' int2str(k) ':' int2str(name_image)]);

		copiacolagem_result=imread(['../aux/output_cph_database/scale1.2/copiacolagem/CPHPALL/' num2str(name_image) '/' num2str(name_image) '_post.png']);
		sift_result=imread(['../aux/output_cph_database/scale1.2/sift/CPHPALL/' num2str(name_image) '/' num2str(name_image) '_post.png']);
		surf_result=imread(['../aux/output_cph_database/scale1.2/surf/CPHPALL/' num2str(name_image) '/' num2str(name_image) '_post.png']);
		hierarch_sift_result=imread(['../aux/output_cph_database/scale1.2/hierarch-sift/CPHPALL/' num2str(name_image) '/' num2str(name_image) '_post.png']);
		zernike_result=imread(['../aux/output_cph_database/scale1.2/zernike/CPHPALL/' num2str(name_image) '/' num2str(name_image) '_post.png']);
	    	zernike2_result=imread(['../aux/output_cph_database/scale1.2/zernike2/CPHPALL/' num2str(name_image) '/' num2str(name_image) '_post.png']);
    		kpca_result=imread(['../aux/output_cph_database/scale1.2/kpca/CPHPALL/' num2str(name_image) '/' num2str(name_image) '_post.png']);
    		dct_result=imread(['../aux/output_cph_database/scale1.2/dct/CPHPALL/' num2str(name_image) '/' num2str(name_image) '_post.png']);
	
		ground_truth=imread(['../aux/cph_database/scale1.2/CPHPALL/' int2str(images_per_fold(fold_train,k)) '/' int2str(images_per_fold(fold_train,k)) '_gt.png']);
		
		for i=1:size(ground_truth,1)
            		for j=1:size(ground_truth,2)
     
                		joined=horzcat(dct_result(i,j),zernike_result(i,j),zernike2_result(i,j),hierarch_sift_result(i,j),kpca_result(i,j),sift_result(i,j),surf_result(i,j),copiacolagem_result(i,j));

                		joined=joined==255;
                		joined2=sprintf('%d',joined);
                		
                		[x,~]=find(strcmp(BKS, joined2),1);
                		if ground_truth(i,j)==255                
                    			BKS{x,2}=BKS{x,2}+1;
                		end
                		BKS{x,3}=BKS{x,3}+1;
            		end
        	end
	end


end
