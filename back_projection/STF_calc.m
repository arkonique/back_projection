%% Script to calculate the STF
n_arr=length(a_arr);

h = fspecial('average',[1 100]); % defining a 2 D smoothing filter
j=1;

stf=[];
for i=1:n_arr
    array=a_arr(i,:)
    f = fullfile('output',['stack_uncorr_',num2str(bp_l),'_',num2str(bp_u),'Hz_',array,'_stf.txt']);
    uncorr = load(f);

    f = fullfile('output',['stack_corr_' num2str(bp_l) '_' num2str(bp_u) 'Hz_' array '_stf.txt']);
    corr = load(f);

    %% Plotting the stf

    starts = 1;
    ends = 1500;

    subplot(n_arr+1,2,j);

    plot((starts-starts:1:ends-starts)*0.05,corr(starts:ends,:),'color', [0 0 0],'LineWidth',1)
    title(['Aligned Z component (' array ')'],'FontSize',15,'fontweight','bold','Fontname','Times')
    xlabel('time (s)','FontSize',15,'fontweight','bold','Fontname','Times')
    ylabel('Amplitude','FontSize',15,'fontweight','bold','Fontname','Times')

    subplot(n_arr+1,2,j+1);

    [m n] = size(corr); % m - number of samples || n - number of stations
    stf1 = (sum(corr(starts:ends,:)').^2)./max(sum(corr(starts:ends,:)').^2);
    x=filter2(h,stf1);
    stf = [stf;x];

    plot((starts-starts:1:ends-starts)*0.05,stf(i,:),'color', [0 0 0],'LineWidth',1)
    title(['STF (' array ')'],'FontSize',15,'fontweight','bold','Fontname','Times')
    xlabel('time (s)','FontSize',15,'fontweight','bold','Fontname','Times')
    ylabel('Amplitude','FontSize',15,'fontweight','bold','Fontname','Times')
    hold on
    j=j+2;
end

%% final stf
    stf2=sum(stf);
  
    subplot(n_arr+1,1,n_arr+1);
    plot((starts-starts:1:ends-starts)*0.05,stf2,'color', [0 0 0],'LineWidth',1)
    title(['STF'],'FontSize',15,'fontweight','bold','Fontname','Times')
    xlabel('time (s)','FontSize',15,'fontweight','bold','Fontname','Times')
    ylabel('Amplitude','FontSize',15,'fontweight','bold','Fontname','Times')
    hold on
   %% saving STF
     f_R_G=fullfile('output',['stf_' num2str(bp_l) '_' num2str(bp_u) 'HZ.txt']);
        fin=fopen(f_R_G,'w');
        for i=1:length(stf2)
            fprintf(fin,'\n %f %f',i*0.05,stf2(i)); % first column stores the time in seconds and the second column stores the STF
        end
    fclose(fin);