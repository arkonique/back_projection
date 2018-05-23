function [ indx,sign ] = amp_sign( tvl_t,v,t )
% AMP_SIGN Gives the amplitude value and its polarity for the P wave arrival from the variable data
%% Input arguements
% *tvl_t* - Travel time (scalar)
%
% *v* - Velocity data for a station (vector)
%
% *t* - Time data for a station (vector)
%
%
%% Outputs
% *index* - Index of the time corresponding to P wave arrival time
%
% *sign* - Polarity of the P wave arrival
%
%% Code
amp = [];
sign = [];
index_ = find(t(:,1) >= tvl_t);%get index of time corresponding to P wave arrival

if(index_ > 0)
    indx = index_(1,1);
    amp = v(indx,1);
    
    if (amp < 0)
        sign = -1;
    else
        sign = 1;
    end
else
    amp = 0;
    sign = 0;
    indx = 1;
end
% why are we calculating amp anyway????

end

