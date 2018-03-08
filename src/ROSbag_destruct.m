%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROSbag_destruct - 2/8/17 - Antonio Rufo
% Script extracts contents of ROS bag file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; 
% str = 'C:\Users\Thinkpad-Rufo\Documents\MATLAB\Robotics\matlab_gen\msggen';
% addpath(str);
% savepath;
% rosgenmsg(str);



% set step size of files (1000 is the safest) (10000 is faster but crashes)
chunk_size = 10000; 
%Change for your specific path
PathName = 'C:\Users\Thinkpad-Rufo\Documents\MATLAB\Robotics';
addpath(PathName);

[FileName,PathName] = uigetfile('*','Get rosbag Log File',...
    PathName); %GUI to open desired bag file
if FileName == 0
    disp('No File Selected... Exiting!');
    return;
end
folder = FileName(1:end-4); % Create ouput folder
if ~isdir(folder)
    mkdir(folder);
end

tic;
bag = rosbag([PathName FileName]);
toc

%Find all unique Topic names and row locations
[names,~,row]=unique(bag.MessageList.Topic);

topicList = bag.AvailableTopics;
fname = [folder '\' FileName(1:end-4) '_TopicList'];
save(fname,'topicList'); % save file containing only topic list

tic;
for i=1:length(names)
    
    try
        tab = bag.MessageList(row==i,:); %Extract messages only from specific topic
        str = char(tab.Topic(1)); % Extract topics name as string
        bagSel = select(bag,'Topic',str); % Select topics string from bag
        str = strrep(str, '/', '_');
        disp(['Topic: ' str ' has ' num2str(height(tab)) ' msgs']);
        
        if height(tab)>chunk_size % Handel topics with more messages then chunk size
            for j=1:chunk_size:height(tab)-chunk_size-1 %iterate through chunks
                data = readMessages(bagSel,j:j+chunk_size); %extract section of message
                fname = [folder '\' FileName(1:end-4) '_BAG' str '_'...
                    num2str(j) '_to_' num2str(j+chunk_size)];
                disp(['Saving data for Topic: ' str ' from '...
                    num2str(j) ' to ' num2str(j+chunk_size)]);
                save(fname,'data');
                
            end
            data = readMessages(bagSel,j+chunk_size:height(tab));%extract end of message
            fname = [folder '\' FileName(1:end-4) '_BAG' str '_'...
                num2str(j+chunk_size) '_to_' num2str(height(tab))];
            disp(['Saving data for Topic: ' str ' from '...
                num2str(j+chunk_size) ' to ' num2str(height(tab))]);
            save(fname,'data');
        else
            data = readMessages(bagSel); %Extract all data in topic
            fname = [folder '\' FileName(1:end-4) '_BAG' str];
            disp(['Saving all data for Topic: ' str]);
            save(fname,'data');
        end
    catch %If message is not imported correctly error is caught 
		% Location of error in 'err' is directly related to topic list
        disp(['Topic: ' str ' message structure is not defined.']);
        err{i} = str; 
    end
    
end
save('errors','err');
toc;