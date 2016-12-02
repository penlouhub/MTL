function run_data(convert, list,varargin)
%19/02/16 Penny Cristinacce original
%01/12/16 updated to accept folder and info together
% varargin options
% range of data to process



list=importdata('D:\WT\ANALYSIS\STUDY\foldersandinfo.txt');

if nargin==4
    x = varargin{1};
    y = varargin{2};
% elseif nargin==5
%     slice = varargin{1};
%     slice=importdata(char(slice));
%     x = varargin{2};
%     y = varargin{3};
% elseif nargin==6
%     T1name = varargin{1};
%     T1name=importdata(char(T1name));
%     slices = varargin{2};
%     slices=importdata(char(slices));
%     x = varargin{3};
%     y = varargin{4};
end

if strcmp(convert,'T1')
    for i=x:y
        i
    convertT1_batch(list.textdata{i,1},list.textdata{i,5},list.textdata{i,4});
    end

elseif strcmp(convert,'T1reg')
    for i=x:y
        i
    convertT1reg_batch(list.textdata{i,1},list.data(i,2));
    end
    
else strcmp(convert,'EPI')
    for i=x:y
        i
    convertEPI_batch(list.textdata{i,1},list.data(i,1));
    end
end

end


