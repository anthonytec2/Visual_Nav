function [Name,timestamp]=img2mat_IR(scale,PathName)
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
E = [1970 01 01 00 00 00];

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
        strA = [PathName '\' d(i+(j-1)).name];
        disp(['File ' num2str(i+(j-1)) ' of ' num2str(length(d))...
            ' file: ' strA]);
        strB = strsplit(d(i+(j-1)).name,'_');
        str{j} = strB{2}(1:end-9);
        tmp = imread(strA);
        A(:,:,:,j) = imresize(tmp, scale, 'lanczos3');
        %imagesc(A);
        %pause(0.01);

        strB = strsplit(strB{2}(1:end-4),'-');
        mS = str2num(strB{end}) * 1/5; % milliseconds
        D = [str2num(strB{1}) str2num(strB{2}) str2num(strB{3})...
            str2num(strB{4}(1:2)) str2num(strB{4}(3:4))...
            str2num(strB{4}(5:6))];
        timestamp(j) = ((datenum(D)-datenum(E))*86400) + (4*3600) + mS;
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
