function varargout = mStat_MigrationAnalyzer(varargin)
% MSTAT_MIGRATIONANALYZER MATLAB code for mStat_MigrationAnalyzer.fig
%      MSTAT_MIGRATIONANALYZER, by itself, creates a new MSTAT_MIGRATIONANALYZER or raises the existing
%      singleton*.
%
%      H = MSTAT_MIGRATIONANALYZER returns the handle to a new MSTAT_MIGRATIONANALYZER or the handle to
%      the existing singleton*.
%
%      MSTAT_MIGRATIONANALYZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSTAT_MIGRATIONANALYZER.M with the given input arguments.
%
%      MSTAT_MIGRATIONANALYZER('Property','Value',...) creates a new MSTAT_MIGRATIONANALYZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mStat_MigrationAnalyzer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mStat_MigrationAnalyzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mStat_MigrationAnalyzer

% Last Modified by GUIDE v2.5 01-Jan-2015 18:12:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_MigrationAnalyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_MigrationAnalyzer_OutputFcn, ...
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


% --- Executes just before mStat_MigrationAnalyzer is made visible.
function mStat_MigrationAnalyzer_OpeningFcn(hObject, eventdata, handles, varargin)


% Choose default command line output for mStat_MigrationAnalyzer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set_enable(handles,'init')

% Set the name and version
set(handles.figure1,'Name',['MStaT: Migration Analyzer '], ...
    'DockControls','off')

axes(handles.pictureReach);
axes(handles.signalvariation);

%data cursor type
dcm_objt0 = datacursormode(gcf);

set(dcm_objt0,'UpdateFcn',@mStat_myupdatefcnMigration);

set(dcm_objt0,'Displaystyle','Window','Enable','on');

pos = get(0,'userdata');


% --- Outputs from this function are returned to the command line.
function varargout = mStat_MigrationAnalyzer_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Toolbar Menu
% --------------------------------------------------------------------

% --------------------------------------------------------------------
function filefunctions_Callback(hObject, eventdata, handles)
% empty


% --------------------------------------------------------------------
function openfunctions_Callback(hObject, eventdata, handles)
% empty

function newproject_Callback(hObject, eventdata, handles)
set_enable(handles,'init')

% Push messages to Log Window:
    % ----------------------------
    log_text = {...
        '';...
        ['%----------- ' datestr(now) ' ------------%'];...
        'New Project'};
    statusLogging(handles.LogWindows, log_text)


% --------------------------------------------------------------------
function closefunctions_Callback(hObject, eventdata, handles)
% empty


% --------------------------------------------------------------------
function initialtime_Callback(hObject, eventdata, handles)
[handles.File,handles.Path,indx] = uigetfile({'*.txt';'*.kml';'*.xlsx'},...
    'Select Input File', 'MultiSelect','off');
guidata(hObject,handles)

handles.celltable=cell(2,3);

handles.celltable(2,2:3)={''};
guidata(hObject,handles)
      
if handles.File==0
    
    %warndlg('You need load two files')
    
else
    handles.numfile=length(handles.File);
    
    guidata(hObject,handles)
    if indx==1
        %read ascii
        handles.xyCl=importdata(fullfile(handles.Path,handles.File));
        handles.xCoord{1} = handles.xyCl(:,1);
        handles.yCoord{1} = handles.xyCl(:,2);
        
        
         if isnumeric(handles.xCoord{1}(1,1)) | isnumeric(handles.yCoord{1}(1,1))
         else
            handles.xCoord{1}(1,1) =[];
            handles.yCoord{1}(1,1) =[]; 
         end
        
         guidata(hObject,handles)
        
    elseif indx==2
    %Read KML

            kmlFile=fullfile(handles.Path,handles.File);

            handles.kmlFile{1}=kmlFile;
            guidata(hObject,handles)

            % read kml
            kmlStruct = kml2struct(kmlFile);
            %project kml in utm system
            [handles.xCoord{1}, handles.yCoord{1},handles.utmzone{1}] = deg2utm(kmlStruct.Lat,kmlStruct.Lon);
            guidata(hObject,handles)

        
    elseif indx==3
        %read xlsx
            xlsxFile=fullfile(handles.Path,handles.File);

            Ex=xlsread(xlsxFile);

            handles.xCoord{1} = Ex(:,1);
            handles.yCoord{1} = Ex(:,2);
            
        if isnumeric(handles.xCoord{1}(1,1)) | isnumeric(handles.yCoord{1}(1,1))
        else
            handles.xCoord{1}(1,1) =[];
            handles.yCoord{1}(1,1) =[]; 
        end
        
        guidata(hObject,handles)   
            
    end
    
    handles.celltable(1,1)={handles.File};
    set(handles.inputtable,'Data',handles.celltable)
    
    % Push messages to Log Window:
    % ----------------------------
    log_text = {...
        '';...
        ['%----------- ' datestr(now) ' ------------%'];...
        'Initial time centerline loaded'};
    statusLogging(handles.LogWindows, log_text)
    
end


% --------------------------------------------------------------------
function finaltime_Callback(hObject, eventdata, handles)
[handles.File,handles.Path,indx] = uigetfile({'*.txt';'*.kml';'*.xlsx'},...
    'Select Input File', 'MultiSelect','off');

celltable=get(handles.inputtable,'Data');

celltable(:,2:3)={''};

if handles.File==0
    
    %warndlg('You need load two files')
    
else
    handles.numfile=length(handles.File);
    
    guidata(hObject,handles)
    if indx==1
        %read ascii
        handles.xyCl=importdata(fullfile(handles.Path,handles.File));
        handles.xCoord{2} = handles.xyCl(:,1);
        handles.yCoord{2} = handles.xyCl(:,2);        
        
        if isnumeric(handles.xCoord{2}(1,1)) | isnumeric(handles.yCoord{2}(1,1))
        else
            handles.xCoord{2}(1,1) =[];
            handles.yCoord{2}(1,1) =[]; 
        end
        
       guidata(hObject,handles)        
        
    elseif indx==2
    %Read KML
            kmlFile=fullfile(handles.Path,handles.File);

            handles.kmlFile{2}=kmlFile;
            guidata(hObject,handles)

            % read kml
            kmlStruct = kml2struct(kmlFile);
            %project kml in utm system
            [handles.xCoord{2}, handles.yCoord{2},handles.utmzone{2}] = deg2utm(kmlStruct.Lat,kmlStruct.Lon);
            guidata(hObject,handles)
        
    elseif indx==3
        %read xlsx
            xlsxFile=fullfile(handles.Path,handles.File);

            Ex=xlsread(xlsxFile);

            handles.xCoord{2} = Ex(:,1);
            handles.yCoord{2} = Ex(:,2);
            
            
        if isnumeric(handles.xCoord{2}(1,1)) | isnumeric(handles.yCoord{2}(1,1))
        else
            handles.xCoord{2}(1,1) =[];
            handles.yCoord{2}(1,1) =[]; 
        end
        guidata(hObject,handles) 
    end
    
    celltable(2,1)={handles.File};
    set(handles.inputtable,'Data',celltable)
    
    set_enable(handles,'loadfiles')
    
        % Push messages to Log Window:
        % ----------------------------
        log_text = {...
            '';...
            ['%----------- ' datestr(now) ' ------------%'];...
            'Final time centerline loaded'};
        statusLogging(handles.LogWindows, log_text)
    
end


% --------------------------------------------------------------------
function export_Callback(hObject, eventdata, handles)
% empty


% --------------------------------------------------------------------
function matfiles_Callback(hObject, eventdata, handles)
hwait = waitbar(0,'Exporting .mat File...');

%save data
geovar=getappdata(0, 'geovarf');

[file,path] = uiputfile('*.mat','Save file');
save([path file], 'geovar');
waitbar(1,hwait)
delete(hwait)


        % Push messages to Log Window:
    % ----------------------------
    log_text = {...
        '';...
        ['%----------- ' datestr(now) ' ------------%'];...
        'Export MAT file succesfully'};
    statusLogging(handles.LogWindows, log_text)


% --------------------------------------------------------------------
function htmlfiles_Callback(hObject, eventdata, handles)
hwait = waitbar(0,'Exporting .mat File...');

%save data
options.format='html';
options.showCode=false;
publish('mStat_PublishHtml.m',options);

waitbar(1,hwait)
delete(hwait)


        % Push messages to Log Window:
    % ----------------------------
    log_text = {...
        '';...
        ['%----------- ' datestr(now) ' ------------%'];...
        'Export html report file succesfully'};
    statusLogging(handles.LogWindows, log_text)


% --------------------------------------------------------------------
function summary_Callback(hObject, eventdata, handles)
mStat_SummaryMigration(handles.Migra);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate
% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
tableData = get(handles.inputtable, 'data');
% 
linkaxes(handles.wavel_axes)
delete(allchild(handles.wavel_axes))

cla(handles.pictureReach)
cla(handles.signalvariation)
linkaxes(handles.signalvariation)
delete(allchild(handles.signalvariation))

handles.width=str2double(cellstr(tableData(:,3)));
handles.year=str2double(cellstr(tableData(:,2)));

%Calculate
sel=2;%Inflection points
handles.bendSelect=[];
Tools=2;
for i=1:2
    [geovar{i}]=mStat_planar(handles.xCoord{i},handles.yCoord{i},handles.width(i),sel,handles.pictureReach,handles.bendSelect,Tools);
end

%save data
setappdata(0, 'geovarf', geovar);

%obj=datacursormode(gcf);

handles.geovar=geovar;
guidata(hObject,handles)

%Calculate the migration using vectors
Migra=mStat_Migration(geovar,handles);

handles.Migra=Migra;
guidata(hObject,handles)

%store data
setappdata(0, 'Migra', Migra);
setappdata(0, 'handles', handles);

set_enable(handles,'results')

        % Push messages to Log Window:
    % ----------------------------
    log_text = {...
        '';...
        ['%----------- ' datestr(now) ' ------------%'];...
        'Calculate finished'};
    statusLogging(handles.LogWindows, log_text)
    
    
    if isnan(Migra.cutoff)
    else
                % Push messages to Log Window:
    % ----------------------------
    log_text = {...
        '';...
        ['%----------- ' datestr(now) ' ------------%'];...
        'CUTOFF FOUND!!!'};
    statusLogging(handles.LogWindows, log_text)
    end
    


% --- Executes on button press in identifycutoff.
function identifycutoff_Callback(hObject, eventdata, handles)
%read variables
Migra=handles.Migra;
geovar=handles.geovar;

cut=nan;
%Indentify cutoff using wavelength
e=1;
 for t=1:length(Migra.Indext1)
    if nansum(isfinite(Migra.cutoff(Migra.Indext1{t}.ind(1,2:end-1))))>1
        [r,fin]=max(isfinite(Migra.cutoff(Migra.Indext1{t}.ind)));
        cut(e)=Migra.Indext1{t}.ind(fin(1,1));
        e=e+1;
        clear fin r
    end
 end
 
 if isnan(cut)
     warndlg('Doesn´t found Cutoff')
 else     
    axes(handles.pictureReach)
    hold on
    text(geovar{1}.equallySpacedX(cut),geovar{1}.equallySpacedY(cut),'Cutoff')
    hold off
 end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extra Function
%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_enable(handles,enable_state)
%Set initial an load files
switch enable_state
    case 'init'
    axes(handles.signalvariation)
    cla reset
    axes(handles.wavel_axes)
    cla reset
    axes(handles.pictureReach)
    cla reset
    set(handles.calculate,'Enable','off');
    set(handles.inputtable, 'Data', cell(2,3));
    set(findall(handles.cutoffpanel, '-property', 'enable'), 'enable', 'off')
    set(findall(handles.panelresults, '-property', 'enable'), 'enable', 'off')
    set(handles.summary,'Enable','off');
    set(handles.export,'Enable','off');
    case 'loadfiles'
    cla(handles.signalvariation)
    cla(handles.wavel_axes)
    set(handles.calculate,'Enable','on');
    set(findall(handles.panelresults, '-property', 'enable'), 'enable', 'on')
    case 'results'
    set(findall(handles.cutoffpanel, '-property', 'enable'), 'enable', 'on')
    set(handles.summary,'Enable','on');
    set(handles.export,'Enable','on');
    otherwise
end


% --- Executes on selection change in LogWindows.
function LogWindows_Callback(hObject, eventdata, handles)
% empty


% --- Executes during object creation, after setting all properties.
function LogWindows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LogWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
