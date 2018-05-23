clear all;
cd output;
peak = load('peak_energy.txt');
cd ..;
dist=[];
t=[];
v=[];
d=[];
d1=[];
d2=[];
distance = @(lat1,long1,lat2,long2) (((lat1-lat2)^2 + (long1-long2)^2)^0.5)*111.11;
for i=2:1:length(peak)-1
    t=[t;i];
    dist(i-1)=distance(peak(i,3),peak(i,2),peak(i-1,3),peak(i-1,2));
    dist2(i-1)=distance(peak(i,3),peak(i,2),peak(1,3),peak(1,2));
    d1=[d1;dist(i-1)];
    d2=[d2;dist2(i-1)];
    d=[d;sum(dist)];

end
hold on
 plot(t,d,'o','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','b')
 plot(t,d2,'o','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','r')
 plot(t,d1,'o','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','g')
 title('Wavefront Velocity ','FontSize',15,'fontweight','bold','Fontname','Times')
 ylabel('Distance (km)','FontSize',15,'fontweight','bold','Fontname','Times')
 xlabel('Time (s)','FontSize',15,'fontweight','bold','Fontname','Times')
 [l,x,z] = fit(t,d,'poly1');
 hold on
 %plot(l);
 grid on
 hold on
 plot((1:90),2*(1:1:90),'b')
 hold on
 plot((1:90),2.5*(1:1:90),'g')
 hold on
 plot((1:90),3*(1:1:90),'k')
 hold on
 plot((1:90),3.5*(1:1:90),'c')
 hold on
 plot((1:90),4*(1:1:90),'r')
 legend('data','2 km/s','2.5 km/s','3 km/s','3.5 km/s', '4 km/s')

 cd output;
 f_R_G=['rupture_vel.txt'];
        fin=fopen(f_R_G,'w');
        for i=1:length(t)
            fprintf(fin,'\n %f %f %f %f ',t(i),d(i),v(i),peak(i,4));
        end
    fclose(fin);
cd ..;
 