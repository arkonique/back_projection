function [ out ] = cut_window( input_vector,starting,ending )
%CUT_WINDOW Cuts out part of the seismogram
%% Input arguements
% *input_vector* - Vector to be cut
%
% *starting* - Window starting point
%
% *ending* - Window ending point
%% Output
% *out* - Contains part of the input_matrix that lies within the window
%% Code
out = [];
out = input_vector(starting:ending);

% for i = 1:(ending-starting)
%     out(i) = input_vector(starting+i);
% end

end

