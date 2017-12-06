function [Name,timestamp]=img2mat(scale,PathName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function looks in a directory. For every step of images one output file
% is generated. The timestamps of the images are in the output as well.
% Inputs:
%   scale - Input from 0 to 1. Reduces the raw image based on scale.
%       1 is no reduction.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<2
    PathName = [];
end
if nargin<1
    scale = 0.25;
end

if isempty(PathName)
    [PathName] = uigetdir('.\Drive Video',...
        'Get drive image folder'); %GUI to open desired bag file
    if PathName == 0
        disp('No File Selected... Exiting!');
        return;
    end
end
d = dir(PathName);
d = d(4:end);
step = length(d);

for i=1:step:length(d)
    for j=1:length(d)
        strA = fullfile(PathName, d(i+(j-1)).name);
        disp(['File ' num2str(i+(j-1)) ' of ' num2str(length(d))...
            ' file: ' strA]);
        strB = strsplit(d(i+(j-1)).name,'-');
        str{j} = strB{2};
        tmp = imread(strA);
        A(:,:,:,j) = imresize(tmp, scale, 'lanczos3');
        %imagesc(A);
        %pause(0.01);
        
        timestamp(j) = str2num(str{j})/1000;
        
    end
    folder = 'img2vid';
    Name = fullfile(folder, ['Color_Video_' num2str(i) '.mat']);
    
    if ~nargout
        if ~isdir(folder)
            mkdir(folder);
        end
        save(Name,'A','timestamp','-v7.3');
    end
    clear A;
end

end
