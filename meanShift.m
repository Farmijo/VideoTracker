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
    [y0_RowCol, y0_loc] = getPointsInEllipse(F_I, y0, hCurr, m);
    % get histogram p_y0 of model
    [p_y0, binNums] = TO DO
        

    % ****************************
    % * get weights              *
    % ****************************
    TO DO 

    % ****************************
    % * get y1                   * 
    % ****************************

    y1 = TO DO
    
    % ****************************
    % * check stoping condition  *
    % ****************************
    TO DO

    numItt = numItt + 1;
end
y1 = round(y1);
