%% Script to check and delete stations which are out of range


%% Data loading part

f = fullfile('data',['stnlat_' array]);
stnlat = load(f);

f = fullfile('data',['stnlong_' array]);
stnlong = load(f);

f = fullfile('data',['P_time_' array]);
P_time = load(f);

f = fullfile('data',['V_' array '.txt']);
V = load(f);

f = fullfile('data',['T_' array '.txt']);
T = load(f);

%f = fullfile('data',['data_info_' array '.txt']);
%data_info = load(f);

f = fullfile('data','gridlim.txt');
grid = load(f);



%% Definitions

length = input('Enter number of data points (for each station):'); % Nummber of data points for each station

distance = @(lat1,long1,lat2,long2) acosd(sind(lat1)*sind(lat2)+cosd(lat1)*cosd(lat2)*cosd(long1-long2)); % function to calculate distance

%% Algorithm

%Traverse the grid
for elat = grid(1,1):grid(1,2):grid(1,3)
    for elong = grid(2,1):grid(2,2):grid(2,3)
        
        c=0; % counts the number of stations deleted
        disp(['Grid point: ',num2str(elat),',',num2str(elong)]);
        disp('   Stnlat   Stnlong');
        i=0;
        endlat = stnlat(end);
        x=stnlat(1);
        while x~=endlat
            i=i+1% Traverse through the station list
            endlat = stnlat(end); % variable to check the end of iterations. Stores the value of the latitude of the last station to be compared later
            x = stnlat(i); % stores the latitude of the current element || for checking end of list
            if(x == endlat)
                break;
            end
            
            d = distance(stnlat(i),stnlong(i),elat,elong); % calculate the distance for the current station
            if(d>90 || d<30) % check if station distance is out of the range [30,90]
                % displays the lat-long of the station being deleted
                disp([stnlat(i),stnlong(i)]);
                % delete the data for the selected station from each file
                
                % Takes the velocity or time data corresponding to
                V((i-1)*length+1:i*length) = []; 
                T((i-1)*length+1:i*length) = [];
                
                stnlat(i) = [];
                stnlong(i) = [];
                P_time(i) = [];
                %data_info(i,:) = [];
                i = i-1;
                c = c+1; 
            end
            % This checks if the current station is/was the last station in
            % the list. If yes, stops the iterations (Necessary if some station has been deleted from the list)
            
        end
        if c==0
            disp('No station deleted');
        end
    end
end

%% Data saving part
save(['data/V_' array '.txt'],'V','-ascii');
save(['data/T_' array '.txt'],'T','-ascii');
save(['data/stnlat_' array],'stnlat','-ascii');
save(['data/stnlong_' array],'stnlong','-ascii');
save(['data/P_time_' array],'P_time','-ascii');
%save(['data/data_info_' array '.txt'],'data_info','-ascii');