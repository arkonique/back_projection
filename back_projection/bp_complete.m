function grids =  gridgen(a)

f = figure('Visible','off','Resize','off','Name','Source Grid generator','NumberTitle','off','Position',[300 200 500 300]);

uicontrol('Style','text','String','Lower latitude','FontSize',11,'Position',[0 205 150 50]);
uicontrol('Style','text','String','Upper latitude','FontSize',11,'Position',[230 205 150 50]);
l_lat = uicontrol('Style','edit','Position',[125 230 100 30]);
u_lat = uicontrol('Style','edit','Position',[355 230 100 30]);

uicontrol('Style','text','String','Left Longitude','FontSize',11,'Position',[0 125 150 50]);
uicontrol('Style','text','String','Right Longitude','FontSize',11,'Position',[225 125 150 50]);
l_long = uicontrol('Style','edit','Position',[125 150 100 30]);
r_long = uicontrol('Style','edit','Position',[355 150 100 30]);

uicontrol('Style','text','String','Grid Size','FontSize',11,'Position',[125 80 150 50]);
sizer = uicontrol('Style','edit','Position',[240 105 100 30]);

uicontrol('Style','pushbutton','String','Generate Grid','FontSize',11,'Position',[180 65 150 30],'Callback',@generate);

panel = uipanel(f,'Position',[0 0 1. 0.2]);

texter = uicontrol('Parent',panel,'Style','text','String','Input the values','Position',[175 -10 150 50],'FontSize',11);

set(f,'Menubar','none');
set(f,'Toolbar','none');


%%
% *Output figure*
f.Visible = 'on';

    function generate(hObject,eventdata,handles)
        e_lat = [];
        e_long = [];
        
        llat = str2double(get(l_lat,'String'));
        ulat = str2double(get(u_lat,'String'));
        llong = str2double(get(l_long,'String'));
        rlong = str2double(get(r_long,'String'));
        grd_size = str2double(get(sizer,'String'));
        
        for lat = llat:grd_size:ulat
            for long = llong:grd_size:rlong
                e_lat = [e_lat;lat];
                e_long = [e_long;long];
            end
        end
        
        grids = [llat,grd_size,ulat;llong,grd_size,rlong];
        e = [e_lat,e_long];
        
        save('data/grid.txt','e','-ascii');
        save('data/gridlim.txt','grids','-ascii');
        set(texter,'String','Grid is Generated');
    end

end


grids(1)