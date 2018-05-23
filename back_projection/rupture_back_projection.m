%% Stacks all the data for a given array by weight

disp('Rupture back Projection Starting....');
disp('Loading data...');

%% Data loading

f = fullfile('output',['velocity_' array '.txt']);
v = load(f);
f = fullfile('output',['time_' array '.txt']);
t = load(f);
f = fullfile('data',['stnlat_' array]);
stnlat = load(f);
f = fullfile('data',['stnlong_' array]);
stnlong = load(f);
f = fullfile('data',['P_time_' array]);
P_time = load(f);
f = fullfile('output',['Cross_correlation_' array '.txt']);
Cross_correlation = load(f);

f = fullfile('data','grid.txt');
grid = load(f);

e_lat = grid(:,1);

e_long = grid(:,2);

disp('Loading done...');

sampling = input('Enter sampling frequency (samples/s): ');
% Normalising - so that the maximum absolute value of any data point of any station is unity
V=[];

for i=1:length(stnlat)
    if v(:,i)==0
        
    else
        V(:,i) = v(:,i)./max(abs(v(:,i)));
    end
end

clear v;
v = V;
clear V;



%% Filtering (Butterworth bandpass)

bp_l = input('Enter lower pass frequency: '); % Lower pass frequency
bp_u = input('Enter upper pass frequency: '); % Upper pass frequency

[b,a] = butter(3,bp_l/10,'high'); % coefficiennts of transfer function after applying butterworth filter
v = filtfilt(b,a,v); % zero phase filter
[b,a] = butter(3,bp_u/10,'low');
v = filtfilt(b,a,v);

%% Back Projection

cd ../resources/seizmo;
startup_seizmo;
cd ../../back_projection;

disp('Back Projection...');
beam = [];
amp = [];
sign = [];
T_corr = [];

% Loop through all source elements

window = input('Enter number of data points to stack: ');

for j = 1:length(e_lat)
    % Loop through all seismograms (stations)
    stack = [];
    for i = 1:length(stnlat)
        T = tauptime('dep',ev_depth,'ph','P','sta',[stnlat(i) stnlong(i)], 'evt',[e_lat(j) e_long(j)]);
        r = Cross_correlation(i,2); %cross correlation coefficient with first seismogram as reference trace ???
        t_corr = Cross_correlation(i,1); % Time shift with reference trace
        sign_f = Cross_correlation(i,3); 
        stn_w = Cross_correlation(i,4); 
        time_holder = cell2mat({T.time});
        tvl_t = time_holder + t_corr;
        if(isempty(tvl_t)==1)
            % I noticed that if the station is out of range, tauptime gives an empty struct, so If the struct is empty, I am skipping the station
            continue;
         end
        if (abs(r) >= 0) %condition is always true???
            %aligning the seismograms
            
            [in sign] = amp_sign(tvl_t(1),v(:,i),t(:,i)) %index of P wave arrival and its polarity
            if (in<window)
                stack(1:window,i) = (cut_window(v(:,i),in,in+(window-1))*sign_f*abs(r))./(stn_w);
            end
            
        else
            stack(1:window,i) = 0;
        end
    end
    temp = sum(stack')'; %adding all the seismograms for each grid point
    beam(j,:) = temp(:,1); %assigning stack for eack grid point
    clear temp;
end

temp = [];

for i = 1:(window/sampling)
    temp(:,i) = beam_avg(beam(:,(i-1)*sampling+1:i*sampling),1,sampling); 
    % we are taking the stacked seismogram at each grid point, calculating
    % the average of every 20 data points and assigning it to temp to
    % reduce the number of data points
end

save(strcat('output/beam_',num2str(bp_l),'_',num2str(bp_u),'Hz_',array,'.txt'),'temp','-ascii');

disp('Stacking Done');