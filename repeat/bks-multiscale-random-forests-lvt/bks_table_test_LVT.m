function [mean_acc,mean_tpr,mean_fpr,std_acc,std_tpr,std_fpr]= bks_table_test(BKS, fold_test)
    k=1;
	images_per_fold=csvread('../../aux/5x2data/CPH_ALL.csv');
	
	disp('Starting classifying test images');


		disp(['Test image: ' int2str(images_per_fold(fold_test,k))]);

		[copiacolagem_result,sift_result,surf_result,hierarch_sift_result,zernike_result,zernike2_result,kpca_result,dct_result]=load_image(images_per_fold,fold_test,k);	

		image_result=zeros(size(zernike_result,1), size(zernike_result,2));
		for i=1:size(image_result,1)
            		for j=1:size(image_result,2)     
      		
				joined=horzcat(kpca_result(i,j),zernike2_result(i,j),dct_result(i,j),hierarch_sift_result(i,j),copiacolagem_result(i,j),sift_result(i,j),surf_result(i,j),zernike_result(i,j));
     				
                		joined=joined==255;
         			probability_image(i,j)=BKS(bi2de(joined)+1,9);

         			%probability > 50% => copied and moved pixel
		       		if (BKS(bi2de(joined)+1,9))>0.5
                    			image_result(i,j)=1; 
                		else
                    			image_result(i,j)=0;
                		end
			end
    		end

		disp('BKS classification done. Varying the threshold according to each pixel neighborhood and creating new probability image.');
	
		%New output image 
		new_image_result=zeros(size(zernike_result,1), size(zernike_result,2));
	        
		%The probability map : convolved with a 3x3 filter
		%mean probabilities of each pixel in a 3x3 neighborhood
		 
		image_result = conv2(image_result, 1.0 / 9 * ones(3), 'valid');
	 
		for i=1:size(image_result,1)
            		for j=1:size(image_result,2)

					%new threshold using LVT 
                			new_threshold=0.5-2*(image_result(i,j)-0.5)*0.2;
					if(probability_image(i,j)>new_threshold)	
						new_image_result(i,j)=255;
					end	
				end
    		end
	

		ground_truth=imread(['../../aux/cph_database/scale1/CPHPALL/' int2str(images_per_fold(fold_test,k)) '/' int2str(images_per_fold(fold_test,k)) '_gt.png']);
		[tpr,fpr,acc,forged]=calculate_statistics(new_image_result, ground_truth(:,:,1));
		acc_vec(k)=acc;
		tpr_vec(k)=tpr;
		fpr_vec(k)=fpr;
		disp('\nImage pixels classified.');
        
	

%disp('finished');

mean_acc=mean(acc_vec);
mean_tpr=mean(tpr_vec);
mean_fpr=mean(fpr_vec);
std_acc=std(acc_vec);
std_tpr=std(tpr_vec);
std_fpr=std(fpr_vec);

end
