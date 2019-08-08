function varargout = mStat_AddXYData(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------MEANDER STATISTICS TOOLBOX. MStaT------------------------
% This function read multi files and processes all data.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_AddXYData_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_AddXYData_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mStat_AddXYData is made visible.
function mStat_AddXYData_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% Set the name and version
set(handles.figure1,'Name',['MStaT: Input Data'], ...
    'DockControls','off')

% Choose default command line output for mStat_AddXYData
handles.output = hObject;

% Update handles structure

handles.Previous = varargin{1};
ReadVar  = getappdata(0, 'ReadVar');
AdvancedSet  = getappdata(0, 'AdvancedSet');
guidata(hObject, handles);

str{1}=['Select Column'];
str{2}=ReadVar{1}.xCoord(1);
str{3}=ReadVar{1}.yCoord(1);

for i=1:length(ReadVar)
    filetable(i,2)={ReadVar{i}.File};
    filetable(i,3)={''}; 
    
    t=ReadVar{i}.File;

    if t(end)=='p'%only for shapefile
        filetable(i,1)={'0'};
    else
        set(handles.inputtable,'ColumnEditable',[false false true]) 
    end
end

%Initial settings
set(handles.inputtable,'Data',filetable) 

set(handles.currentfileradiobutton, 'Value', 1);
set(handles.coordinatesystem, 'Value', ReadVar{1}.CS);

set(handles.popupX, 'String', str,'Value',2);
set(handles.popupY, 'String', str,'Value',3);
set(handles.advancedsetting, 'Enable', 'off');


guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = mStat_AddXYData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in addfile.
function addfile_Callback(hObject, eventdata, handles)

handles.multisel='on';
handles.Module=handles.Previous.Module;
handles.Previous.first=0;

mStat_ReadInputFiles(handles.Previous);

ReadVar  = getappdata(0, 'ReadVar');

filetable = get(handles.inputtable,'Data') ;

if length(ReadVar)==size(filetable,1)
    
else
    sizet=size(filetable,1);
    for i=1:length(ReadVar)-sizet
        filetable(sizet+i,2)={ReadVar{size(filetable,1)+i}.File};
        filetable(sizet+i,3)={''};  
    end
    set(handles.inputtable,'Data',filetable)
end
    

% % --- Executes on button press in addfiles.
% function addfiles_Callback(hObject, eventdata, handles)
% 
% multisel='on';
% 
% mStat_ReadInputFiles(handles.Previous);
% 
% [File,Path] = uigetfile({'*.shp;*.kml;*.txt;*.xls;*.xlsx',...
% 'MStaT Files (*.shp,*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},...
% 'Select Input File','MultiSelect',multisel,handles.Path{1});
% 
% if ischar(File)%empty file
%     
%     FileName=[handles.File{1} File];
%     
%     PathName=[handles.Path{1} Path];
%     
%     handles.File{1}=FileName;
%     handles.Path=PathName;
%     handles.numfile=handles.numfile+size(File,2);
%     filetable(:,2)=handles.File{1}';
%     filetable(1:handles.numfile,3)={''};
%     guidata(hObject,handles)
%     
%     set(handles.inputtable,'Data',filetable)
% end
    
% --- Executes on button press in quitfiles.
function quitfiles_Callback(hObject, eventdata, handles)
ReadVar  = getappdata(0, 'ReadVar');
AdvancedSet  = getappdata(0, 'AdvancedSet');

%This function quit files readed
if handles.SelectFile==0
    warndlg('Please select the file that you can delete')
else
    
    ReadVar(handles.SelectFile) = [];    
    AdvancedSet(handles.SelectFile) = [];  
    
    numfile=size(ReadVar,2);
    
    for i=1:numfile
        ReadVar{i}.numfile = numfile;
        filetable(i,2) = {ReadVar{i}.File};
        filetable(i,3)={''}; 
    end

    guidata(hObject,handles)
    
    set(handles.inputtable,'Data',filetable)
end

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles,varargout)

calculation(hObject,handles)


% --- Executes on selection change in coordinatesystem.
function coordinatesystem_Callback(hObject, eventdata, handles)
% hObject    handle to coordinatesystem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns coordinatesystem contents as cell array
%        contents{get(hObject,'Value')} returns selected item from coordinatesystem


% --- Executes during object creation, after setting all properties.
function coordinatesystem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to coordinatesystem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected cell(s) is changed in inputtable.
function inputtable_CellSelectionCallback(hObject, eventdata, handles)
% Define the row number selected
handles.SelectFile=eventdata.Indices(:,1);
guidata(hObject,handles)
ReadVar  = getappdata(0, 'ReadVar');

if handles.SelectFile==0
    warndlg('Please select the file that you can delete')
else
    TableFile=get(handles.inputtable,'Data');
    set(handles.coordinatesystem,'Value',ReadVar{handles.SelectFile}.CS)
    
    str{2}=ReadVar{handles.SelectFile}.xCoord(1);
    str{3}=ReadVar{handles.SelectFile}.yCoord(1);
    set(handles.popupX, 'String', str,'Value',2);
    set(handles.popupY, 'String', str,'Value',3);

    set(handles.advancedsetting, 'Enable', 'on');
    
end

function [Control]=control(handles)
Control=1;
ReadVar  = getappdata(0, 'ReadVar');

%This function control all input data is complete
if handles.CS==1
    warndlg('Please select a Coordinate System')
    Control=0;
end

%control width inputs
if  nansum(isfinite(str2double(handles.width)))==length(ReadVar)
    
else
    warndlg('Please input all channels width')
    Control=0;
end


% --- Executes on selection change in popupXData.
function popupXData_Callback(hObject, eventdata, handles)
% hObject    handle to popupXData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupXData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupXData


% --- Executes during object creation, after setting all properties.
function popupXData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupXData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupYData.
function popupYData_Callback(hObject, eventdata, handles)
% empty


% --- Executes during object creation, after setting all properties.
function popupYData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupYData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [ReadVar]=calculation(hObject,handles)
%Read data
ReadVar  = getappdata(0, 'ReadVar');
AdvancedSet  = getappdata(0, 'AdvancedSet');

sel=1;%Inflection method

%Read width data
TableFile=get(handles.inputtable,'Data');

handles.width=TableFile(:,3);

handles.CS=get(handles.coordinatesystem,'Value');

[Control]=control(handles);

if Control==1
    for i=1:length(ReadVar)
               
        %only if shapefile
        t=char(ReadVar{i}.File);
        if t(end)=='p'
            if str2double(TableFile{i,1})==0
                p=1;
                for p=1:length(ReadVar{i}.stringsId)
                    for o=1:length(ReadVar{i}.xCoord)
                        if ReadVar{i}.Ids(o) == p                   
                            xCoord(o)=ReadVar{i}.xCoord(o);
                            yCoord(o)=ReadVar{i}.yCoord(o);
                        end
                    end
                        xCoord(xCoord==0)=[];
                        yCoord(yCoord==0)=[];
                        ReadVar{i}.Brad{p}.xCoord = xCoord;
                        ReadVar{i}.Brad{p}.yCoord = yCoord;
                        
                        clear xCoord yCoord
                end   
                set(handles.Previous.inputtable,'ColumnEditable',[false false])
                
            else
                for o=1:length(ReadVar{i}.xCoord)
                    if ReadVar{i}.Ids(o) == str2double(TableFile{i,1})                    
                        xCoord(o)=ReadVar{i}.xCoord(o);
                        yCoord(o)=ReadVar{i}.yCoord(o);
                    end
                end
                        xCoord(xCoord==0)=[];
                        yCoord(yCoord==0)=[];
                        ReadVar{i}.xCoord = xCoord;
                        ReadVar{i}.yCoord = yCoord;
                        clear xCoord yCoord
                        
                set(handles.Previous.inputtable,'ColumnEditable',[false true])
            end

        end
         
        %condition depending of the module
        if ReadVar{1}.Module==1%initial panel
            
            ReadVar{i}.width=str2double(cellstr(handles.width(i)));
             %Write in popupChannel
            str{1,1}=['Select Channel'];
            
            for i=1:ReadVar{1}.numfile
                str{i+1,1}=ReadVar{i}.File;
            end
            
            set(handles.Previous.popupChannel, 'String', str,'Enable','on');
            set(handles.Previous.selector, 'Value',2,'Enable','on');
            
            %Calculate and plot planar variables
            [geovar{i}]=mStat_planar(ReadVar{i}.xCoord,ReadVar{i}.yCoord,ReadVar{i}.width,ReadVar{i}.File,...
            sel,ReadVar{i}.Module,ReadVar{i}.Level, AdvancedSet{i});
        
            setappdata(0, 'geovar', geovar);
            setappdata(0, 'ReadVar', ReadVar);
            close(handles.figure1)
            
                % Push messages to Log Window:
            %     % ----------------------------
             log_text = {...
                '';...
                ['%--- ' datestr(now) ' ---%'];...
                'Loaded:';[cell2mat({ReadVar{i}.File})]};
                statusLogging(handles.Previous.LogWindow, log_text) 
                
         
        elseif ReadVar{1}.Module==2%Migration Module  
               ReadVar{i}.width=str2double(cellstr(handles.width(i)));
                
                %Calculate and plot planar variables
                [geovar{i}]=mStat_planar(ReadVar{i}.xCoord,ReadVar{i}.yCoord,ReadVar{i}.width,ReadVar{i}.File,...
                sel,ReadVar{i}.Module,ReadVar{i}.Level, AdvancedSet{i});
            
                celltable(i,1)={ReadVar{i}.File};
                celltable(i,2)={''};
                set(handles.Previous.sedtable,'Data',celltable) 
            
                set(handles.Previous.calculate,'Enable','on'); 
            
                 %plot
                 axes(handles.Previous.pictureReach)
                 hold on
                 plot(ReadVar{i}.xCoord,ReadVar{i}.yCoord)%start   
                 legend('t0','t1','Location','Best') 
                 grid on
                 axis equal 
                 xlabel('X [m]');ylabel('Y [m]')
                 hold off
                 setappdata(0, 'geovar', geovar);
                 setappdata(0, 'ReadVar', ReadVar);           
                 
                 close(handles.figure1)
                 
            % Push messages to Log Window:
            %     % ----------------------------
            log_text = {...
                        '';...
                        ['%--- ' datestr(now) ' ---%'];...
                        'Loaded:';[cell2mat({ReadVar{i}.File})]};
                        statusLogging(handles.Previous.LogWindow, log_text)
                        
        elseif ReadVar{1}.Module==3% Module confluence and Difluence
            
            ReadVar{i}.width=str2double(cellstr(handles.width(i)));
            %Calculate and plot planar variables
            [geovar{i}]=mStat_planar(ReadVar{i}.xCoord,ReadVar{i}.yCoord,ReadVar{i}.width,ReadVar{i}.File,...
            sel,ReadVar{i}.Module,ReadVar{i}.Level, AdvancedSet{i});
        
            celltable(i,2)={'None'};
            celltable(i,1)={ReadVar{i}.File};              
       
            set(handles.Previous.inputtable,'Data',celltable) 
                
            setappdata(0, 'geovar', geovar);
            setappdata(0, 'ReadVar', ReadVar);
            
            %plot
            axes(handles.Previous.pictureReach)
            hold on
            plot(ReadVar{i}.xCoord,ReadVar{i}.yCoord)
            %legend('t0','t1','Location','Best') 
            grid on
            axis equal 
            xlabel('X [m]');ylabel('Y [m]')
            hold off
            setappdata(0, 'geovar', geovar);
            setappdata(0, 'ReadVar', ReadVar);  
                 
            % Push messages to Log Window:
            %     % ----------------------------
            log_text = {...
                        '';...
                        ['%--- ' datestr(now) ' ---%'];...
                        'Loaded:';[cell2mat({ReadVar{i}.File})]};
                        statusLogging(handles.Previous.LogWindow, log_text)
                        
            set(handles.Previous.calculate,'Enable','on'); 
            
            
        elseif ReadVar{1}.Module==4;% Module braiding
                
                
                ReadVar{i}.width=str2double(cellstr(handles.width(i)));

                if handles.Previous.multi==1
                    celltable(i,1)={ReadVar{i}.File};
                    axes(handles.Previous.braiding_axes)
                    StrPeak='Multi Select Option';
                    xposFM=0.2;
                    yposFM=0.5;
                    text(xposFM,yposFM,StrPeak,'fontsize',15);
                else 
                    axes(handles.Previous.braiding_axes)
                    hold on
                    plot(ReadVar{i}.xCoord,ReadVar{i}.yCoord)%start
                    grid on
                    axis equal 
                    xlabel('X [m]');ylabel('Y [m]')
                    hold off    


                        celltable(i,1)={ReadVar{i}.File};
                    if str2double(TableFile{i,1})==1 
                        celltable(i,2)={'Main Channel'};
                    elseif str2double(TableFile{i,1})==2
                        celltable(i,2)={'Secondary Channel'};
                    end
                end
                
                set(handles.Previous.inputtable,'Data',celltable) 
                set(handles.Previous.calculate,'Enable','on'); 
                
                setappdata(0, 'ReadVar', ReadVar);

        end
        
    end
    
%    if ReadVar{1}.Module==4% Module braiding
%         if length(ReadVar)==1
%            warndlg('Almost two file is necesary')
%         end
%    else
        %Store data file
        guidata(hObject,handles)
        close(handles.figure1)
%    end
   
                
                

end



% --- Executes on button press in advancedsetting.
function advancedsetting_Callback(hObject, eventdata, handles)

%Read width data
TableFile=get(handles.inputtable,'Data');

if isempty(TableFile{handles.SelectFile,3})
    warndlg('Please input the width')
else
       
    TableFile = get(handles.inputtable,'Data');

    width = str2double(cellstr(TableFile(handles.SelectFile,3)));

    ReadVar  = getappdata(0, 'ReadVar');

    %only if shapefile
    t=char(ReadVar{handles.SelectFile}.File);
    if t(end)=='p'
        if str2double(TableFile{handles.SelectFile,1})==0
        else
            for o=1:length(ReadVar{handles.SelectFile}.xCoord)
                if ReadVar{handles.SelectFile}.Ids(o) == str2double(TableFile{handles.SelectFile,1})                    
                    xCoord(o)=ReadVar{handles.SelectFile}.xCoord(o);
                    yCoord(o)=ReadVar{handles.SelectFile}.yCoord(o);
                end
            end
            clear ReadVar{handles.SelectFile}.xCoord ReadVar{handles.SelectFile}.yCoord 
            ReadVar{handles.SelectFile}.xCoord = xCoord;
            ReadVar{handles.SelectFile}.yCoord = yCoord;
        end

    end

    setappdata(0, 'ReadVar', ReadVar);

    mStat_AdvancedSetting(handles.SelectFile,width)
end



% --- Executes on button press in currentfileradiobutton.
function currentfileradiobutton_Callback(hObject, eventdata, handles)

set(handles.currentfileradiobutton, 'Value', 1);
set(handles.allfilesradiobutton, 'Value', 0);


% --- Executes on button press in allfilesradiobutton.
function allfilesradiobutton_Callback(hObject, eventdata, handles)

set(handles.currentfileradiobutton, 'Value', 0);
set(handles.allfilesradiobutton, 'Value', 1);



% --- Executes on selection change in popupX.
function popupX_Callback(hObject, eventdata, handles)
% empty


% --- Executes during object creation, after setting all properties.
function popupX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupY.
function popupY_Callback(hObject, eventdata, handles)
% empty


% --- Executes during object creation, after setting all properties.
function popupY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in inputtable.
function inputtable_CellEditCallback(hObject, eventdata, handles)
% empty


% --- Executes during object creation, after setting all properties.
function inputtable_CreateFcn(hObject, eventdata, handles)
% empty
