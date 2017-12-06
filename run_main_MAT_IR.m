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
Name = ['.\img2vid\IR_ShortRun_1.mat'];

%[horizonTruth,timestamp_T]=horizonDetect_IR(Name,dataSet,range,scale,vid);
horizonDetect_IR(Name,dataSet,range,scale,vid);

%% GPS matching for truth Data

% loads gpsCar, gpsPuck, timeCar, timePuck
%load('.\4-9-Results\gpsMatFiles\gpsLongRunDay1.mat');
load('.\4-9-Results\gpsMatFiles\gpsShortRunNight1.mat');

gpsCar_T = gpsCar; gpsPuck_T = gpsPuck;
timeCar_T = timeCar; timePuck_T = timePuck;

[trainedTable]=match2gps(gpsPuck_T,timePuck_T,timestamp_T);

%% Find new data horizon's
% keyboard;

dataSet = 1;
scale = 0.25;
range = [1 2048*scale];
vid = 1;

%Name = ['.\img2vid\long_run_test_2.mat'];
Name = ['.\img2vid\IR_ShortRun_2.mat'];

[horizon,timestamp]=horizonDetect_IR(Name,dataSet,range,scale,vid);
%horizonDetect_IR(Name,dataSet,range,scale,vid);

%% check GPS matching for new data

% loads gpsCar, gpsPuck, timeCar, timePuck
%load('.\4-9-Results\gpsMatFiles\gpsLongRunDay1.mat');
load('.\4-9-Results\gpsMatFiles\gpsShortRunNight2.mat');

[truthTable]=match2gps(gpsPuck,timePuck,timestamp);

%% Match Horizons

[calcGPS]=findGPS(horizon,horizonTruth,trainedTable);

%% Reconstruct path against trained data
%keyboard;

[h]=reconstructPath(calcGPS,truthTable,trainedTable);
