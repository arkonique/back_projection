function [r,shift,sign] = crosscorr_align(x,y,starts,ends,sampling)
%% CROSSCORR_ALIGN
% Cross correlation alignment function
%
%% Description
%
%   Finds the cross correlation coefficient and the lags. Then finds the time delay and the maxima of the cross correlation function and returns the time shift, it's sign and the peak value of the XCF 
% 
%% Syntax
%
%   [r, shift, sign] = crosscorr_align(x,y,starts,ends)
%
%% Input Arguements
% 
% *x* - Matrix of the first uninvariate time series from which the 500-1000th rows from the first column are selected and the sample XCF is computed
%
% *y* - Matrix of the second uninvariate time series from which the 500-1000th rows from the first column are selected and the sample XCF is computed
%
% *starts* - Starting index of the window in which cross correlation is to
% be done
%
% *ends* - Trailing index of the window in which cross correlation is to
% be done
%% Output Arguments
% 
% *r* - Peak value of the XCF indicating the point where the XCF is best aligned
%
% *shift* - Time delay between the two signals determined by the arguement of maxima of the cross correlation 
%
% *sign* - Sign of the polarity, indicating whether the time series is to be shifted forward or backward in time
%
%% Code
%

sign = 0;
[R,dt] = crosscorr(x(starts:ends,1),y(starts:ends,1)); %R - XCF, dt - Time lag
[r,index] = max(abs(R)); %r stores the peak value of the XCF and index stores the index for the peak value
shift = dt(index) / sampling;

t = 0;
t = R(index);

if (t < 0)
    sign = -1;
    
else
    sign = 1;
end

end