
f=fullfile('output',['stack_uncorr_' num2str(bp_l) '_' num2str(bp_u) 'HZ_' array '.txt' ]); 
uncorr=load(f);
f=fullfile('output',['stack_corr_' num2str(bp_l) '_' num2str(bp_u) 'HZ_' array '.txt' ]); 
corr=load(f);

f=fullfile('data',['data_info_' array '.txt' ]); 
info_matlab=load(f);

[m n]=size(corr);

% m - number of samples | n - number of stations

%% sort traces according to some parameter and store the index for reference
[val in]=sort(info_matlab(:,1));
%% Plotting
st = input('Enter the starting index (for plotting): ');
ed= input('Enter the trailing index (for plotting): ');

sampling = input('Enter sampling frequency: ');
for i=1:n
    subplot(1,3,1)
    plot(val) % plots the sorting parameter after sorting
    grid on

    % plot unaligned seismograms
    subplot(1,3,2)
    plot((st:1:ed),uncorr(st:ed,in(i))+i,'LineWidth',1,'color','black');
    title(['Unaligned Z component (' array ')'],'FontSize',15,'fontweight','bold','Fontname','Times')
    xlabel('time (s)','FontSize',15,'fontweight','bold','Fontname','Times')
    ylabel('Trace Number','FontSize',15,'fontweight','bold','Fontname','Times')
    hold on
    grid on
    
    % plot aligned seismograms
    subplot(1,3,3)
    plot((st:1:ed),corr(st:ed,in(i))+i,'LineWidth',1,'color','black');
    title(['Aligned Z component (' array ')'],'FontSize',15,'fontweight','bold','Fontname','Times')
    xlabel('time (s)','FontSize',15,'fontweight','bold','Fontname','Times')
    ylabel('Trace Number','FontSize',15,'fontweight','bold','Fontname','Times')
    hold on
    grid on
    
end