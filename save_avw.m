function save_avw(fname, AVW, THIRD, DIMS)

% SAVE_AVW(fname, AVW)
% SAVE_AVW(fname, AVW, HDR)
% SAVE_AVW(fname, AVW, DATATYPE)
% SAVE_AVW(fname, AVW, DATATYPE, DIMS)
%
% DESCRIPTION:
% Saves an analyse img and hdr file.
%
% PARAMETERS:
%	fname [string]: If you want foo.img and foo.hdr, this must be 'foo'.
%	AVW [height, width, depth, ...]: the matrix of intenisities.
%	HDR [1] (struct): a predefined header structure, the fields are described in avw_fields.txt
%	DATATYPE [1] (number or char) : the data type, the following values are supported:
%		unsigned char (8 bits per voxel): 2 or 'c'
%		signed short (16 bits per voxel): 4 or 's'
%		signed int (32 bits per voxel): 8 or 'i'
%		float (32 bits per voxel): 16 or 'f'
%		double (64 bits per voxel) (default if not given): 64 or 'd'
% 	DIMS [3 or 4 depending on the dimensions of the AVW]: the physical dimensions of the voxels, in mm.

if ~ischar(fname)
	error('The filename was not given correctly');
end

if ~isnumeric(AVW)
	error('The AVW is not a numeric matrix');
end

switch nargin
	case 2
		% SAVE_AVW(fname, AVW)
		HDR = save_avw_hdr2(fname, AVW)
		save_avw_img(fname, AVW, HDR.datatype);
	case 3
		% check to see if we are doing
		% SAVE_AVW(fname, AVW, HDR)
		if isstruct(THIRD)
			HDR = THIRD;
			save_avw_hdr(fname, HDR);
			save_avw_img(fname, AVW, HDR.datatype);
		else
		% SAVE_AVW(fname, AVW, DATATYPE)
			DATATYPE = THIRD;
			
			if ischar(DATATYPE)
				if DATATYPE == 'c'
					realDataType = 2;
				elseif DATATYPE == 's'
					realDataType = 4;
				elseif DATATYPE == 'i'
					realDataType = 8;
				elseif DATATYPE == 'f'
					realDataType = 16;
				elseif DATATYPE == 'd'
					realDataType = 64;
				else
					error(['The DATATYPE ' DATATYPE ' is not supported']);
				end
			else
				if DATATYPE == 2 || DATATYPE == 4 || DATATYPE == 8 || DATATYPE == 16 || DATATYPE == 64
					realDataType = DATATYPE;
				else
					error(['The DATATYPE ' num2str(DATATYPE) ' is not supported']);
				end
			end

			HDR = save_avw_hdr2(fname, AVW, realDataType)
			save_avw_img(fname, AVW, realDataType);
		end
	case 4
		DATATYPE = THIRD;
		if ischar(DATATYPE)
			if DATATYPE == 'c'
				realDataType = 2;
			elseif DATATYPE == 's'
				realDataType = 4;
			elseif DATATYPE == 'i'
				realDataType = 8;
			elseif DATATYPE == 'f'
				realDataType = 16;
			elseif DATATYPE == 'd'
				realDataType = 64;
			else
				error(['The DATATYPE ' DATATYPE ' is not supported']);
			end
		else
			if DATATYPE == 2 || DATATYPE == 4 || DATATYPE == 8 || DATATYPE == 16 || DATATYPE == 64
				realDataType = DATATYPE;
			else
				error(['The DATATYPE ' num2str(DATATYPE) ' is not supported']);
			end
		end
		HDR = save_avw_hdr2(fname, AVW, realDataType, DIMS);
		save_avw_img(fname, AVW, realDataType);
end

