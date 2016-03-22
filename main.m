
clearvars;
clc

% Video parameters
video_name = 'tennis_qcif.yuv';

startFrame = 40;
nFrames = 50; %;250;
starFrame2= 60;

% Mean-Shift Parameters
% Width and height of the ellispe (target model shape)
h = [25 7];
h2 = [6 2];
% Target position (center of the ellipse)
y = [65 71];
y2= [43 161];
% Number of bins in the spatially-weighted histograms
m = 15;


displayImages = true;


%************************************************************************
% Read a video in YUV format
[video,imgRGB] = readYUV(video_name, nFrames, 'QCIF_PAL');
%we start at frame startFrame
video=video(startFrame:end);
imgRGB=imgRGB(:,:,:,startFrame:end);


% display the image used to derive the model. Note the image is displayed
% using the specified number of bins.
%I = video(1).cdata;
%R=I(:,:,1);
%G=I(:,:,2);
%B=I(:,:,3);

%I_bined = uint8(reshape(binNum(reshape(I,1,[]),m),size(I,1),[]));
%figure; 
%imshow(I_bined,[]); 
%hold on;

I = video(1).cdata;
[RowCol, loc] = getPointsInEllipseBorder(y, h, size(I));

%[RowCol2, loc2] = getPointsInEllipseBorder(y2, h2, size(I));

imshow(I);
hold on;
plot(RowCol(:,2),RowCol(:,1),'-','LineWidth',2); 
plot(y(2),y(1),'.','MarkerSize',5);


%plot(RowCol2(:,2),RowCol2(:,1),'-','LineWidth',2); 
%plot(y2(2),y2(1),'.','MarkerSize',5);

hold off;
%title('Binned image used to obtain model q.');



% Start tracking!! *******************************************************
% Update frame number
currFrameNum = 1;

% Load next frame
I = video(currFrameNum).cdata;

% Get model (spatially-weighted) pdf
[q] = getModel(I, y, h, m);


ModelLocs(1,:) = y;
index = 2;
y1 = y;
currFrameNum = currFrameNum + 1;
i=1;
while (currFrameNum < nFrames-startFrame)
    
       
    
    % load next frame by calling getImage function handle    
    F_I = video(currFrameNum).cdata;
    currFrameNum = currFrameNum + 1;
    
    % get size of frame F_I
    ImgSize = size(F_I);
    
    if currFrameNum==60 
        
        [RowCol2, loc2] = getPointsInEllipseBorder(y2, h2, size(I));
        imshow(F_I);
        hold on;
        plot(RowCol2(:,2),RowCol2(:,1),'-','LineWidth',2); 
        plot(y2(2),y2(1),'.','MarkerSize',5);
        hold off;
        

    
        [q2] = getModel(I, y2, h2, m);
        
        ModelLocs2(1,:) = y2;
    end
    
    % find the location of model in current frame using mean shift
    [y1] = meanShift(y1, h, q, F_I, m);
    track(i,:)=y1;
    %[q] = getModel(F_I, y1, h, m);
    
   if currFrameNum >= 60
       [y2] = meanShift(y2, h2, q2, F_I, m);
    track2(i,:)=y2
   end
   
   
    % save location
    ModelLocs(index,:) = y1;
    if currFrameNum >=60
        ModelLocs(index,:) =y2;
    end
    index = index + 1;
    
    
    
    [RowCol, loc] = getPointsInEllipseBorder(y1, h, size(F_I));
    
    if currFrameNum >= 60    
    [RowCol2, loc2] = getPointsInEllipseBorder(y2, h2, size(F_I));
    end
    
    imshow(F_I); 
    hold on; 
    plot(RowCol(:,2),RowCol(:,1),'-','LineWidth',2); 
    plot(y1(2),y1(1),'rx','MarkerSize',30,'LineWidth',2);
    plot(track(:,2),track(:,1),'r-','LineWidth',2); 
    
    if currFrameNum >= 60
        plot(RowCol2(:,2),RowCol2(:,1),'-','LineWidth',2); 
        plot(y2(2),y2(1),'rx','MarkerSize',30,'LineWidth',2);
        plot(track2(59:1:length(track2),2),track2(59:1:length(track2),1),'r-','LineWidth',2); 
    end
    
    
    hold off;
    
    
    pause(0.01);
    i=i+1;
end

