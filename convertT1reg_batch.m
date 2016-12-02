function convertT1reg_batch(folderlist,slicereg,x,y)
% 19/02/16
%loads REC file for T1 structral and saves Analyze and nifti files with neurological
%convention (R is R, L is L)
% batch processes all data and saves in DATA directory
% T1_dti is coronal oblique, as acquired, and matches dti
% xT1_aslt is axial, for registration to ASL images



fname=fullfile(char('*T1_reg*.REC'));
pname=fullfile('D:\WT\DATA\Study_data',folderlist,'PARREC\');
%testing
fname
pname 

slicen = slicereg; %39 (GE) or 53 (SE ASL)

x=240;
y=240;
num_elements = x * y * slicen;

voxdim=[0.93 0.93 1.35];


path=dir(fullfile([pname,fname])); %set path

fid = fopen([pname,path.name]); %open data stream for rec file

img = fread(fid,num_elements,'int16=>int16')'; % open recfile to int16

img = reshape(img,[x y slicen]);

img_rot=zeros(x,y,slicen);
    for i=1:slicen;
        img_rot(:,:,i)=rot90(img(:,:,i),2);
    end

save_avw('T1_reg', img_rot, 16, voxdim);

cd(pname);
mkdir('t1');
cd(fullfile(pname,'t1'));
save_avw('T1_reg', img_rot, 16, voxdim);

%Make nii
img_rot_nii = make_nii(img_rot, voxdim, [0 0 0], 8);
save_nii(img_rot_nii,'T1_reg.nii')


end

