function [h] = reconstructPath(calcGPS,truthTable,trainedTable)

latC(:) = calcGPS(:,1); longC(:) = calcGPS(:,2);
latT(:) = truthTable(:,3); longT(:) = truthTable(:,4);
latTrain(:) = trainedTable(:,3); longTrain(:) = trainedTable(:,4);

[utmxC,utmyC,utmzone] = deg2utm(latC,longC);
[utmxT,utmyT,utmzone] = deg2utm(latT,longT);
[utmxTrain,utmyTrain,utmzone] = deg2utm(latTrain,longTrain);

scatter(utmxTrain,utmyTrain,'+','m'); hold on;
scatter(utmxC,utmyC,'d','filled'); hold off;
legend('Training Data in Run 1','Calculated for Run 2');

% title(['GPS in UTM from ' num2str(truthTable(1,1))...
%     ' to ' num2str(truthTable(end,1))]);

h = figure; plot(utmxTrain,'*'); hold on; title('umtX'); 
plot(utmxC,'*');  hold off;
xlabel('Frame Number');
ylabel('utm_x (meters)');
title('Utm_x Plot for Long Runs')
legend('Training Data in Run 1','Calculated for Run 2');

figure; plot(utmyTrain,'*');  hold on; title('utmY');
plot(utmyC,'*'); hold off;
legend('Training Data in Run 1','Calculated for Run 2');
xlabel('Frame Number');
ylabel('utm_y (meters)');
title('Utm_y Plot for Long Runs')
end