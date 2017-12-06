function []=genWaterfall(Name)
close all;

az=16; el=66;

if ~nargin
    [FileName,PathName] = uigetfile('*.mat',...
        'Select Horizon File','.\Horizon Output');
    if isempty(FileName)
        disp('No file selected.... Exiting!!!');
        return;
    end
    Name = fullfile(PathName,FileName);
else
    PathName = '.\Horizon Output';
end

subfolder = 'WaterFall';
folder = fullfile(PathName,subfolder);
if ~isdir(folder)
    mkdir(folder);
end

disp(['Loading: ' Name]);
load(Name);

%for ii=1:size(A,4)

[t1]=epoch2tstr(timestamp(1));
[t2]=epoch2tstr(timestamp(end));

h = figure(1); %ax = axes;
waterfall(horizon);
title(['Inverse Horizon from ' t1 ' to ' t2]);
xlabel('Field of View (in Pixels)'); xlim([0 size(horizon,2)]);
ylabel('Frame #'); ylim([0 size(horizon,1)]);
zlabel('Height (in Pixels)');
view(az,el);

Name = ['Inverse_Horizon3'];
Name = fullfile(PathName,subfolder,Name);
saveas(h,[Name '.fig']);
saveas(h,[Name '.png']);
pause(0.1);
%end

end
