%% Loading the data
f = fullfile('output',['velocity_' array '.txt']);
v = load(f);

f = fullfile('output',['time_' array '.txt']);
t = load(f);

f = fullfile('output',['Cross_correlation_' array '.txt']);
XCF = load(f);


f = fullfile('data',['stnlat_' array]);
stnlat = load(f);

f=fullfile('data',['stnlong_' array ]); 
stnlong=load(f);

f=fullfile('data',['P_time_' array ]);
P_time=load(f);

reft = ref_trace(e_lat,e_long);

%% Normalising the velocity

V=[];
for i=1:length(stnlat)
    if v(:,i)==0
        
    else
        V(:,i) = v(:,i)./max(abs(v(:,i)));
    end
end

 
clear v;
v=V;
clear V;

%% Cross Correlation on unfiltered data
sampling = input('Enter sampling frequency: ');
Time_corr_f = XCF(:,1);
Corr_coeff_f = XCF(:,2);
Sign_f = XCF(:,3);

%% Filtering (explained in rupture_back_projection.m)
bp_l = input('Enter lower pass frequency: '); % Lower pass frequency
bp_u = input('Enter upper pass frequency: '); % Upper pass frequency

[b,a]=butter(3,[bp_l(1,1)/10],'high');
v=filtfilt(b,a,v);
[b,a]=butter(3,[bp_u(1,1)/10],'low');
v=filtfilt(b,a,v);
%%  Stacking the data

window = input('Enter number of data points to stack: ');
p = input('Enter number of data points to be taken before P wave arrival (seconds before P wave arrival): ')*sampling;
  stack_uncorr=[];
  stack_corr=[];
        for i=1:length(stnlat)
            t_corr=Time_corr_f(i); % time lag for the ith station
            sign_f=Sign_f(i); % sign of the peak for the ith station
            p_corr=P_time(i)+t_corr; % correcting for the time lag
            [in]=amp_sign(p_corr,v(:,i),t(:,i)); % index of the time corresponding to the p wave arrival time
            stack_corr(1:window,i)=(cut_window(v(:,i),in-p,in-p+(window-1))).*sign_f; % cutting the seismograms, taking the sign of the p wave arrival into account

            [in]=amp_sign(P_time(i),v(:,i),t(:,i)); % index of the p wave arrival (uncorrelated)
            stack_uncorr(1:window,i)=cut_window(v(:,i),in-p,in-p+(window-1)); % cutting uncorrelated data
            
            
        end
        
        
 save(['output/stack_uncorr_',num2str(bp_l),'_',num2str(bp_u),'HZ_' array '.txt'],'stack_uncorr','-ascii');

 save(['output/stack_corr_',num2str(bp_l),'_',num2str(bp_u),'HZ_' array '.txt'],'stack_corr','-ascii');

