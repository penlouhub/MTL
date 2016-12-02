function [im1 information im2] = MSD_parrecread(filename)
%Reads in im and im2, which should be control and tag for an ASL sequence.
%should also read an M0 in
%
%Just a note, this method fails due to memory resources if you try and read
%too many images
%
%[quickly] edited my Mark D to scale every image. I try to do something
%more robust in the future. 
%needs to be in a set order
%returens im(x,y,slice, dynamic) 
%Updated by MSD (Oct 09) as Philips changed the order of images, now it
%should be order independent
%Note, if anyone ever reads this... some checking should be done, e.g. is
%the code reading in all the files, etc
%should be easy to edit to read LL type ASL in. 

filename = strtok(filename, '.');

info = MSD_parrecinfo(filename);
information = info;
x = info.ReconResolution(1,1);
y = info.ReconResolution(1,2);
slices = info.MaxNumberSlicesLocations;
dynamics = info.MaxNumberDynamics;
[start finish] = size(info.IndexRECFile);
dynamics = information.MaxNumberDynamics;
rs = info.RescaleSlope;
ri = info.RescaleIntercept;
ss = info.ScaleSlope;
t = info.DynScanBeginTime(1:dynamics);
clear info;
flag = nnz(diff(ri))+nnz(diff(rs))+nnz(diff(ss));

[fid,message]=fopen([filename,'.REC']);

slices = information.MaxNumberSlicesLocations;
im1 = zeros(x, y,slices  , information.MaxNumberDynamics ); %add LL at the end
im2 = zeros(x, y,slices  , information.MaxNumberDynamics );
Array = zeros(x,y,finish);

count_tag = 0;
count_cont = 0;

for inx_p=1:finish %p is because it's plus one from the file inx.

    im_dumy = fread(fid, x*y, 'uint16=>double');    %Read single image.
    im_dumy = reshape(im_dumy, [x y]);
    %Apply scaling
    im_dumy(:,:) = im_dumy(:,:)./ss(inx_p) + ri(inx_p)/(rs(inx_p)*ss(inx_p));
    %rotate
    im_dumy = permute(im_dumy,[2 1]);
    
    if information.LabelType(inx_p) == 1       %Control - assuming this is im1 at the moment   
        %x - y - Slice - Dynamic 
        im1(:,:, information.SliceNumber(inx_p), information.DynamicScanNumber(inx_p), information.CardiacPhaseNumber(inx_p)   ) = im_dumy(:,:);
        count_cont = count_cont + 1;
    else   %Label - assuming this is im2 at the moment, if not ASL then this should not be entered. Asssume Label should be 1.
%         if information.LabelType(inx_p) ~= 2
%             error('Check code, you shouldn t be in this loop!')
%         end
        im2(:,:, information.SliceNumber(inx_p), information.DynamicScanNumber(inx_p), information.CardiacPhaseNumber(inx_p)     ) = im_dumy(:,:);
          count_tag = count_tag + 1;      
    end
    
end

    fclose(fid);
end







