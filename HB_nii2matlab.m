function [imgs_mat, vsize]= HB_nii2matlab(fname)
% Same as MSD_nii2matlab, but any NANs are converted to 0
nii_obj = nifti(fname);
vsize(1) = abs(nii_obj.mat(1,1));
vsize(2) = abs(nii_obj.mat(2,2));
vsize(3) = abs(nii_obj.mat(3,3));
imgs_mat = flipdim(permute(nii_obj.dat(:,:,:,:,:,:),[2 1 3 4 5 6]),1);
imgs_mat(find(isnan(imgs_mat))) = 0;
