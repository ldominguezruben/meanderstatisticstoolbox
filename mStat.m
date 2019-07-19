%-----------------MEANDER STATISTICS TOOLBOX. MStaT------------------------
%
% Meander Statistics Toolbox (MStaT), is a packaging of codes developed on 
% MATLAB, which allows the quantification of parameters dexscriptors of 
% meandering channels (sinuosity, arc-wavelength, amplitude, curvature, 
% inflection point, among other). To obtain all the meander parameters  
% MStaT uses the  function of wavelet transform to decompose the signail 
% (centerline). The toolbox obtains the Wavelet Spectrum, Curvature and 
% Angle Variation and the Global Wavelet Spectrum. The input data to use 
% MStaT is the Centerline (in a Coordinate System) and the average Width of 
% the study Channels. MStaT can analize a large number of bends in a short 
% time. Also MStaT allows calculate the migration of a period, and analizes 
% the migration signature. Finally MStaT has a Confluencer and Difuencer 
% toolbox that allow calculate the influence due the presence of the 
% tributary o distributary channel on the main channel. 
% For more information you can reviewed the Gutierrez and Abad 2014a and 
% Gutierrez and Abad 2014b.

%% Collaborations
% Lucas Dominguez. UNL, Argentina
% Jorge Abad. UTEC, Peru
% Ronald Gutierrez. UN, Colombia
%--------------------------------------------------------------------------

%      Begin initialization code - DO NOT EDIT.

function varargout = mStat(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);               
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
% If ERROR, write a txt file with the error dump info
try
    
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
catch err
    if isdeployed
        errLogFileName = fullfile(pwd,...
            ['errorLog' datestr(now,'yyyymmddHHMMSS') '.txt']);
        msgbox({['An unexpected error occurred. Error code: ' err.identifier];...
            ('Error details are being written to the following file: ');...
            errLogFileName},...
            'MStaT Status: Unexpected Error',...
            'error');
        fid = fopen(errLogFileName,'W');
        fwrite(fid,err.getReport('extended','hyperlinks','off'));
        fclose(fid);
        rethrow(err)
    else
        close force
        msgbox(['An unexpected error occurred. Error code: ' err.identifier],...
            'MStaT Status: Unexpected Error',...
            'error');
        rethrow(err);
    end
end

%--------------------------------------------------------------------------

function mStat_OpeningFcn(hObject, eventdata, handles, varargin)
%      This function executes just before mStat is made 
%      visible.  This function has no output arguments (see OutputFcn), 
%      however, the following input arguments apply.  
addpath utils
handles.output = hObject;
handles.mStat_version='v1.00';
% Set the name and version
set(handles.figure1,'Name',['Meander Statistics Toolbox (MStaT) ' handles.mStat_version], ...
    'DockControls','off')

set_enable(handles,'init')

% Draw the mstat Background
% -----------------
% pos = get(handles.mStatBackground,'position');
% axes(handles.mStatBackground);
% % if ~isdeployed 
%     X = imread('MStaT_background.png');
%     imdisp(X,'size',[pos(4) pos(3)]) % Avoids problems with users not having Image Processing TB
% % else
% %     X = imread('MStaT_background.jpg');
% %     X = imresize(X, [pos(4) pos(3)]);
% %     X = uint8(X);
% %     imshow(X,'Border','tight')
% % end
% uistack(handles.mStatBackground,'bottom')

%%%%%%%%%
%scalebar
%%%%%%%%%

% Push messages to Log Window:
    % ----------------------------
    log_text = {...
        '';...
        ['%----------- ' datestr(now) ' ------------%'];...
        'LETs START!!!'};
    statusLogging(handles.LogWindow, log_text)
handles.start=1;
guidata(hObject, handles);%      Updates handles structure.

%--------------------------------------------------------------------------

function varargout = mStat_OutputFcn(hObject, eventdata, handles)
%      Output arguments from this function are returned to the command line. 
%      Input arguments from this function are defined as below.  
%
varargout{1} = handles.output;

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
pos = get(handles.mStatBackground,'position');
 axes(handles.mStatBackground);
% if ~isdeployed 
   X = imread('MStaT_background.png');
   imdisp(X,'size',[pos(4) pos(3)]) % Avoids problems with users not having Image Processing TB
% else
%    X = imread('MStaT_background.jpg');
%    X = imresize(X, [pos(4) pos(3)]);
%    X = uint8(X);
%    imshow(X,'Border','tight')
% end

%axes(handles.pictureReach);
%uistack(handles.mStatBackground,'bottom')

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% Hint: delete(hObject) closes the figure
close_button = questdlg(...
    'You are about to exit MStaT. Any unsaved work will be lost. Are you sure?',...
    'Exit MStaT?','No');
switch close_button
    case 'Yes'
        delete(hObject)
        close all hidden
    otherwise
        return
end

%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
%MENU PANEL
%%%%%%%%%%%%%%%%

% -------------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
%Empty

% -------------------------------------------------------------------------
function newproject_Callback(hObject, eventdata, handles)
%New project function
axes(handles.pictureReach)
cla(handles.pictureReach,'reset')
set(gca,'xtick',[])
set(gca,'ytick',[])
%cla reset
clear geovar
clc

% Push messages to Log Window:
% ----------------------------
log_text = {...
            '';...
            ['%--- ' datestr(now) ' ---%'];...
            'NEW PROJECT!'};
            statusLogging(handles.LogWindow, log_text)
                
set_enable(handles,'init')


% -------------------------------------------------------------------------
function openfunction_Callback(hObject, eventdata, handles)
%opent function
set_enable(handles,'init')

%This function incorporate the initial data input
multisel='on';

persistent lastPath 
% If this is the first time running the function this session,
% Initialize lastPath to 0
if isempty(lastPath) 
    lastPath = 0;
end

if lastPath == 0
    [File,Path] = uigetfile({'*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel);
else %remember the lastpath
    [File,Path] = uigetfile({'*.kml;*.txt;*.xls;*.xlsx',...
    'MStaT Files (*.kml,*.txt,*.xls,*.xlsx)';'*.*',  'All Files (*.*)'},'Select Input File','MultiSelect',multisel,lastPath);
end

%[ReadVar]=mStat_ReadInputFiles(multisel,lastPath);

% Use the path to the last selected file
% If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
if Path ~= 0
    lastPath = Path;
end

if Path==0
    %empty file
else
    if iscell(File)%multifile
        handles.numfile=size(File,2); 
    else
        handles.numfile=1;
    end
    
    %Write file readed in multiselect tool
    mStat_AddXYData(File,Path,handles.pictureReach,handles.bendSelect);

    %Write in popupChannel
     str{1,1}=['Select Channel'];
     if handles.numfile==1
         str{2,1}=File;
     else
        for i=1:handles.numfile
            str{i+1,1}=File{i};
        end
     end
     
     set(handles.popupChannel, 'String', str,'Enable','on');
                                     
end  


% --------------------------------------------------------------------
function singlefile_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function multifiles_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function close_Callback(hObject, eventdata, handles)
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Export function

% --------------------------------------------------------------------
function exportfunction_Callback(hObject, eventdata, handles)
%Empty

%Matlab Export
% --------------------------------------------------------------------
function exportmat_Callback(hObject, eventdata, handles)
saveDataCallback(hObject, eventdata, handles)
            

function saveDataCallback(hObject, eventdata, handles)

[fileMAT,pathMAT] = uiputfile('*.mat','Save .mat file');

if fileMAT==0
else
    str=['Exporting' fileMAT];
    hwait = waitbar(0,str,'Name','MStaT');
    Parameters.PathFileName  = fullfile(pathMAT,fileMAT); 
    Parameters.geovar = getappdata(0,'geovar');
    waitbar(0.5,hwait)

    save([pathMAT fileMAT], 'Parameters');
    waitbar(1,hwait)
    delete(hwait)
    
    % Push messages to Log Window:
    % ----------------------------
    log_text = {...
            '';...
            ['%--- ' datestr(now) ' ---%'];...
            'Export .mat File Succesfully!'};
            statusLogging(handles.LogWindow, log_text)
end

%Excel Export
% --------------------------------------------------------------------
function exportexcelfile_Callback(hObject, eventdata, handles)
savexlsDataCallback(hObject, eventdata, handles)

% Push messages to Log Window:
% ----------------------------
log_text = {...
            '';...
            ['%--- ' datestr(now) ' ---%'];...
            'Export .xlsx File succesfully!'};
            statusLogging(handles.LogWindow, log_text)
            
            
function savexlsDataCallback(hObject, eventdata, handles)
%Read data
geovar = getappdata(0,'geovar');

close_button = questdlg(...
    'Do you like export all channel analyzed?', 'MStaT: Export Excel Data',...
    'All Data','Only Selected');
switch close_button
    case 'All Data'
        for i=1:length(geovar)
            mStat_ExportExcel(geovar{i})
        end
    case 'Only Selected'
        mStat_ExportExcel(geovar{handles.ChannelSel})
end

%Google Export
% --------------------------------------------------------------------
function exportkmlfile_Callback(hObject, eventdata, handles)
geovar = getappdata(0,'geovar');


%This function esport the kmzfile for Google Earth
[file,path] = uiputfile('*.kml','Save .kml File');

if file==0
else
    str=['Exporting' file];
    hwait = waitbar(0,str,'Name','MStaT');
    namekml=(fullfile(path,file));

    % 3 file export function
    %first
    [xcoord,ycoord]=utm2deg(handles.xCoord,handles.xCoord,char(handles.utmzone(:,1:4)));
    latlon1=[xcoord ycoord];

    %second
    for i=1:length(handles.geovar.xValleyCenter)
        utmzoneva(i,1)=cellstr(handles.utmzone(1,1:4));
    end
    utmva=char(utmzoneva);
    waitbar(0.5,hwait)

    
    [xvalley,yvalley]=utm2deg(handles.geovar.xValleyCenter,handles.geovar.yValleyCenter,char(utmzoneva));
    latlon2=[xvalley yvalley];

    %third
    for i=1:length(handles.geovar.inflectionX)
        utmzoneinf(i,1)=cellstr(handles.utmzone(1,1:4));
    end

    [xinflectionY,yinflectionY]=utm2deg(handles.geovar.inflectionX,handles.geovar.inflectionY,char(utmzoneinf));
    latlon3=[xinflectionY yinflectionY];

    % Write latitude and longitude into a KML file
    mStat_Exportkml(namekml,latlon1,latlon2,latlon3);
    
    waitbar(1,hwait)
    delete(hwait)
    
    % Push messages to Log Window:
    % ----------------------------
    log_text = {...
                '';...
                ['%--- ' datestr(now) ' ---%'];...
                'Export .kml File succesfully!'};
                statusLogging(handles.LogWindow, log_text)

end

    
% --------------------------------------------------------------------
function htmlfile_Callback(hObject, eventdata, handles)
% hObject    handle to htmlfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Export Figures    
% --------------------------------------------------------------------
function exportfiguregraphics_Callback(hObject, eventdata, handles)
%export figure function
[file,path] = uiputfile('*.tif','Save .tif File');

if file==0
else
    F = getframe(handles.pictureReach);
    Image = frame2im(F);
    imwrite(Image, fullfile(path,file),'Resolution',500)

    % Push messages to Log Window:
    % ----------------------------
    log_text = {...
                '';...
                ['%--- ' datestr(now) ' ---%'];...
                'Export .tif File succesfully!'};
                statusLogging(handles.LogWindow, log_text)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%
%Tools
%%%%%%%%%%
% --------------------------------------------------------------------
function tools_Callback(hObject, eventdata, handles)
% Empty

% --------------------------------------------------------------------
function evaldecomp_Callback(hObject, eventdata, handles)
% Empty

% --------------------------------------------------------------------
function waveletanalysis_Callback(hObject, eventdata, handles)
%Wavelet analysis
geovar=getappdata(0,'geovar');
handles.getWaveStats = mStat_WaveletAnalysis(geovar{handles.ChannelSel});


% --------------------------------------------------------------------
function riverstatistics_Callback(hObject, eventdata, handles)
% This function executes when the user presses the getRiverStats button
% and requires the following input arguments.
geovar=getappdata(0,'geovar');
handles.getRiverStats = mStat_StatisticsVariables(geovar{handles.ChannelSel});


% --------------------------------------------------------------------
function backgroundimage_Callback(hObject, eventdata, handles)
% Add backgroud image
[handles.FileImage,handles.PathImage] = uigetfile({'*.jpg';'*.tif';'*.*'},'Select Graphic File');
guidata(hObject,handles)

if handles.FileImage==0
else
    
    axes(handles.pictureReach);
    hold on;
    mapshow(fullfile(handles.PathImage,handles.FileImage))
    hold on;

    geovar=getappdata(0, 'geovar');
    
    %Begin plot
     mStat_plotplanar(geovar{handles.ChannelSel}.equallySpacedX, geovar{handles.ChannelSel}.equallySpacedY,...
         geovar{handles.ChannelSel}.inflectionPts, geovar{handles.ChannelSel}.x0,...
         geovar{handles.ChannelSel}.y0, geovar{handles.ChannelSel}.x_sim,...
     geovar{handles.ChannelSel}.newMaxCurvX, geovar{handles.ChannelSel}.newMaxCurvY,...
     handles.pictureReach);
 
    msgbox(['Successfully update'],...
        'Background Image');
        
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%
%Modules
%%%%%%%%%%

% --------------------------------------------------------------------
function modules_Callback(hObject, eventdata, handles)
% Empty

% --------------------------------------------------------------------
function braidinganalyzer_Callback(hObject, eventdata, handles)
mStat_BraidingModule

% --------------------------------------------------------------------
function migrationanalyzer_Callback(hObject, eventdata, handles)
%Migration Analyzer Tool
mStat_MigrationAnalyzer;

% --------------------------------------------------------------------
function confluencesanalyzer_Callback(hObject, eventdata, handles)
%Confluences and Bifurcation Tools
mStat_ConfluencesAnalyzer;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%
%Settings
%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function setti_Callback(hObject, eventdata, handles)
% Empty


% --------------------------------------------------------------------
function unitsfunction_Callback(hObject, eventdata, handles)
% Empty


% --------------------------------------------------------------------
function metricunits_Callback(hObject, eventdata, handles)
% Metric factor function
if handles.start==0
    munits=1/0.3048;
else
    munits=1;
end
handles.geovar.lengthCurved=handles.geovar.lengthCurved*munits;
handles.geovar.wavelengthOfBends=handles.geovar.wavelengthOfBends*munits;
handles.geovar.amplitudeOfBends=handles.geovar.amplitudeOfBends*munits;
handles.geovar.downstreamSlength=handles.geovar.downstreamSlength*munits;
handles.geovar.upstreamSlength=handles.geovar.upstreamSlength*munits;
handles.width=handles.width*munits;
guidata(hObject,handles)

set(handles.widthinput,'String',handles.width)

% Retrieve the selected bend ID number from the "bendSelect" listbox.
selectedBend = get(handles.bendSelect,'Value');

% -------------------------------------------------------------------------

% Assign the bend statistics to an output array.
matrixOfBendStatistics = [handles.geovar.sinuosityOfBends(selectedBend),...
    handles.geovar.lengthStraight(selectedBend),handles.geovar.lengthCurved(selectedBend),...
    handles.geovar.wavelengthOfBends(selectedBend), handles.geovar.amplitudeOfBends(selectedBend),...
    handles.geovar.downstreamSlength(selectedBend),handles.geovar.upstreamSlength(selectedBend)];

matrixOfBendStatistics = matrixOfBendStatistics';

% Setappdata is a function which allows the matrix of bend statistics
% to be accessed by multiple GUI windows.  
setappdata(0, 'matrixOfBendStatistics', matrixOfBendStatistics);
guidata(hObject, handles);

% Set the statistics to the "IndividualStats" table in 
% the main GUI.  
set(handles.sinuosity, 'String', round(handles.geovar.sinuosityOfBends(selectedBend),2));
set(handles.curvaturel, 'String', round(handles.geovar.lengthCurved(selectedBend),2));
set(handles.wavel, 'String', round(handles.geovar.wavelengthOfBends(selectedBend),2));
set(handles.amplitude, 'String', round(handles.geovar.amplitudeOfBends(selectedBend),2));
set(handles.dstreamL, 'String', round(handles.geovar.downstreamSlength(selectedBend),2));
set(handles.ustreamL, 'String', round(handles.geovar.upstreamSlength(selectedBend),2));
handles.munits=1;
guidata(hObject, handles);


% --------------------------------------------------------------------
function englishunits_Callback(hObject, eventdata, handles)
% English units

eunits=0.3048;

handles.geovar.lengthCurved=handles.geovar.lengthCurved*eunits;
handles.geovar.wavelengthOfBends=handles.geovar.wavelengthOfBends*eunits;
handles.geovar.amplitudeOfBends=handles.geovar.amplitudeOfBends*eunits;
handles.geovar.downstreamSlength=handles.geovar.downstreamSlength*eunits;
handles.geovar.upstreamSlength=handles.geovar.upstreamSlength*eunits;
handles.width=handles.width*eunits;
guidata(hObject,handles)

set(handles.widthinput,'String',handles.width)

% Retrieve the selected bend ID number from the "bendSelect" listbox.
selectedBend = get(handles.bendSelect,'Value');

% -------------------------------------------------------------------------

% Assign the bend statistics to an output array.
matrixOfBendStatistics = [handles.geovar.sinuosityOfBends(selectedBend),...
    handles.geovar.lengthStraight(selectedBend),handles.geovar.lengthCurved(selectedBend),...
    handles.geovar.wavelengthOfBends(selectedBend), handles.geovar.amplitudeOfBends(selectedBend),...
    handles.geovar.downstreamSlength(selectedBend),handles.geovar.upstreamSlength(selectedBend)];

matrixOfBendStatistics = matrixOfBendStatistics';

% Setappdata is a function which allows the matrix of bend statistics
% to be accessed by multiple GUI windows.  
setappdata(0, 'matrixOfBendStatistics', matrixOfBendStatistics);
guidata(hObject, handles);

% Set the statistics to the "IndividualStats" table in 
% the main GUI.  
set(handles.sinuosity, 'String', round(handles.geovar.sinuosityOfBends(selectedBend),2));
set(handles.curvaturel, 'String', round(handles.geovar.lengthCurved(selectedBend),2));
set(handles.wavel, 'String', round(handles.geovar.wavelengthOfBends(selectedBend),2));
set(handles.amplitude, 'String', round(handles.geovar.amplitudeOfBends(selectedBend),2));
set(handles.dstreamL, 'String',round(handles.geovar.downstreamSlength(selectedBend),2));
set(handles.ustreamL, 'String', round(handles.geovar.upstreamSlength(selectedBend),2));
handles.eunits=0.3048;
guidata(hObject, handles);
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Help
% --------------------------------------------------------------------
function helpfunction_Callback(hObject, eventdata, handles)
% Empty


% --------------------------------------------------------------------
function usersguide_Callback(hObject, eventdata, handles)
%Send to web page with code modufy to github
try
    web('https://meanderstatistics.blogspot.com/p/tutorials.html')
catch err %#ok<NASGU>
	if isdeployed
        errLogFileName = fullfile(pwd,...
            ['errorLog' datestr(now,'yyyymmddHHMMSS') '.txt']);
        msgbox({['An unexpected error occurred. Error code: ' err.identifier];...
            ['Error details are being written to the following file: '];...
            errLogFileName},...
            'MStaT Status: Unexpected Error',...
            'error');
        fid = fopen(errLogFileName,'W');
        fwrite(fid,err.getReport('extended','hyperlinks','off'));
        fclose(fid);
        rethrow(err)
    else
        msgbox(['An unexpected error occurred. Error code: ' err.identifier],...
            'MStaT Status: Unexpected Error',...
            'error');
        rethrow(err);
    end
end


% --------------------------------------------------------------------
function checkforupdates_Callback(hObject, eventdata, handles)
%Send to web page for updates
try
    web('https://meanderstatistics.blogspot.com/p/download.html')
catch err %#ok<NASGU>
	if isdeployed
        errLogFileName = fullfile(pwd,...
            ['errorLog' datestr(now,'yyyymmddHHMMSS') '.txt']);
        msgbox({['An unexpected error occurred. Error code: ' err.identifier];...
            ['Error details are being written to the following file: '];...
            errLogFileName},...
            'MStaT Status: Unexpected Error',...
            'error');
        fid = fopen(errLogFileName,'W');
        fwrite(fid,err.getReport('extended','hyperlinks','off'));
        fclose(fid);
        rethrow(err)
    else
        msgbox(['An unexpected error occurred. Error code: ' err.identifier],...
            'MStaT Status: Unexpected Error',...
            'error');
        rethrow(err);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%
%MENU TOOLBAR
%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function zoomextendedT_ClickedCallback(hObject, eventdata, handles)
geovar=getappdata(0, 'geovar');

%Begin plot
axes(handles.pictureReach)
cla(handles.pictureReach)
 mStat_plotplanar(geovar{handles.ChannelSel}.equallySpacedX, geovar{handles.ChannelSel}.equallySpacedY,...
     geovar{handles.ChannelSel}.inflectionPts, geovar{handles.ChannelSel}.x0,...
     geovar{handles.ChannelSel}.y0, geovar{handles.ChannelSel}.x_sim,...
 geovar{handles.ChannelSel}.newMaxCurvX, geovar{handles.ChannelSel}.newMaxCurvY,...
 handles.pictureReach);


% --------------------------------------------------------------------
function panT_OnCallback(hObject, eventdata, handles)

axes(handles.pictureReach)
scalebar OFF


% --------------------------------------------------------------------
function panT_OffCallback(hObject, eventdata, handles)
axes(handles.pictureReach)
scalebar 


% --------------------------------------------------------------------
function panT_ClickedCallback(hObject, eventdata, handles)
pan


% --------------------------------------------------------------------
function rulerT_ClickedCallback(hObject, eventdata, handles) 
%empty

% --------------------------------------------------------------------
function newprojectT_ClickedCallback(hObject, eventdata, handles)
newproject_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function savematfileT_ClickedCallback(hObject, eventdata, handles)
exportmat_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function openT_ClickedCallback(hObject, eventdata, handles)
openfunction_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function rulerT_OnCallback(hObject, eventdata, handles)
axes(handles.pictureReach)
%imdistline(hparent)

 axis manual
 handles.Figruler = imline(gca);
 % Get original position
 pos = getPosition(handles.Figruler);
 % Get updated position as the ruler is moved around
 id = addNewPositionCallback(handles.Figruler,@(pos) title(mat2str(pos,3)));
 
 x=pos(:,1);
 y=pos(:,2);
 
 handles.ruler=imdistline(handles.pictureReach,x,y);
 guidata(hObject,handles)


% --------------------------------------------------------------------
function rulerT_OffCallback(hObject, eventdata, handles)
delete(handles.ruler)
delete(handles.Figruler)


% --------------------------------------------------------------------
function datacursorT_OnCallback(hObject, eventdata, handles)
axes(handles.pictureReach); 

%data cursor type
dcm_obj = datacursormode(gcf);

set(dcm_obj,'UpdateFcn',@mStat_myupdatefcn);

set(dcm_obj,'Displaystyle','Window','Enable','on');
pos = get(0,'userdata');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
%Initial Panel
%%%%%%%%%%%%%%%%%%%

function widthinput_Callback(hObject, eventdata, handles)
% Empty


% --- Executes during object creation, after setting all properties.
function widthinput_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on popupChannel and none of its controls.
function popupChannel_KeyPressFcn(hObject, eventdata, handles)
%empty


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupChannel.
function popupChannel_ButtonDownFcn(hObject, eventdata, handles)
%empty


% --- Executes on button press in advancedsetting.
function advancedsetting_Callback(hObject, eventdata, handles)

mStat_AdvancedSetting(handles.ChannelSel)


% --- Executes on button press in recalculate.
function recalculate_Callback(hObject, eventdata, handles)
%Recalculate using a New Width 

% clear figures and data 
axes(handles.pictureReach)
cla(handles.pictureReach)
clear selectBend
clc
guidata(hObject,handles)

mStat_Calculate(handles)
set_enable(handles,'results')

% --- Executes on selection change in popupChannel.
function popupChannel_Callback(hObject, eventdata, handles)

handles.ChannelSel=get(handles.popupChannel,'Value')-1;
guidata(hObject, handles);

geovar=getappdata(0, 'geovar');

if handles.ChannelSel==0
   % set_enable(handles,'init')
else
    
    set_enable(handles,'loadfiles')
    % %put the bend on the table
    bendListStr = geovar{handles.ChannelSel}.bendID1';
    set (handles.bendSelect, 'string', bendListStr);
    
%       Write the width
     %set(handles.widthinput, 'String', ReadVar{handles.ChannelSel}.width,'Enable','on');

    %      Retrieve the selected bend ID number from the "bendSelect" listbox.
    selectedBend = get(handles.bendSelect,'Value');
    handles.selectedBend = num2str(selectedBend);

    %       setappdata is a function which allows the selected bend
    %       to be accessed by multiple GUI windows.  
    setappdata(0, 'selectedBend', handles.selectedBend);
    guidata(hObject, handles);

    %     Start by retreiving the selected bend given the user input from the
    %     "bendSelect" listbox. 
    handles.selectedBend = getappdata(0, 'selectedBend');
    handles.selectedBend = str2double(handles.selectedBend);
    guidata(hObject, handles); 
    
    %Begin plot
    axes(handles.pictureReach)
    cla(handles.pictureReach)
     mStat_plotplanar(geovar{handles.ChannelSel}.equallySpacedX, geovar{handles.ChannelSel}.equallySpacedY,...
         geovar{handles.ChannelSel}.inflectionPts, geovar{handles.ChannelSel}.x0,...
         geovar{handles.ChannelSel}.y0, geovar{handles.ChannelSel}.x_sim,...
     geovar{handles.ChannelSel}.newMaxCurvX, geovar{handles.ChannelSel}.newMaxCurvY,...
     handles.pictureReach);


%    enable results
   set_enable(handles,'results')
    
% Push messages to Log Window:
% ----------------------------
log_text = {...
            '';...
            ['%--- ' datestr(now) ' ---%'];...
            'MStaT Summary';...
            'Width [m]:';[cell2mat({geovar{handles.ChannelSel}.width(end,1)})];...
            'Total Length Analyzed [km]:';[round(cell2mat({geovar{handles.ChannelSel}.intS(end,1)/1000}),2)];...
            'Bends Found:';[cell2mat({geovar{handles.ChannelSel}.nBends})];...
            'Mean Sinuosity:';[round(cell2mat({nanmean(geovar{handles.ChannelSel}.sinuosityOfBends)}),2)];...
            'Mean Amplitude [m]:';[round(cell2mat({nanmean(geovar{handles.ChannelSel}.amplitudeOfBends)}),2)];...
            'Mean Arc-Wavelength [m]:';[round(cell2mat({nanmean(geovar{handles.ChannelSel}.lengthCurved)}),2)];...
            'Mean Wavelength [m]:';[round(cell2mat({nanmean(geovar{handles.ChannelSel}.wavelengthOfBends)}),2)]};
            statusLogging(handles.LogWindow, log_text)
end


% --------------------------------------------------------------------
function bendstatistics_Callback(hObject, eventdata, handles)
% % This function executes when the user presses the Get Bend panel 
% % button and requires the following input arguments.  
% %
% % Retrieve the selected bend ID number from the "bendSelect" listbox.
% selectedBend = get(handles.bendSelect,'Value');
% handles.selectedBend = num2str(selectedBend);
% 
% % Setappdata is a function which allows the selected bend
% % to be accessed by multiple GUI windows.  
% setappdata(0, 'selectedBend', handles.selectedBend);
% guidata(hObject, handles);
% 
% % Start by retreiving the selected bend given the user input from the
% % "bendSelect" listbox. 
% handles.selectedBend = getappdata(0, 'selectedBend');
% handles.selectedBend = str2double(handles.selectedBend);
% 
% % Call the "userSelectBend" function to get the index of intersection
% % points and the highlighted bend limits.  
% 
% [highlightX, highlightY, ~] = userSelectBend(handles.geovar.intS, handles.selectedBend,...
%     handles.geovar.equallySpacedX,handles.geovar.equallySpacedY,handles.geovar.newInflectionPts,...
%     handles.geovar.sResample);
% handles.highlightX = highlightX;
% handles.highlightY = highlightY;
% 
% % -------------------------------------------------------------------------
% % Set the statistics to the "IndividualStats" table in 
% % the main GUI.  
% set(handles.sinuosity, 'String', handles.geovar.sinuosityOfBends(selectedBend));
% set(handles.curvaturel, 'String', handles.geovar.lengthCurved(selectedBend));
% set(handles.wavel, 'String', handles.geovar.wavelengthOfBends(selectedBend));
% set(handles.amplitude, 'String', handles.geovar.amplitudeOfBends(selectedBend));
% guidata(hObject, handles);
% % 
% % Note:  This section is repeated if the user presses the 
% % "Go to Bend Statistics" button again.    
% uiresume(gcbf);


% --- Executes on button press in selectData.
function selectData_Callback(hObject, eventdata, handles)
%Empty


function bendSelect_Callback(hObject, eventdata, handles)
% This function executes when the user presses the Get Bend Statistics 
% button and requires the following input arguments.  

geovar=getappdata(0, 'geovar');

%cla(handles.pictureReach)
guidata(hObject,handles)

% Retrieve the selected bend ID number from the "bendSelect" listbox.
selectedBend = get(handles.bendSelect,'Value');

% setappdata is a function which allows the selected bend
% to be accessed by multiple GUI windows.  
setappdata(0, 'selectedBend', handles.selectedBend);
guidata(hObject, handles);

% Start by retreiving the selected bend given the user input from the
% "bendSelect" listbox. 
handles.selectedBend = getappdata(0, 'selectedBend');
handles.selectedBend = str2double(handles.selectedBend);
guidata(hObject, handles);

% -------------------------------------------------------------------------

% Assign the bend statistics to an output array.
matrixOfBendStatistics = [geovar{handles.ChannelSel}.sinuosityOfBends(selectedBend),...
    geovar{handles.ChannelSel}.lengthStraight(selectedBend),geovar{handles.ChannelSel}.lengthCurved(selectedBend),...
    geovar{handles.ChannelSel}.wavelengthOfBends(selectedBend), geovar{handles.ChannelSel}.amplitudeOfBends(selectedBend),...
    geovar{handles.ChannelSel}.downstreamSlength(selectedBend),geovar{handles.ChannelSel}.upstreamSlength(selectedBend)];

matrixOfBendStatistics = matrixOfBendStatistics';

% Setappdata is a function which allows the matrix of bend statistics
% to be accessed by multiple GUI windows.  
setappdata(0, 'matrixOfBendStatistics', matrixOfBendStatistics);
guidata(hObject, handles);

% Set the statistics to the "IndividualStats" table in 
% the main GUI.  
set(handles.sinuosity, 'String', round(geovar{handles.ChannelSel}.sinuosityOfBends(selectedBend),2));
set(handles.curvaturel, 'String', round(geovar{handles.ChannelSel}.lengthCurved(selectedBend),2));
set(handles.wavel, 'String', round(geovar{handles.ChannelSel}.wavelengthOfBends(selectedBend),2));
set(handles.amplitude, 'String', round(geovar{handles.ChannelSel}.amplitudeOfBends(selectedBend),2));
set(handles.dstreamL, 'String',round(geovar{handles.ChannelSel}.downstreamSlength(selectedBend),2));
set(handles.ustreamL, 'String', round(geovar{handles.ChannelSel}.upstreamSlength(selectedBend),2));
set(handles.condition, 'String', geovar{handles.ChannelSel}.condition(selectedBend));
guidata(hObject, handles);
    
uiresume(gcbf);
%--------------------------------------------------------------------------
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Panel Selection
% --- Executes during object creation, after setting all properties.
function uipanelselect_CreateFcn(hObject, eventdata, handles)
%Empty


function bendSelect_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------


function selectData_CreateFcn(hObject, eventdata, handles)
set(hObject,'enable','off')


% --- Executes on selection change in selector.
function selector_Callback(hObject, eventdata, handles)
%This function select the bend and shows the parameters results
axes(handles.pictureReach)
cla(handles.pictureReach)
guidata(hObject,handles)

mStat_Calculate(handles)


% --- Executes during object creation, after setting all properties.
function selector_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
% --- Executes on button press in gobend.
function gobend_Callback(hObject, eventdata, handles)
%This function go to bend selected and replot the picture
geovar=getappdata(0, 'geovar');

cla(handles.pictureReach)
mStat_plotplanar(geovar{handles.ChannelSel}.equallySpacedX, geovar{handles.ChannelSel}.equallySpacedY,...
    geovar{handles.ChannelSel}.inflectionPts,geovar{handles.ChannelSel}.x0,...
    geovar{handles.ChannelSel}.y0, geovar{handles.ChannelSel}.x_sim,...
    geovar{handles.ChannelSel}.newMaxCurvX, geovar{handles.ChannelSel}.newMaxCurvY, ...
    handles.pictureReach);

zoom out

selectedBend = get(handles.bendSelect,'Value');

 if geovar{handles.ChannelSel}.amplitudeOfBends(selectedBend)~=0 | isfinite(geovar{handles.ChannelSel}.upstreamSlength)
    %      selectdata text labels for all bends.    
    axes(handles.pictureReach); 
    set(gca, 'Color', 'w')
    %axis normal; 
    dx = 2000;
    dy = 2000;
    loc = find(geovar{handles.ChannelSel}.newMaxCurvS == geovar{handles.ChannelSel}.bend(selectedBend,2));
    zoomcenter(geovar{handles.ChannelSel}.newMaxCurvX(loc),geovar{handles.ChannelSel}.newMaxCurvY(loc),10)
 else 
 end

% Call the "userSelectBend" function to get the index of intersection
% points and the highlighted bend limits.  
[handles.highlightX, handles.highlightY, ~] = userSelectBend(geovar{handles.ChannelSel}.intS, selectedBend,...
    geovar{handles.ChannelSel}.equallySpacedX,geovar{handles.ChannelSel}.equallySpacedY,...
    geovar{handles.ChannelSel}.newInflectionPts,geovar{handles.ChannelSel}.sResample);

 axes(handles.pictureReach);
% hold on
handles.highlightPlot = line(handles.highlightX(1,:), handles.highlightY(1,:), 'color', 'y', 'LineWidth',8); 

guidata(hObject,handles)
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Planar Parameters Display
function sinuosity_Callback(hObject, eventdata, handles)
%Empty

% --- Executes during object creation, after setting all properties.
function sinuosity_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function curvaturel_Callback(hObject, eventdata, handles)
%Empty


% --- Executes during object creation, after setting all properties.
function curvaturel_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function wavel_Callback(hObject, eventdata, handles)
% Empty


% --- Executes during object creation, after setting all properties.
function wavel_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function amplitude_Callback(hObject, eventdata, handles)
% Empty


% --- Executes during object creation, after setting all properties.
function amplitude_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extra Functions

% --- Executes during object creation, after setting all properties.
function condition_CreateFcn(hObject, eventdata, handles)
% Empty


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
%Empty


% --- Executes during object creation, after setting all properties.
function IndividualStats_CreateFcn(hObject, eventdata, handles)
% Empty 


% --- Executes on button press in withinflectionpoints.
function withinflectionpoints_Callback(hObject, eventdata, handles)
% Empty


% --- Executes on button press in withvalleyline.
function withvalleyline_Callback(hObject, eventdata, handles)
% Empty


% --- Executes during object creation, after setting all properties.
function mStatBackground_CreateFcn(hObject, eventdata, handles)
%empty


% --- Executes on mouse press over axes background.
function pictureReach_ButtonDownFcn(hObject, eventdata, handles)
pan(handles.pictureReach)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%Extra function
%%%%%%%%%%%%%%%%%%%%

function set_enable(handles,enable_state)
switch enable_state
case 'init'
    %set(handles.widthinput,'String','','Enable','off')
    set(handles.sinuosity,'String','','Enable','off')
    set(handles.curvaturel,'String','','Enable','off')
    set(handles.wavel,'String','','Enable','off')
    set(handles.amplitude,'String','','Enable','off')
    set(handles.ustreamL,'String','','Enable','off')
    set(handles.dstreamL,'String','','Enable','off')
    set(handles.condition,'String','','Enable','off')
    set(handles.bendSelect,'Visible','off','String','','Enable','off')
    set(handles.exportfunction,'Enable','off')
    set(handles.exportkmlfile,'Enable','off')
    set(handles.setti,'Enable','off') 
    set(handles.recalculate,'Enable','off')    
    set(handles.gobend,'Enable','off')   
    set(handles.selector,'Enable','off')  
    set(handles.bendSelect,'Enable','off') 
    set(handles.waveletanalysis,'Enable','off')
    set(handles.advancedsetting,'Enable','off')
    set(handles.riverstatistics,'Enable','off')
    set(handles.backgroundimage,'Enable','off')
    set(handles.savematfileT,'Enable','off')
    set(handles.rulerT,'Enable','off')
    set(handles.zoomextendedT,'Enable','off')
    set(handles.zoominT,'Enable','off')
    set(handles.zoomoutT,'Enable','off')
    set(handles.panT,'Enable','off')
    set(handles.datacursorT,'Enable','off')
    set(handles.popupChannel,'String','Select Channel','Enable','off','Value',1)
    axes(handles.pictureReach)
    cla(handles.pictureReach)
    clear selectBend
    clc
    case 'loadfiles'
    %set(handles.widthinput,'Enable','on')
    set(handles.sinuosity,'Enable','on')
    set(handles.curvaturel,'Enable','on')
    set(handles.wavel,'Enable','on')
    set(handles.amplitude,'Enable','on')
    set(handles.ustreamL,'Enable','on')
    set(handles.dstreamL,'Enable','on')
    set(handles.bendSelect,'Visible','on','String','','Enable','on')
    set(handles.condition,'String','','Enable','on')
    set(handles.advancedsetting,'Enable','on')
    set(handles.setti,'Enable','on')
    set(handles.recalculate,'Enable','on') 
    set(handles.gobend,'Enable','on')
    set(handles.selector,'Enable','on')  
    set(handles.bendSelect,'Enable','on')  
    set(handles.popupChannel,'Enable','on')
    set(handles.savematfileT,'Enable','on')
    set(handles.rulerT,'Enable','on')
    set(handles.zoomextendedT,'Enable','on')
    set(handles.zoominT,'Enable','on')
    set(handles.zoomoutT,'Enable','on')
    set(handles.panT,'Enable','on')
    set(handles.datacursorT,'Enable','on')
    case 'results'
    set(handles.waveletanalysis,'Enable','on')  
    set(handles.riverstatistics,'Enable','on')  
    set(handles.exportfunction,'Enable','on')
%     if  handles.formatfileread(2)=='l'
%         set(handles.exportkmlfile,'Enable','on')
%     end
    handles.start=0;
    set(handles.backgroundimage,'Enable','on')
    otherwise                
end
       

% --------------------------------------------------------------------
function pictureReach_CreateFcn(hObject, eventdata, handles)
%Empty


% --------------------------------------------------------------------
function pictureReach_DeleteFcn(hObject, eventdata, handles)
%Empty


% % --------------------------------------------------------------------
function Opengui_ClickedCallback(hObject, eventdata, handles)
openfile_Callback(hObject, eventdata, handles)


% --- Executes on selection change in LogWindow.
function LogWindow_Callback(hObject, eventdata, handles)
% empty


% --- Executes during object creation, after setting all properties.
function LogWindow_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mStat_Calculate(handles)

ReadVar=getappdata(0, 'ReadVar');
geovar=getappdata(0, 'geovar');
AdvancedSet=getappdata(0, 'AdvancedSet');

%Read selector
sel=get(handles.selector,'Value');%1 Inflection method or MCM

Tools=1;%Geometry parameter

%Function of calculate
%Calculate and plot planar variables

[geovar{handles.ChannelSel}]=mStat_planar(ReadVar{handles.ChannelSel}.xCoord,ReadVar{handles.ChannelSel}.yCoord,...
    ReadVar{handles.ChannelSel}.width,ReadVar{handles.ChannelSel}.File,...
    sel,Tools,ReadVar{handles.ChannelSel}.Level,AdvancedSet{handles.ChannelSel});
    
%Begin plot
     mStat_plotplanar(geovar{handles.ChannelSel}.equallySpacedX, geovar{handles.ChannelSel}.equallySpacedY,...
         geovar{handles.ChannelSel}.inflectionPts, geovar{handles.ChannelSel}.x0,...
         geovar{handles.ChannelSel}.y0, geovar{handles.ChannelSel}.x_sim,...
     geovar{handles.ChannelSel}.newMaxCurvX, geovar{handles.ChannelSel}.newMaxCurvY,...
     handles.pictureReach);
 
%Store data file
setappdata(0, 'geovar', geovar);


% Push messages to Log Window:
% ----------------------------
log_text = {...
            '';...
            ['%--- ' datestr(now) ' ---%'];...
            'MStaT Summary';...
            'Width [m]:';[cell2mat({geovar{handles.ChannelSel}.width(end,1)})];...
            'Total Length Analyzed [km]:';[round(cell2mat({geovar{handles.ChannelSel}.intS(end,1)/1000}),2)];...
            'Bends Found:';[cell2mat({geovar{handles.ChannelSel}.nBends})];...
            'Mean Sinuosity:';[round(cell2mat({nanmean(geovar{handles.ChannelSel}.sinuosityOfBends)}),2)];...
            'Mean Amplitude [m]:';[round(cell2mat({nanmean(geovar{handles.ChannelSel}.amplitudeOfBends)}),2)];...
            'Mean Arc-Wavelength [m]:';[round(cell2mat({nanmean(geovar{handles.ChannelSel}.lengthCurved)}),2)];...
            'Mean Wavelength [m]:';[round(cell2mat({nanmean(geovar{handles.ChannelSel}.wavelengthOfBends)}),2)]};
            statusLogging(handles.LogWindow, log_text)
                    
