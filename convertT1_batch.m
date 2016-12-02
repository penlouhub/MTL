function convertT1_batch(folderlist,T1name,slices)
% 19/02/16
%loads REC file for T1 structral and saves Analyze and nifti files with neurological
%convention (R is R, L is L)
% batch processes all data and saves in DATA directory
% T1_dti is coronal oblique, as acquired, and matches dti
% xT1_aslt is axial, for registration to ASL images
%01/12/16 


voxdim=[0.83 0.83 0.83];

fname=fullfile(char(['*T1_',T1name,'*.REC'])); %removed {1} 01/12/16
pname=fullfile('D:\WT\DATA\Study_data',folderlist,'PARREC\');
%testing
fname
pname 
slices
T1name


slicen=str2num(slices);%added str2num 01/12/16
x=288;
y=288;
num_elements = x * y * slicen;

path=dir(fullfile([pname,fname])); %set path

fid = fopen([pname,path.name]); %open data stream for rec file

cd(pname);
mkdir('t1');
cd(fullfile(pname,'t1'));

img = fread(fid,num_elements,'int16=>int16')'; % open recfile to int16
img = reshape(img,[x y slicen]);

img_rot=zeros(x,y,slicen);
    for i=1:slicen;
        img_rot(:,:,i)=rot90(img(:,:,i),2);
    end

save_avw('T1_dti', img_rot, 16, voxdim);

%Make nii
img_rot_nii = make_nii(img_rot, voxdim, [0 0 0], 8);
save_nii(img_rot_nii,'T1_dti.nii')

%Rotate to axial

img_prot=permute(img_rot,[1,3,2]);
    for j=1:y;
        img_fprot(:,:,j)=fliplr(img_prot(:,:,j));
    end
  

save_avw('T1_asl', img_fprot, 16, voxdim);

%Make nii
img_fprot_nii = make_nii(img_fprot, voxdim, [0 0 0], 8);
save_nii(img_fprot_nii,'T1_asl.nii')


end

