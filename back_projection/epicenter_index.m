function [ index,index2 ] = epicenter_index( e_lat_d,e_lat_u,e_long_d,e_long_u,epicentre_lat,epicentre_long,grid_size)
%% Calculate the index of the epicenter in the source grid
% Given any earthquake epicenter and a source grid, this function can
% calculate the index of the grid point closest to the epicenter i.e. the
% grid point best representing the epicenter
%
%% Input arguements
%
% *e_lat_d* - Lower latitude of the source grid
%
% *e_lat_u* - Upper latitude of the source grid
%
% *e_long_d* - Lower (Left) longitude of the source grid
%
% *e_long_u* - Upper (Right) longitude of the source grid
%
% *epicentre_lat* - Latitude of the event (Taken from the SAC header or any other place)
% 
% *epicentre_long* - Longitude of the event (Taken from the SAC header or any other place)
%
% *grid_size* - Spacing between two grid elements
%
%% Output
% *index* - Index of the epicentre in the grid array (primarily used as an index of the beam)


%% Find the index
n_long_total = 1+((e_long_u - e_long_d)/grid_size);
n_lat_epic = floor((epicentre_lat - e_lat_d)/grid_size);
n_long_epic = 1+floor((epicentre_long - e_long_d)/grid_size);

index = round((n_long_total*n_lat_epic) + n_long_epic);

%% %Improved accuracy 
% %Uncomment this part below for better accuracy in determining the index.
% %But this might increase runtime due to loops in this
% 
% % Generating grid
% e_lat=[];
% e_long=[];
% for lat=e_lat_d:grid_size:e_lat_u
%     for long=e_long_d:grid_size:e_long_u
%         e_lat=[e_lat;lat];
%         e_long=[e_long;long];
%     end
% end
% 
% %calculate the difference between gridpoint latlong and epicentre latlong
% %and then see which of the four grid points surrounding the epicenter it
% % i.e. the epicenter is closest to
% 
% a = e_lat(index) - epicentre_lat;
% b = e_long(index) - epicentre_long;
% 
% if(b>grid_size/2)
%     index = index + 1;
% end
% 
% if(a>grid_size/2)
%     index = index + n_long_total;
% end

end