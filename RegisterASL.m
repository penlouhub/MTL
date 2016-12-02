function [TI, perf, cont, pd, ASLinfo, fnroot ] = RegisterASL(name)
% Written by Penny Cristinacce 01/04/16

% From HB code GetImageDataAvgAlignTestnii.m 
% If these folders do not exist, read the image data and M0 data, then return 
% tagged image data in perf, untagged in cont, M0 in pd, TI values in TI 
% and header data in ASLinfo.
% fnroot holds a shortened name which can be used as the root for the results
% directory.
%Also reads the SPM transformation matrices and concatenates them into 
%the text file alignDiags.txt in the root directory, where it can be cheked
%subsequently.
%************************************************
% AVERAGES Perfusion, Control image data over dynamics
%--------------------------

  
% get number and values of TI (inversion times) and read data files
        nTI=6;
        TI=[600 1000 1350 1700 2100 2500]; %inversion times
        TI = TI';

cd(name);            % change to correct dir if required

lowTI=fullfile(char('*ASLSE_600*.REC'));
fname=dir(fullfile([name,lowTI]));
m0=fullfile(char('*ASLSE_M0*.REC'));
M0=dir(fullfile([name,m0]));


fnroot = strrep(fname,['_',num2str(TI(1))],'');      % set root filename for results
fnroot = regexprep(fnroot.name,'600_SENSE_[0-9]+_1.REC','');   

[pf ASLinfo cn]=MSD_parrecread(fname.name); % reads in perf, cont as (x y slices dynamics)
[nx ny nslices ndynamics] = size(pf);
fov = str2num(ASLinfo.FOV);                            % set voxel size from FOV and no of voxels
vsize(1:2) = fov(1)/nx;
vsize(3) = fov(2)/nslices;

% define arrays for the rest of the TI data
perfdyn = zeros(nx,ny,nslices,ndynamics,nTI);
contdyn = zeros(nx,ny,nslices,ndynamics,nTI); 
perfdyn(:,:,:,:,1) = pf;
contdyn(:,:,:,:,1) = cn;

olddir = pwd;
dirnm = [fnroot,'_TI_',num2str(TI(nTI))];          %create name of last aligned image directory
reply = 'Y';
% COMMENTED OUT REQUEST TO REDO 26/05/16
% if (exist(dirnm) && exist([fnroot,'_TI_',num2str(TI(1))]))
%   reply = input('Aligned files exist - do you want to redo? Y/N : ', 's');
%   if isempty(reply)
%     reply = 'N';
%   end;
% end;
if upper(reply) == 'Y'
    for i = 1:nTI
      dirnm = [fnroot,'_TI_',num2str(TI(i))];         
      if exist(dirnm) 
        delete ([dirnm,'\*.*']); 
      end;
    end;
    dirnm = [fnroot,'_M0'];          %create name of last aligned image directory
    if exist(dirnm) 
      delete ([dirnm,'\*.*']); 
    end;
    for i = 2:nTI
        % do some fancy fiddling with filename to get a match
        fn = strrep(lowTI,num2str(TI(1)),num2str(TI(i)));      % replace TI value
        s = regexprep(fn,'[0-9]+_1.REC','*.REC');            % replace sequence no with *
        fn = dir(s);  
        if size(fn,1) > 1
          hb = input('Too many files - sort before continuing');
        end;
        [pf info cn]=MSD_parrecread(fn.name); 
        perfdyn(:,:,:,:,i) = pf;
        contdyn(:,:,:,:,i) = cn;

    end
    [pd info_pd]=MSD_parrecread(M0.name); % get proton density data
    if (size(pd,4) > 1)         % some protocols take >1 M0 images; if so just average over dynamics
        pd = mean(pd,4);
    end;

    % split images into individual dynamics for alignment
    for n=1:nTI
        opdir = ([fnroot,'_TI_',num2str(TI(n))]);
        mkdir (opdir);
        cd(opdir);
        
% Removed code to see if any dynamics need to be discarded

        for d = 1:ndynamics

            imgnameSL=['T_',sprintf('%02.0f',d),'perf.nii'];
            writenii_HB(imgnameSL,perfdyn(:,:,:,d,n),vsize);
            imgnameSL=['T_',sprintf('%02.0f',d),'cont.nii'];
            writenii_HB(imgnameSL,contdyn(:,:,:,d,n),vsize);
       
        end;
        cd (olddir);
    end;
    
    % write M0 image to same format
    opdir = ([fnroot,'_M0']);
    mkdir (opdir);
    olddir=cd(opdir);
    imgnameSL='M0.nii';
    writenii_HB(imgnameSL,pd,vsize);
    cd (olddir);


     SPM_AlignImagesTestnii(fnroot, TI, nTI, ndynamics);  
% comment out for no registration
    WriteAlignDiags(fnroot,TI,nTI);
end;

% reconstitute matrices from aligned images
for n = 1:nTI
    opdir = ([fnroot,'_TI_',num2str(TI(n))]);
    [perf(:,:,:,n)  cont(:,:,:,n)] = getPerfTestnii(opdir,ndynamics);
end
opdir = ([fnroot,'_M0']);
cd (opdir);
pd = HB_nii2matlab('rM0.nii'); %comment out for no reg
%pd = HB_nii2matlab('M0.nii');
cd (olddir);

end
