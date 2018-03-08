%% Setup
close all;
clear;
clc;

%% Find Truth Horizon's
dataSet = 1;
scale = 0.25;
range = [1 2048*scale];
vid = 0;

%Name = ['.\img2vid\long_run_test_1.mat'];
Name = ['.\img2vid\short_run_test_1.mat'];

[horizonTruth,timestamp_T]=horizonDetect(Name,dataSet,range,scale,vid);
%horizonDetect(Name,dataSet,range,scale,vid);

%save('output1.mat','horizonTruth','timestamp_T');

%% GPS matching for truth Data

% loads gpsCar, gpsPuck, timeCar, timePuck
%load('.\4-9-Results\gpsMatFiles\gpsLongRunDay1.mat');
load('.\4-9-Results\gpsMatFiles\gpsShortRunDay1.mat');

gpsCar_T = gpsCar; gpsPuck_T = gpsPuck;
timeCar_T = timeCar; timePuck_T = timePuck;

[trainedTable]=match2gps(gpsPuck,timePuck,timestamp_T);

%% Find new data horizon's
% keyboard;

dataSet = 1;
scale = 0.25;
range = [1 2048*scale];
vid = 0;

%Name = ['.\img2vid\long_run_test_2.mat'];
Name = ['.\img2vid\short_run_test_2.mat'];

[horizon,timestamp]=horizonDetect(Name,dataSet,range,scale,vid);
%horizonDetect(Name,dataSet,range,scale,vid);

%save('output2.mat','horizon','timestamp');

%% check GPS matching for new data

% loads gpsCar, gpsPuck, timeCar, timePuck
%load('.\4-9-Results\gpsMatFiles\gpsLongRunDay1.mat');
load('.\4-9-Results\gpsMatFiles\gpsShortRunDay2.mat');

[truthTable]=match2gps(gpsPuck,timePuck,timestamp);

%% Match Horizons

[calcGPS]=findGPS(horizon,horizonTruth,trainedTable);

%% Reconstruct path against trained data
%keyboard;

[h]=reconstructPath(calcGPS,truthTable,trainedTable);
