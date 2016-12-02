
function Prep_for_EDDY_batch(varargin)
% Written by Penny Cristinacce 11/05/16
% text loading changed 01/12/16

list=importdata('D:\WT\ANALYSIS\STUDY\foldersandinfo_temp.txt');

folderlist=char(list.textdata{:,1});
folderlist=cellstr(folderlist);
analysislist=char(list.textdata{:,2});
analysislist=cellstr(analysislist);

x = varargin{1};
y = varargin{2};



for i=x:y
% for i=1:1
analysislist(i)
cdir='D:\WT\MATLAB\Code for WT project\';
ddir=fullfile('D:\WT\DATA\Study_data\',char(folderlist(i)),'\PARREC\');
if list.textdata{i,3}=='C'
sdir=fullfile('D:\WT\ANALYSIS\STUDY\CONTROLS\INCLUDED\',char(analysislist(i)),'\eddy\');  
else
sdir=fullfile('D:\WT\ANALYSIS\STUDY\PATIENTS\',char(analysislist(i)),'\eddy\');
end
fsldir=fullfile('C:\Work\CBI_virtualbox_machine\shared\',char(analysislist(i)),'\eddy\');

mkdir(sdir); 
mkdir(fsldir); 
create_nii_for_eddy(ddir,fsldir);

end

end



