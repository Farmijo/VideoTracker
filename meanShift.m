% Description:  meanShift.m
%               This will perform the meanShift algorithm to determine the 
%               location of target in the current frame.
%
% References:
%     D. Comaniciu, V. Ramesh, P. Meer: Real-Time Tracking of Non-Rigid 
%     Objects using Mean Shift, IEEE Conf. Computer Vision and Pattern 
%     Recognition (CVPR'00), Hilton Head Island, South  Carolina, Vol. 2, 
%     142-149, 2000 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%          y0 {1x2}[row col] initial guess of target location in frame F_I
%          hCurr {1x2}[rowScale colScale] the scale of the object
%          q  {1xm} the model histogram
%          F_I The frame image (gray scale uint8) in which to search for
%              the model
%          m The number of bins in the histogram
%
% OUTPUTS:
%          y1 {1x2}[row col] the acutal location of the model as determined
%             by the mean shift algorithm.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y1] = meanShift(y0, hCurr, q, F_I, m)

ImgSize = size(F_I);

% ****************************
% * do MeanShift Algorithm   *
% ****************************

continueWithMeanShift = true;
numItt = 0;
while (continueWithMeanShift == true & numItt < 20)

    % ****************************
    % * get p_y0                 *
    % ****************************

    % get pixel locations inside ellipse
    [y0_RowCol, y0_loc] = getPointsInEllipse(y0, hCurr, ImgSize);
    % get histogram p_y0 of model
    [p_y0, binNums] = probProfile(hCurr, y0, y0_RowCol, F_I(y0_loc), m);
        

    % ****************************
    % * get weights              *
    % ****************************
    
    for i = 1:length(binNums)
        w(i) = sqrt(q(binNums(i)+1)/p_y0(binNums(i)+1));
    end
    weightsum = sum(w); %calculate the sum of weights to normalize
    xweight = sum((y0_RowCol(:,1).*w')/weightsum); %calculate normalized weights on x column
    yweight = sum((y0_RowCol(:,2).*w')/weightsum); %calculate normalized weights on y column
    

    % ****************************
    % * get y1                   *
    % ****************************
    
    y1 = round([xweight, yweight]);
    
    % ****************************
    % * check stoping condition  *
    % ****************************
    
    p = getModel(F_I, y1, hCurr, m); %calculate p histogram to check stopping condition
    
    Bat0 = sum(sqrt(p_y0.*q)); %calculate Battacharyya coefficient for the two p
    Bat1 = sum(sqrt(p.*q));

    if Bat1 < Bat0
        y1 = y0;
        continueWithMeanShift = false;
    else if (abs(y1(1,1)-y0(1,1))>2) || (abs(y1(1,2)-y0(1,2))>2)
            y0 = y1;
            continueWithMeanShift = true; 
        else
            continueWithMeanShift = false;
        end
    end
    numItt = numItt + 1;
end
y1 = round(y1);
