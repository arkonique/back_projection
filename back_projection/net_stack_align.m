
[sizer,NULL] = size(a_arr);
arrf = [];
for i=1:sizer
   a = a_arr(i,:);
   arrf(i,:,:) = load(fullfile('output',['beam_',num2str(bp_l),'_',num2str(bp_u),'Hz_',a,'.txt']));
end

% AU = load(fullfile('output',['beam_',num2str(bp_l),'_',num2str(bp_u),'Hz_AU.txt']));
% EU = load(fullfile('output',['beam_',num2str(bp_l),'_',num2str(bp_u),'Hz_EU.txt']));

gridlim = load(fullfile('data','gridlim.txt'));
grid = load(fullfile('data','grid.txt'));
e_lat=grid(:,1);
e_long=grid(:,2);
epicenter = strsplit(input('Enter earthquake epicenter: ','s'),',');
ev_lat = str2double(cell2mat(epicenter(1)));
ev_long = str2double(cell2mat(epicenter(2)));


index = epicenter_index(gridlim(1,1),gridlim(1,3),gridlim(2,1),gridlim(2,3),ev_lat,ev_long,gridlim(1,2)); %epicentre index. Found using epicentre_index.m function

%% Cross correlation

indexer = input('Enter the index of the array to be taken as reference(the first array you entered has an index 1 and so on): ');
refarr = squeeze(arrf(indexer,:,:));
win = input('Enter trailing time (in seconds) of the window in which to cross correlate: ');

Time_corr = [];
Corr_coeff = [];
Sign = [];
arrf_corr = [];
refarr_corr = refarr;

for i = 1:sizer
    curr_arr = squeeze(arrf(i,:,:));
    [R t] = crosscorr(refarr(index,1:win)'./max(refarr(index,1:win))',curr_arr(index,1:win)'./max(curr_arr(index,1:win))'); % R -> XCF, t-> time lag
    [r dt] = max(abs(R));
    [m n] = size(refarr);
    
    x = R(dt);
    if (x < 0)
         sign = -1;
    else
         sign  = 1;
    end
    
    Time_corr = [Time_corr;dt];
    Corr_coeff = [Corr_coeff;r];
    Sign = [Sign;sign];
     
end
n = n-max(Time_corr);
for i = 1:sizer
    
    for j = 1:m %m - grid points
        if (i == indexer)
            arrf_corr(i,j,1:n) = arrf(i,j,1:n);
            continue;

        else
           arrf_corr(i,j,1:n) = arrf(i,j,Time_corr(i):Time_corr(i)+n-1)*Sign(i);
        end
    end
end

%% Alignment has been done
% This part is just for visualisation
subplot(2,1,1);
hold on;

for i = 1:sizer
    plot( squeeze(arrf_corr(i,index,:))./max( abs(squeeze(arrf_corr(i,index,:))) ),'LineWidth',1);
end

legend(a_arr);

xlabel('Time(seconds)','FontWeight','bold','FontSize',13,'FontName','Times');
ylabel('Relative Amplitude','FontWeight','bold','FontSize',13,'FontName','Times');
title(['STF from differet netwroks'],'FontWeight','bold','FontSize',15,'FontName','Times');
    

subplot(2,1,2)
hold on
for i = 1:sizer
   
    plot( squeeze(arrf(i,index,:))./max( abs(squeeze(arrf(i,index,:))) ),'LineWidth',1);
end

legend(a_arr);

xlabel('Time(seconds)','FontWeight','bold','FontSize',13,'FontName','Times');
ylabel('Relative Amplitude','FontWeight','bold','FontSize',13,'FontName','Times');
title(['STF from different netwroks'],'FontWeight','bold','FontSize',15,'FontName','Times');

%% Calculating the energy for each grid point

beam_sum_corr = squeeze(sum(arrf_corr.^2));
h=fspecial('average',[1 1]); %smoothing the beam
b_corr=filter2(h,beam_sum_corr);

beam_sum_uncorr = squeeze(sum(arrf.^2));
h=fspecial('average',[1 1]);
b_uncorr=filter2(h,beam_sum_uncorr);
