function [ index ] = ref_trace(stnlong,stnlat)
%REF_TRACE Finds the station closest to the center of the array out of the
%selected stations
%% Input arguments
% *stnlong* - Vector containing the longitudes of the selected stations
%
% *stnlat* - Vector containing the latitudes of the selected stations
%% Output arguments
% *index* - Index of the centremost station in the stnlat or stnlong file
% (vector) which is to be used as the reference trace for cross correlation
% 
%% Logic
% Suppose easternmost station out of the selected stations in the
% array is on the top left edge of a rectangle and the westernmost
% station out of the selected stations in the array is on the right
% edge of the rectangle, the northernmost is on the top edge and the 
% southernmost is on the bottom edge. The station closest to the center of 
% the rectangle will be the center most station in the array

%% Code

% Define the rectangle
left = min(stnlong);
right = max(stnlong);
top = max(stnlat);
bottom = min(stnlat);

% Find the center of the rectangle
center = [(right-left)/2,(top-bottom)/2];

% Function for calculating distance
distance  = @(p1,p2)((p1(1)-p2(1))^2 + (p1(2)-p2(2))^2)^(0.5);

% calculating the distance of the center froom all the stations
d = [];
for i = 1:length(stnlat)
    dist = distance(center,[stnlong(i),stnlat(i)]);
    d = [d;dist];
end

% Find the index of the distance which is minimum
[dist index] = min(d);
end

