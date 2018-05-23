%% Cross correlates the given data for each array
clear length;
disp('Loading data...');
%%
%Data loading

f = fullfile('data',['V_' array '.txt']); % V file contains velocity data from all the stations in one single column
V = load(f);

f=fullfile('data',['T_' array '.txt']);
T = load(f);

f = fullfile('data',['stnlat_' array]);
stnlat = load(f);

f = fullfile('data',['stnlong_' array]);
stnlong = load(f);

n_stn = length(stnlat); % NO. of stations

ev_depth = input('Enter event depth: ');

len = input('Enter number of data points (for each station): '); % (Length of cut file) No. of data points for each station

no = length(V)/len; %no of stations

ref_t = ref_trace(stnlong,stnlat);

disp(' ');
display('Enter window in which cross correlation is to be done');
starts = input('Starting index: ');
ends = input('Trailing index: ');

sampling = input('Enter the sampling frequency: ');
v=[];
t=[];
for i = 1:1:no
    j = i-1;

    v(:,i) = V((1 + j*len) : (j*len + len)); 
    % the rows from 1 to len of V are picked and stored in the first column of
    % v, corresponding to the first station, then for the next step, len is
    % added to the indices 1 and len for the next len data
    % points corresponding to the next station and so on
    t(:,i) = T(1 + (j*len) : (j*len) + len);

end

disp('Loading finished...');
%% Cross correlation
disp('Cross correlating...');
Sign = [];
Time_corr = [];
Corr_coeff = [];
sign = [];
stn_weight = [];

% calculating time correlation and cross correlation coefficient

for i = 1:n_stn
    [r, t_corr, sign] = crosscorr_align(v(:,ref_t),v(:,i),starts,ends,sampling); % cross correlating
    % r is the point of max(XCF) -> correlation coefficient, t_corr is the time shift and sign is the
    % sign of the peak XCF
    Time_corr = [Time_corr;t_corr]; %time shift for all the stations
    Corr_coeff = [Corr_coeff;r]; % correlation coefficients for all the stations
    Sign = [Sign;sign]; % sign of peak XCF for all the stations
end

%%

%station weitghtage according to density within 1 degree radius 
for i=1:length(stnlat)
    count=0;
    for j=1:length(stnlat)
        dist = ((stnlat(i)-stnlat(j))^2 + (stnlong(i)-stnlong(j))^2)^(0.5); % calculate distance of every station from every other station //why are we taking fifth root???
        if (dist<=1) 
            count=count+1;
        else
            continue
        end
    end
    stn_weight(i)=count;
end

%% Saving
disp('Saving data...');

f_R_G = ['output/Cross_correlation_' array '.txt']; %output file
fin = fopen(f_R_G,'w'); 
for i=1:length(stnlat)
    fprintf(fin,'%e %e %e %e\n',Time_corr(i),Corr_coeff(i),Sign(i),stn_weight(i));
end
fclose(fin);

save(strcat('output/velocity_',array,'.txt'),'v','-ascii');
save(strcat('output/time_',array,'.txt'),'t','-ascii');

disp('Data saved');

%rupture_back_projection;