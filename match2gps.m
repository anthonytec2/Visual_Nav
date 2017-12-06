function [out]=match2gps(gpsPuck,timePuck,imageTime)

for i=1:length(imageTime)
    delta = abs(imageTime(i) - timePuck);
    loc = find(delta == min(delta));
    out(i,:) = [imageTime(i), timePuck(loc(1)), gpsPuck(loc(1),:)];
end

end

