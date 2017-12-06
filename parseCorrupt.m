function [err]=parseCorrupt(PathName)
clc;

if nargin<1
    PathName = ['E:\'];
end
X = 1;
err = {}; 

d = dir(PathName);
d = d(3:end);

for i=1:length(d)
    Name = fullfile(PathName,d(i).name);
    disp([num2str(i) ' of ' num2str(length(d)-3)]);
    
    try
        A = imread(Name);
    catch
        err{X} = [num2str(i) ' of ' num2str(length(d)-3)...
            ' - File ' Name ' is corrupt!!!!!'];
        disp(err{X});
        X = X + 1;
    end
end

save('errors.mat','err');

%% Move Errors to another folder
clc;

folder = 'Corrupt Images';
str = fullfile(PathName,folder);
if ~isdir(str)
    mkdir(str)
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

end




