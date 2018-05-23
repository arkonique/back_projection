function [ M ] = movie_test(beam,e_lat,e_long,bp_l,bp_u,frame_skip)
% MOVIE_TEST plots the energy for the whole grid at specific points in
% time, after a fixed time interval
%
%% Input arguments
%
% *beam* - Energy for each grid point for all time increments
%
% *e_lat* - Vector containing the latitudes of all the grid points
%
% *e_long* - Vector containing the longitudes of all the grid points
%
%% Outputs
%
% *M* - A struct containing all the frames

frame = 1; % frame number
[n_grid n_secs] = size(beam); % n_grid - number of grid points || n_secs - tootal time in seconds

for t = 1:frame_skip:n_secs % plots the data in increments of given seconds
    cla;
    foo = fit([e_long,e_lat],beam(:,t),'loess');
    cptcmap('GMT_hot','ncol',10); % Produces a contour plot with 10 colors
    
    % Plot the energy
    
    subplot(2,1,1,'align');
    
    plot(foo);
    shading interp;
    alpha(1);
    view(0,90);
    box off;
    colorbar;
    title(['Energy(',num2str(bp_l),'- ',num2str(bp_u),' Hz) at ', num2str(t),'seconds'],'FontWeight','bold','FontSize',15,'FontName','Times');
    xlabel('Long/degree','FontWeight','bold','FontSize',13,'FontName','Times');
    ylabel('Lat/degree','FontWeight','bold','FontSize',13,'FontName','Times');
    
    % Plot the relative amplitude
    
    subplot(2,1,2,'align');
    
    stf = sum(beam);
    stf = stf./max(stf);
    plot(stf);
    xlabel('Time(seconds)','FontWeight','bold','FontSize',13,'FontName','Times');
    ylabel('Relative Amplitude','FontWeight','bold','FontSize',13,'FontName','Times');
    hold on
    
    plot(t,stf(t),'o','MarkerSize',5,'Markerfacecolor',[0.9529 0.2588 0.2078]);
    drawnow;
    M(frame) = getframe(gcf);
    frame = frame + 1;
end

end