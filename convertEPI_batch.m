function convertEPI_batch(folderlist,slicethick)
% 19/02/16
%loads REC file for EPI and saves Analyze and nifti files with neurological
%convention (R is R, L is L)
% batch processes all data and saves in DATA directory
% 


fname=fullfile(char('*EPI_REG_ASL*.REC'));
%fname=fullfile(char('*EPI_REG_ASL_WB_*.REC'));
pname=fullfile('D:\WT\DATA\Study_data',folderlist,'PARREC\');
%testing
fname
pname 
slicethick


x=64;
y=64;
slicen=35;

num_elements = x * y * slicen;


path=dir(fullfile([pname,fname])); %set path

fid = fopen([pname,path.name]); %open data stream for rec file

img = fread(fid,num_elements,'int16=>int16')'; % open recfile to int16

img = reshape(img,[x y slicen]);

img_rot=zeros(x,y,slicen);
    for i=1:slicen;
        img_rot(:,:,i)=rot90(img(:,:,i),2);
    end
    
cd(pname);
mkdir('t1');
cd(fullfile(pname,'t1'));
save_avw('EPI_reg', img_rot, 16, [3.5 3.5 slicethick]);

%Make nii
img_rot_nii = make_nii(img_rot, [3.5 3.5 slicethick], [0 0 0], 8);
save_nii(img_rot_nii,'EPI_reg.nii')

end

