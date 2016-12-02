function [ imperf, imcont ] = getPerfTestnii( dirnm,ndynamics )
% change to subdirectory given by dirnm. Read images rperf_N and rcont_N, where
% N = 1:ndynamics, store in matrices and return
% NB DYNAMICS ARE AVERAGED HERE AND NOT IN CALLING ROUTINE AS EARLIER
% This is because knowledge of how many dynamics is here if some are
% omitted.

    olddir=cd(dirnm);
    j = 0;
    for i = 1:ndynamics
      if exist(['rT_',sprintf('%02.0f',i),'perf.nii'])
         j = j + 1;
         im1 = HB_nii2matlab(['rT_',sprintf('%02.0f',i),'perf.nii']);
         imperf(:,:,:,j) = im1;
         im1 = HB_nii2matlab(['rT_',sprintf('%02.0f',i),'cont.nii']);
         imcont(:,:,:,j) = im1;
      else    %added PLC to remove registration step
         j = j + 1;
         im1 = HB_nii2matlab(['T_',sprintf('%02.0f',i),'perf.nii']);
         imperf(:,:,:,j) = im1;
         im1 = HB_nii2matlab(['T_',sprintf('%02.0f',i),'cont.nii']);
         imcont(:,:,:,j) = im1;
      end;
    end;
    imperf = squeeze(mean(imperf,4));
    imcont = squeeze(mean(imcont,4));
    cd (olddir);
end

