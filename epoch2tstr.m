function [time_string]=epoch2tstr(epoch)

time_reference = datenum('1970', 'yyyy');
time_matlab = (time_reference + epoch / 8.64e7) - hours(4);
time_string = datestr(time_matlab, 'HH:MM:SS.FFF');

end