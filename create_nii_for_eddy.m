% 31st October 2015 Written by PLHC
% Loads and scales PARREC data and saves data in format suitable for input
% to eddy (FSL)
% 11/05/16 Added code to automatically load inputs from PAR file
% ddir = data directory  sdir = save directory
function [] = create_nii_for_eddy(ddir,sdir)

%Make and define directories


% Defines inputs
parfile=dir(fullfile(ddir,'*L_DTI*.PAR'));
fid = fopen(fullfile(ddir,parfile.name));
s = textscan(fid,'%s','Delimiter','\n');
s = s{1};
slicen = s{22,1};
slicen=str2num(slicen(end-2:end));
gradient=s{45,1};
gradn=str2num(gradient(end-2:end));

a=s{300,1};
a=textscan(a,'%n','Delimiter','\n');
a=a{1,1};
x= a(10);
y = a(11);

outdim = a(29);
outdim(2) = a(30);
outdim(3) = a(23);
scalecorrect_a = a(14);

parfile=dir(fullfile(ddir,'*R_DTI_SENSE*.PAR'));
fid = fopen(fullfile(ddir,parfile.name));
s = textscan(fid,'%s','Delimiter','\n');
s = s{1};
b=s{120,1};
b=textscan(b,'%n','Delimiter','\n');
b=b{1,1};

scalecorrect_b = b(14);


num_elements = x * y * slicen * gradn;

% LOAD LEFT diffusion data
recfile=dir(fullfile(ddir,'*L_DTI*.REC'));
fid = fopen(fullfile(ddir,recfile.name));
img = fread(fid,num_elements,'int16=>int16')'; % open recfile to int16

% Scale images
scalemax = 1000;
maxrawa = double(max(img));
scalefact = scalemax /(maxrawa/scalecorrect_a);
img = double(img);
img = img/scalecorrect_a;
img_sc = img .* scalefact;

% Reshape
img_sc_l = reshape(img_sc,[x y slicen gradn]);   

% Flip to save as neurological convention
for i=1:gradn
    for j=1:slicen
    img_sc_l(:,:,j,i)=rot90(img_sc_l(:,:,j,i),2);
    end
end

img_lb0=img_sc_l(:,:,:,gradn(end));

% Save nii
% NOTE: Origin incorrect - recified later in code 
diffL_nii = make_nii(img_sc_l, outdim, [1 1 1], 8);
save_nii(diffL_nii,[sdir,'diffL.nii']);

diffLb0_nii = make_nii(img_lb0, outdim, [1 1 1], 8);
save_nii(diffLb0_nii,[sdir,'diffLb0.nii']);



%LOAD RIGHT diffusion data , b0 extraction
recfile=dir(fullfile(ddir,'*R_DTI_SENSE*.REC'));
fid = fopen(fullfile(ddir,recfile.name));
img = fread(fid,num_elements,'int16=>int16')'; % open recfile to int16



% Scale images
maxrawa = double(max(img));
scalefact = scalemax /(maxrawa/scalecorrect_b);
img = double(img);
img = img/scalecorrect_b;
img_sc = img .* scalefact;


% Reshape
img_sc_r = reshape(img_sc,[x y slicen gradn]);


% Flip to save as neurological convention
for i=1:gradn
    for j=1:slicen
    img_sc_r(:,:,j,i)=rot90(img_sc_r(:,:,j,i),2);
    end
end

img_rb0=img_sc_r(:,:,:,gradn(end));

% Save nii
% NOTE: Origin incorrect - recified later in code 
diffR_nii = make_nii(img_sc_r, outdim, [1 1 1], 8);
save_nii(diffR_nii,[sdir,'diffR.nii']);

diffRb0_nii = make_nii(img_rb0, outdim, [1 1 1], 8);
save_nii(diffRb0_nii,[sdir,'diffRb0.nii']);