clear all;
close all;
clc;

disp('This is a script to do the back projection for an event given the required input files.');
disp('Please make sure you have copied all of the following files into the ./back_projection/data directory:-');
disp(' ');
disp('1. V_{array}.txt - File containing the velocity data of all the stations selected from the array in one single column');
disp('2. T_{array}.txt - FIle containing the corresponding time data for rall the stations selected from the array in one single column');
disp('3. P_time_{array} - File containing the P wave arrival time of the event at all all the selected stations of the array');
disp('4. stnlat_{array} - File containing the station latitudes of all the stations selected from the array');
disp('5. stnlong_{array} - File containing the station longitudes of all the stations selected from the array');
disp('6. data_info_{array}.txt - File containing the GCARC, AZ and BAZ of the event at all the stations selected from the array');
disp(' ');
input('Continue? (After making sure, press enter)','s');
clc

disp('Choose from where to start processing :-');
disp('0. Generate grid (Start from the beginning)');
disp('1. Station check');
disp('2. Cross correlation');
disp('3. Rupture back projection');
disp('4. Net stack alignment');
disp('5. Cumulative plot of energy');
disp('6. Plot of energy peaks at each second');
disp('7. Saving movie frames');
disp('8. Run a movie test');
disp('9. Stack plots for STF calculation');
disp('10. STF plot & calculation');
disp('11. Stack plots for plotting earthquake traces');
disp('12. Plot of all earthquake traces');
disp(' ');
listener=input('Enter your choice: ');
clc

%% Starting back projection
    if (listener<=0)
    delete array.txt;
    cd back_projection;
    gridgen;
    save variables/vars0;
    opts=input('Do you want to quit the program? (y/n)','s');
    if(opts=='y')
        return
    end
    end
    if (listener<=1)
    if (listener<=2)
    if(listener<=3)
    path=strsplit(pwd,'/');
    pathcheck=strcmp(cell2mat(path(end)),'back_projection');
    if (pathcheck==0)
        cd back_projection;
    end
    clear;
    load variables/vars0;
    o='y';
    
    a_arr = [];
    increment = 0;

    while(strcmpi(o,'y'))
        array = input('Enter array: ','s');
        disp(' ');
        disp('Station Check...');
        station_check;
        save variables/vars1;
        opts=input('Do you want to quit the program? (y/n)','s');
        if(opts=='y')
            return
        end
        clear;
        load variables/vars1;
        increment = increment+1;
        a_arr = [a_arr;array];
        disp(' ');
        disp('Cross Correlation...');
        Crosscorrelation;
        save variables/vars2;
        opts=input('Do you want to quit the program? (y/n)','s');
        if(opts=='y')
            return
        end
        clear;
        load variables/vars2;
        disp(' ');
        disp('Back Projection...')
        rupture_back_projection;
        save variables/vars3;
        opts=input('Do you want to quit the program? (y/n)','s');
        if(opts=='y')
            return
        end
        clear;
        load variables/vars3;
        o = input('Do you want to enter more arrays (y/n)? ','s');

    end

    cd ..;
    fid = fopen('array.txt','w');
    for j = 1:increment
        fprintf(fid,'%s \n',a_arr(j,:));
    end
    fclose(fid);
    cd back_projection;
    %%
    end
    end
    end
    if(listener<=4)
    path=strsplit(pwd,'/');
    pathcheck=strcmp(cell2mat(path(end)),'back_projection');
    if (pathcheck==0)
    cd back_projection;
    end
    
    load variables/vars3;
    disp(' ');
    disp('Aligning all the arrays...');
    net_stack_align;
    save variables/vars4;
    opts=input('Do you want to quit the program? (y/n)','s');
    if(opts=='y')
        return
    end
    end
    if (listener<=5)
    path=strsplit(pwd,'/');
    pathcheck=strcmp(cell2mat(path(end)),'back_projection');
    if (pathcheck==0)
    cd back_projection;
    end
    clear;
    load variables/vars4;
    %%
    input('Close the plot and press enter');
    disp(' ');
    disp('Doing a cumulative plot of the energy in the provided time window...');
    start_win = input('Enter the starting time of the window: ');
    end_win = input('Enter the closing the of the window: ');
    cumulative_plot(b_corr,e_lat,e_long,start_win,end_win,ev_lat,ev_long,bp_l,bp_u);
    input('Close the plot and press enter');
    save variables/vars5;
    opts=input('Do you want to quit the program? (y/n)','s');
    if(opts=='y')
        return
    end
    end
    if (listener<=6)
    path=strsplit(pwd,'/');
    pathcheck=strcmp(cell2mat(path(end)),'back_projection');
    if (pathcheck==0)
    cd back_projection;
    end
    clear;
    load variables/vars5;
    %%
    disp(' ');
    disp('Plotting the energy peak at all points in time (secs) within the time window...');
    end_win = input('Enter the closing time of the window (window starts from 1 second): ');
    peak_time_wise(b_corr,e_lat,e_long,end_win,ev_lat,ev_long);
    input('Close the plot and press enter');
    save variables/vars6;
    opts=input('Do you want to quit the program? (y/n)','s');
    if(opts=='y')
        return
    end
    end
    if (listener<=7)
    path=strsplit(pwd,'/');
    pathcheck=strcmp(cell2mat(path(end)),'back_projection');
    if (pathcheck==0)
    cd back_projection;
    end
    clear;
    load variables/vars6;

    disp(' ');
    disp('Saving movie frames ...');
    movie_slices(b_corr, e_lat, e_long, bp_l, bp_u);
    disp('Saved');
    save variables/vars7;
    opts=input('Do you want to quit the program? (y/n)','s');
    if(opts=='y')
        return
    end
    end
    if(listener<=8)
    path=strsplit(pwd,'/');
    pathcheck=strcmp(cell2mat(path(end)),'back_projection');
    if (pathcheck==0)
    cd back_projection;
    end
    clear;
    load variables/vars7;
    %%
    disp(' ');
    disp('Running a movie test');
    frameskip = input('Enter the number of frames to skip for testing: ');
    movie_test(b_corr,e_lat,e_long,bp_l,bp_u,frameskip);
    input('Close the plot and press enter');
    save variables/vars8;
    opts=input('Do you want to quit the program? (y/n)','s');
    if(opts=='y')
        return
    end
    end
    if(listener<=9)
    path=strsplit(pwd,'/');
    pathcheck=strcmp(cell2mat(path(end)),'back_projection');
    if (pathcheck==0)
    cd back_projection;
    end
    clear;
    load variables/vars8;

    %% Miscellaneous Calculations
    disp(' ');
    disp('Back Projection has been done. Starting miscellaneous calculations.');
    disp('STF calculation...');
    o='y';

    while(strcmpi(o,'y'))
        array=input('Enter the array: ','s');
        stack_plot;
        movefile(fullfile('output',['stack_uncorr_',num2str(bp_l),'_',num2str(bp_u),'Hz_',array,'.txt']),fullfile('output',['stack_uncorr_',num2str(bp_l),'_',num2str(bp_u),'Hz_',array,'_stf.txt']));
        movefile(fullfile('output',['stack_corr_',num2str(bp_l),'_',num2str(bp_u),'Hz_',array,'.txt']),fullfile('output',['stack_corr_',num2str(bp_l),'_',num2str(bp_u),'Hz_',array,'_stf.txt']));
        save variables/vars9;
        opts=input('Do you want to quit the program? (y/n)','s');
        if(opts=='y')
            return
        end
        clear;
        load variables/vars9;
        o=input('Do you want to enter more arrays? (y/n) ','s');
    end
    end
    if (listener<=10)
    path=strsplit(pwd,'/');
    pathcheck=strcmp(cell2mat(path(end)),'back_projection');
    if (pathcheck==0)
    cd back_projection;
    end
    load variables/vars9;
    STF_calc;
    input('Close the plot and press enter');
    save variables/vars10;
    opts=input('Do you want to quit the program? (y/n)','s');
    if(opts=='y')
        return
    end
    end
    if (listener<=11)
    if (listener<=12)
    path=strsplit(pwd,'/');
    pathcheck=strcmp(cell2mat(path(end)),'back_projection');
    if (pathcheck==0)
    cd back_projection;
    end
    clear;
    load variables/vars10;
    %%
    disp(' ');
    disp('Plotting earthquake traces...');
    o='y';
    while(strcmpi(o,'y'))
        array=input('Enter the array: ','s');
        stack_plot;
        trace_plot;
            save variables/vars11;
        opts=input('Do you want to quit the program? (y/n)','s');
        if(opts=='y')
            return
        end
        clear;
        load variables/vars11;
        o=input('Do you want to enter more arrays? (y/n) ','s');
    end
    end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To add any additional scripts, put the scripts in the './back_projection'
% directory  and then insert the script call in this section below.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ');
disp('Process completed');
cd ..;