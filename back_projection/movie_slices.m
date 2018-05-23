function [] = movie_slices(beam, e_lat, e_long,bp_l,bp_u)
%MOVIE_SLICES Stores the energy in the grid frame by frame
%% Input arguments
% *beam* - A matrix containing the energy at each grid point at each 
% instance of time 
%
% *e_lat* - A vector containing the latitudes of all the grid points
%
% *e_long* - A vector containing the longitudes of all the grid points
%
%% Output files
% 
% time_slice_abs_{frame}.txt - The energy data for all the grid points in
% that frame
%
% ccumulative_energy_{frequency band}.txt - The total energy at each grid
% point for each point in time inside the time window we are looking at
%

frame = 1; % the frame number
[n_grid n_secs] = size(beam); % n_grid - number of grid points || n_secs - number of time instances (total time in seconds)

beam = beam./max(max(beam')); % calculating the energy relative to the max energy for each grid point

for t = 1:1:n_secs
    
    b = beam(:,frame); %storing the energy at all grid points for the current frame in a vector
    
    % writing data to a file for the current frame
    fname = ['movie_frames/time_slice_abs_' num2str(frame) '.txt'];
    f = fopen(fname,'w');
    for i = 1:length(e_long)
        fprintf(f,'\n %f %f %f', e_long(i),e_lat(i),b(i));
    end
    fclose(f);
    frame = frame + 1;
end

cumulativ_e = (sum(beam'))'; % cumumativ_e stores the total energy at each grid point in the time window we are looking at
cumulativ_e = cumulativ_e./max(cumulativ_e); % makes the maximum value of cumulativ_e = 1

% writing the cumulative energy data to a file
f_R_G=fullfile('output',['cumulative_energy_movie_',num2str(bp_l),'_',num2str(bp_u),'Hz.txt']);
        fin=fopen(f_R_G,'w');
        for i=1:length(e_lat)
            fprintf(fin,' \n %f %f %f ',e_long(i),e_lat(i),cumulativ_e(i));
        end
fclose(fin);
    
end

