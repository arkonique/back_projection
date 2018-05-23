function [ M ] = peak_time_wise( beam, e_lat, e_long, t_finish, ev_lat, ev_long )
%PEAK_TIME_WISE Plots the location of the peak amplitude at each time
%instance
%%   Input arguments
% *beam* - stacked energy for each grid point in the time window
%
% *e_long* - Vector containing the longitudes of the grid points
%
% *e_lat* - Vector containing the latitudes of the grid points
%
% *t_finish* - time until which the peak amplitude is to be plotted
%
%% Outputs
% *M* - Stores the frames of the plot in a struct

%%  Finding peaks and saving data

    [n_grid n_secs] = size(beam); % n_grid - number of points in the grid || n_secs - number of time points
    % temp will store the data for the time instance, grid lat-long at which
    % peak is maximum at that time instance and the energy at that grid
    % point at that instance of time
    temp = []; 
    
    for i = 1:n_secs
        [d in] = max(beam(:,i));
        temp = [temp;i, e_long(in), e_lat(in), d];
    end
    
    temp(:,4) = temp(:,4)/max(temp(:,4));

    save('output/peak_energy.txt','temp','-ascii');
    
    llong=min(e_long);
    rlong=max(e_long);
    llat=min(e_lat);
    ulat=max(e_lat);
%% Plotting

    frame = 1;
    
    for t = 1:1:t_finish
        cla;
        plot(temp(frame,2),temp(frame,3),'o','MarkerSize',10,'MarkerFaceColor',[0.0118 0.6627 0.9569]);
        view(0,90);
        hold on;
        plot3(ev_long,ev_lat,20,'s','MarkerSize',20,'MarkerFacecolor',[0.9529 0.2588 0.2078]);
        hold off;
        axis([llong rlong llat ulat])
        shading interp
        view(0,90);
        box on
        title(['Energy(0.2 - 5 Hz) at seconds = ' num2str(frame)],'FontWeight','bold','FontSize',15,'FontName','Times');
        xlabel('Long/degree','FontWeight','bold','FontSize',13,'FontName','Times');
        ylabel('Lat/degree','FontWeight','bold','FontSize',13,'FontName','Times');
        drawnow
        M(frame)  = getframe(gcf); % gcf denotes the current figure
        frame=frame+1;
end

