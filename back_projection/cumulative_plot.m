function [] = cumulative_plot( beam, e_lat,e_long, t_start, t_end,ev_lat,ev_long, bp_l, bp_u)
%CUMULATIVE_PLOT Plots the cumulative energy of the earthquake
%% Input Arguments
% *beam* - Energy for each time increment for each grid point
%
% *e_lat* - Vector containing Latitudes of the grid points
%
% *e_long* - Vector containing Longitudes of the grid points
%
% *t_start* - starting time
%
% *t_end* - ending time
%
% *t_start* and *t_end* define the time window within which the energy is
% to be considered

%% Code

b = [];
b = sum(beam(:,((t_start-1))+1:((t_end-1))+1)')'; % Adding all the energy within the time window
b = b./max(b); % Normalising

%%
% Saving the data to file

fn = fullfile('output','cumulative_energy.txt');
f = fopen(fn,'w');

for i=1:length(e_lat)
    fprintf(f,'%f %f %f \n',e_long(i),e_lat(i),b(i));
end

fclose(f);

%%
% Plotting the data

energy_surf = fit([e_long,e_lat],b, 'loess');
plot(energy_surf);
hold on;
plot3(ev_long ,ev_lat ,1,'s','MarkerSize',20,'MarkerEdgeColor','k','MarkerFaceColor','k')
hold on;
%plot3(94.709,23.03,20,'s','MarkerSize',20,'MarkerEdgeColor','b','MarkerFaceColor','b')   ?????
shading interp
alpha(1)
view(0,90)
box off
colorbar
title(['Cumulative Energy(' num2str(bp_l) ' - ' num2str(bp_u) ' Hz) at seconds = ' num2str(t_start )],'FontWeight','bold','FontSize',15,'FontName','Times');
xlabel('Long/degree','FontWeight','bold','FontSize',13,'FontName','Times');
ylabel('Lat/degree','FontWeight','bold','FontSize',13,'FontName','Times');

end