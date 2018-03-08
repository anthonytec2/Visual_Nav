function [loc]=findGPS(horizon,horizonTruth,trainedTable,mps)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uses horizon and database to generate calculated GPS locations. Functions
% of of meters per second (mps) input to determine best fit.
% Inputs:
%   horizon       - Matrix of horizon vectors per frame
%   horizonTruth  - Matrix of horizon vectors per frame Truth
%   trainedTable  - Matrix containing image time, gps time, and gps data
%   mps           - Meters per second
% Outputs:
%   loc  - Metric of calculated GPS locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% use 26 mps for short data and 45 for long data
if nargin<4
   mps = 26; % meters per second
end

for i=1:size(horizon,1)
    disp(['Matching horizon ' num2str(i) ' to '...
       num2str(size(horizon,1))]); 
    
    mmse=sum(abs(horizon(i,:)-horizonTruth)'); % calculate sum error
    minMMSE = find(mmse==min(mmse)); % find mimum 
    loc(i,:) =  trainedTable(minMMSE(end),3:4); % find GPS at MSE
    location(i) = minMMSE(1);
    
    if i>1  % Calculate distnace in degrees on sphere
        arclen(i) = distance(loc(i,1),loc(i,2),...
            loc(i-1,1),loc(i-1,2));
        meters = mps;
    elseif i==1 
        arclen(i) = distance(loc(i,1),loc(i,2),...
            trainedTable(1,3),trainedTable(1,4));
        meters = 1;
    end
    dist(i) = deg2km(arclen(i),'earth')*1000; % convert degrees to km
    
    while dist(i)>meters
        mmse(minMMSE) = max(mmse); % calculate sum error
        minMMSE = find(mmse==min(mmse)); % find minimum
        loc(i,:) =  trainedTable(minMMSE(end),3:4); % find GPS at MSE
        location(i) = minMMSE(1);
        if i==1  % Calculate distnace in degrees on sphere
            arclen(i) = distance(loc(i,1),loc(i,2),...
                trainedTable(1,3),trainedTable(1,4));
        else
            arclen(i) = distance(loc(i,1),loc(i,2),...
                loc(i-1,1),loc(i-1,2));
        end
        dist(i) = deg2km(arclen(i),'earth')*1000; % convert degrees to km
    end
    
end

figure;
scatter(1:size(horizon,1),1:size(horizon,1),'b'); hold on;
scatter(1:size(horizon,1),location,'r');
legend('current frame','calculated frame');

%figure; plot(dist); title('dist');

end
