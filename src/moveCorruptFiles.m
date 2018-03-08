%% Move Errors to another folder
clc;

folder = 'Corrupt Images';
str = fullfile(PathName,folder);
if ~isdir(str)
    mkdir(str)
end
if ~exist('err','var')
   load('error.mat'); 
end

disp([num2str(length(err)) ' Corrupt Files Found']);
for i=1:length(err)
    Name = strsplit(err{i},{' ', '\', '/'});
    dest = fullfile(PathName,folder,Name{end-2});
    Name = fullfile(PathName,Name{end-2});
    [status,message,messageId] = movefile(Name,dest,'f');
    if status
        disp([Name ' moved to ' dest]);
    else
        disp([message ' ID= ' messageId ' File: ' Name]);
    end
end