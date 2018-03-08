function [horizon,t_out]=horizonDetect_IR(Name,dataSet,range,scale,vid)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uses BLUE or HSV image with Otsu thresholding with edge detection to
% detect the horizon. STD of BLUE image used to determine BLUE or HSV use.
% Filtered STD of HSV use to determine Hue or Value components.
% Inputs:
%   PathName - Location of folder with drive images - 'string'
%   dataSet  - What set of 150 images required - integer
%   range    - Min and max rows to search in image for edges - [min max]
%   scale    - Scalar value 0 to 1 for imresize scaling factor
%   vid      - Scalar value (0 = no video, 1 = save video)
% Outputs:
%   horizon  - output matrix where rows are horizon vectors
%   str_out  - output string of timestamps from files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<5
    vid = 0;
end
if nargin<4
    scale = 0.25;
end
if nargin<3
    range = [1 2048*scale]; % size(A,1)/2;
end
if nargin<2
    dataSet = 0;
end
if nargin<1
    Name = ['.\img2vid\IR_Run1.mat'];
end

start = (150*dataSet)+1;
step = 149;

if isdir(Name) % Check if Name is file or directory
    d = dir(Name);
    d = d(4:end);
    strB = strsplit(d(1).name,'.');
    step = length(d);
else
    strB = strsplit(Name,'.');
end

if strcmp(strB{end},'jpg') % If directory, load individual images
    for i=start:start+step - 1
        str = d(i+2).name;
        disp(['File ' num2str(i) ' of ' num2str(length(d)-2)...
            ' file: ' str]);
        if scale<1 % check if scale is applied
            A(:,:,:,(i+1)-start) = imresize(imread([Name '\' str]),...
                scale, 'lanczos3'); % resize image from scale
        else
            A(:,:,:,(i+1)-start) = imread([Name '\' str]);
        end
        if nargout>1
            str = strsplit(str,'-');
            t_out{(i+1)-start} = str{2};
        end
    end
elseif strcmp(strB{end},'mat') % if mat file, load
    disp(['Loading File: ' Name]);
    load(Name);
    if nargout>1
        t_out = timestamp;
    end
else
    disp('No valid file or folder selected.... Exiting!!!!!');
    return;
end

if vid % Create video output file
    v=VideoWriter('horizonDetect_output.mp4','MPEG-4');
    v.FrameRate = 15;
    open(v);
end

for j=1:size(A,4)
    disp(['Frame ' num2str(j) ' of ' num2str(size(A,4))]);
    
    str = 'IR';
    img = A(:,:,1,j); % Extract grayscale
    I = imcomplement(img); % inverse of image
    %I = imadjust(img,stretchlim(img),[]);
    I = histeq(I);
    %I = adapthisteq(img);
    %se = offsetstrel('ball',5,5);
    %I = imerode(I,se);
    
    [counts,x] = imhist(I);
    T = otsuthresh(counts); % Otsu Threshold
    I=imbinarize(I,T);
    I=imfill(I,'holes'); % fill holes in positive image
    I = imcomplement(I); % inverse of image
    I=imfill(I,'holes'); % fill holes in negative image
    
    if mean(I(1,:))>=0.5 % pad image based on 1st row
        pad = ones(1,size(A,2)); % if bright row pad with 1's
        padB = zeros(1,size(A,2)); % if dark row pad with 0's
    else
        pad = zeros(1,size(A,2)); % if dark row pad with 0's
        padB = ones(1,size(A,2)); % if bright row pad with 1's
    end
    I = [pad; I; padB]; % add padding
    
    len=edge(I(range(1):range(2)+2,:),'Canny'); % find edges in top half of image
    [row,col] = find(len==1);
    [~,ia,~] = unique(col);
    row = row(ia);
    y=row+(range(1)-1); % Use for dots
    
    if vid || ~nargout
        h = figure(1); %set(gcf,'position',get(0,'screensize'));
        subplot(2,1,1);
        imagesc(I); title([str ' Otsu Threshold Binary Image']);
        subplot(2,1,2);
        imagesc(img); title(['Frame ' num2str(j)]);
        hold on;
        scatter(1:length(y),y,1,'r','LineWidth',1);
        hold off;
        pause(0.0001);
        %keyboard;
    end
    
    if nargout
        horizon(j,1:length(y)) = y;
    end
    
    if vid
        frame = getframe(h);
        writeVideo(v,frame);
    end
end

if vid
    close(v);
end

end
