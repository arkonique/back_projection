function [ out ] = beam_avg( in,st,en )
%BEAM_AVG Calculates average of the input vector between starting and ending points
%% Inputs
% *in* - input data (beam)
%
% *st* - starting index
%
% *en* - trailing index
%
%% Output
% *out* - Averaged vector
%% Code

out=[];
out=mean(in(:,st:en)')';



end