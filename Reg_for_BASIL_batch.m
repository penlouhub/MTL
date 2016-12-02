function Reg_for_BASIL_batch(varargin)
% Written by Penny Cristinacce 01/04/16

list=importdata('D:\WT\ANALYSIS\STUDY\foldersandinfo.txt');

folderlist=char(list.textdata{:,1});
folderlist=cellstr(folderlist);
savelist=char(list.textdata{:,2});
savelist=cellstr(savelist);

x = varargin{1};
y = varargin{2};



for ii=x:y
  
name=fullfile('D:\WT\DATA\Study_data',char(folderlist(ii)),'\PARREC\');
name
ii
cd(name);
%registration
[TI, label, cont, m0, ASLinfo] = RegisterASL(name);


% flip images and save control and tag images

conttag(:,:,:,:)=cat(4, cont(:,:,:,1),label(:,:,:,1),cont(:,:,:,2),label(:,:,:,2),cont(:,:,:,3),label(:,:,:,3),cont(:,:,:,4),label(:,:,:,4),cont(:,:,:,5),label(:,:,:,5),cont(:,:,:,6),label(:,:,:,6));

nslices=16;
nTI=6;
for i=1:nslices
    for j=1:nTI*2
      conttag_rot(:,:,i,j)=flipud(rot90(conttag(:,:,i,j),3));
    end
end
conttag_nii = make_nii(conttag_rot, [3.5 3.5 4.5], [0 0 0], 8);
save_nii(conttag_nii,'ASL_reg_conttag.nii')

% flip images and difference image
 sub = label - cont;
for k=1:nslices
    for l=1:nTI
      sub_rot(:,:,k,l)=flipud(rot90(sub(:,:,k,l),3));
    end
end

sub_nii = make_nii(sub_rot, [3.5 3.5 4.5], [0 0 0], 8);
save_nii(sub_nii,'ASL_reg_sub.nii');

% flips image and saves M0 image
for m=1:nslices
    m0_rot(:,:,m)=flipud(rot90(m0(:,:,m),3));
end

m0_nii = make_nii(m0_rot, [3.5 3.5 4.5], [0 0 0], 8);
save_nii(m0_nii,'ASL_reg_M0.nii');

mkdir(['C:\Work\CBI_virtualbox_machine\shared\',char(savelist(ii))]);
copyfile(['D:\WT\DATA\Study_data\',char(folderlist(ii)),'\PARREC\ASL_reg_conttag.nii'],['C:\Work\CBI_virtualbox_machine\shared\',char(savelist(ii)),'\ASL_reg_conttag.nii']);
copyfile(['D:\WT\DATA\Study_data\',char(folderlist(ii)),'\PARREC\ASL_reg_sub.nii'],['C:\Work\CBI_virtualbox_machine\shared\',char(savelist(ii)),'\ASL_reg_sub.nii']);
copyfile(['D:\WT\DATA\Study_data\',char(folderlist(ii)),'\PARREC\ASL_reg_M0.nii'],['C:\Work\CBI_virtualbox_machine\shared\',char(savelist(ii)),'\ASL_reg_M0.nii']);

end

