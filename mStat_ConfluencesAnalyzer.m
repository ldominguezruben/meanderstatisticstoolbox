function varargout = mStat_ConfluencesAnalyzer(varargin)
%-----------------MEANDER STATISTICS TOOLBOX. MStaT------------------------
% MSTAT CONFLUENCE MODULE  
%
% This function evaluate the influences of the secondaries channels on 
% confluence or bifurcation in the main channel and control in how long 
% downstream modify the main channel.

% Collaborations
% Lucas Dominguez. UNL, Argentina

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_ConfluencesAnalyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_ConfluencesAnalyzer_OutputFcn, ...
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


% --- Executes just before mStat_ConfluencesAnalyzer is made visible.
function mStat_ConfluencesAnalyzer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for mStat_ConfluencesAnalyzer
handles.output = hObject;
set_enable(handles,'init')

set(handles.figure1,'Name',['MStaT: Confluence Module '], ...
    'DockControls','off')

% Push messages to Log Window:
% ----------------------------
log_text = {...
    '';...
    ['%----------- ' datestr(now) ' ------------%'];...
    'LETs START!!!'};
statusLogging(handles.LogWindow, log_text)
  
axes(handles.wavel_axes)
grid on

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = mStat_ConfluencesAnalyzer_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Toolbar Menu
% --------------------------------------------------------------------
function filefunctions_Callback(hObject, eventdata, handles)
% empty

% --------------------------------------------------------------------
function closefunctions_Callback(hObject, eventdata, handles)
close

% --------------------------------------------------------------------
function newprojects_Callback(hObject, eventdata, handles)
set_enable(handles,'init')

% Push messages to Log Window:
% ----------------------------
log_text = {...
            '';...
            ['%--- ' datestr(now) ' ---%'];...
            'NEW PROJECT'};
            statusLogging(handles.LogWindow, log_text)
                

% --------------------------------------------------------------------
function export_Callback(hObject, eventdata, handles)
% empty


% --------------------------------------------------------------------
function matfiles_Callback(hObject, eventdata, handles)
[fileMAT,pathMAT] = uiputfile('*.mat','Save .mat file');

if fileMAT==0
else
    str=['Exporting' fileMAT];
    hwait = waitbar(0,str,'Name','MStaT');
    Parameters.PathFileName  = fullfile(pathMAT,fileMAT); 
    Parameters.geovar = getappdata(0,'geovar');
    Parameters.Readvar = getappdata(0,'geovar');
    Parameters.Conf = getappdata(0,'Conf');
    Parameters.Sta = getappdata(0,'Sta');
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


% --------------------------------------------------------------------
function graphs_Callback(hObject, eventdata, handles)
% empty


% --------------------------------------------------------------------
function planviewgraph_Callback(hObject, eventdata, handles)
h=figure('Name','MStaT: River Centerlines','NumberTitle','off');
set(h, 'Position', [10 10 550 500])
AxesH = handles.pictureReach;
fig=copyobj(AxesH,h);
set(fig,'Units', 'normalized', 'Position', [.1 .1 .85 .8]);



% --------------------------------------------------------------------
function waveletgraphmain_Callback(hObject, eventdata, handles)
h=figure('Name','MStaT: Wavelet of Main Channel','NumberTitle','off');
set(h, 'Position', [10 10 550 300])
AxesH = handles.wavel_axes;
fig=copyobj(AxesH,h);
set(fig,'Units', 'normalized', 'Position', [.15 .15 .85 .75]);
cc=colorbar;
colormap('jet');


% --------------------------------------------------------------------
function waveletgraphtributary_Callback(hObject, eventdata, handles)

h=figure('Name','MStaT: Wavelet of Tributary Channel','NumberTitle','off');
set(h, 'Position', [10 10 550 300])
AxesH = handles.tributary_axes;
fig=copyobj(AxesH,h);
set(fig,'Units', 'normalized', 'Position', [.15 .15 .85 .75]);
cc=colorbar;
colormap('jet');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initial Panel

%Read data
% --------------------------------------------------------------------
function openfile_Callback(hObject, eventdata, handles)
%activatemodule
handles.Module = 3;

%This function incorporate the initial data input
handles.multisel = 'on';
handles.first = 1;
guidata(hObject,handles)

mStat_ReadInputFiles(handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Push button Calculate

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
ReadVar  = getappdata(0, 'ReadVar');
geovar = getappdata(0, 'geovar');

% Run the calculate function

tableData = get(handles.inputtable, 'data');

if nansum(strcmp('Main Channel',tableData(:,2)))==0
    warndlg('You need incorporate almost one Main channel')
elseif nansum(strcmp('Tributary Channel',tableData(:,2)))==0
    warndlg('You need incorporate almost one Tributary channel')
else
    hwait = waitbar(0,'Confluence Module Analyzing. Processing...','Name',...
        'MStaT ', 'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
    setappdata(hwait,'canceling',0)
    %Check what is main and secondary channels
    p=1;
    
    for i=1:size(tableData,1)
        if strcmp(tableData(i,2),'Main Channel')
            widthMain=ReadVar{i}.width;
            Main=geovar{i};
        elseif strcmp(tableData(i,2),'Tributary Channel')            
            Tri{p}=geovar{i};
            LongTri(p)=Tri{p}.intS(end,1);
            widthTri{p}=ReadVar{i}.width;
            p=p+1;
        end
    end

    %save data
    handles.Main=Main;
    handles.Tri=Tri;
    guidata(hObject,handles)

    if size(tableData,1)==2%single file
        geovar{1}=Main;
        geovar{2}=Tri{1};
    elseif size(tableData,1)>2
        for t=1:size(tableData,1)
            if t==1
                geovar{t}=Main;
            else
                geovar{t}=Tri{t-1};
            end
        end
    end
    
    waitbar(50/100,hwait);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Obtain static data of confluence (only for mat export) 
    
    %relation BT/BM
    for t=1:size(tableData,1)-1
        Sta.BTdivBM(t)=widthTri{t}./widthMain;
    end
    
    %Lambdas relations
    for t=1:size(tableData,1)-1
        Sta.lambdaTdivlambdaM(t)=nanmean(Tri{t}.wavelengthOfBends)./nanmean(Main.wavelengthOfBends);
    end
    
    %Amplitude relations
    for t=1:size(tableData,1)-1
        Sta.AmplitudeTdivAmplitudeM(t)=nanmean(Tri{t}.amplitudeOfBends)./nanmean(Main.amplitudeOfBends);
    end

    setappdata(0, 'Sta', Sta); 
    waitbar(75/100,hwait);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Determinate the intersection o point close
    handles.tableData = tableData;
    handles.confluenceselected = 1;
    [Conf]=mStat_ConfluencesInfluences(geovar,handles);
    setappdata(0, 'Conf', Conf);   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Write in table    
    set(handles.conftable,'Data',Conf.confdata)
    
    %set enable results
    set_enable(handles,'results')

    % Push messages to Log Window:
    % ----------------------------
    log_text = {...
                '';...
                ['%--- ' datestr(now) ' ---%'];...
                'Calculate finalized';};

            statusLogging(handles.LogWindow, log_text)

    %Close waitbar        
    waitbar(1,hwait)
    delete(hwait)
end

% --- Executes when selected cell(s) is changed in conftable.
function conftable_CellSelectionCallback(hObject, eventdata, handles)
%read input variables
%ReadVar  = getappdata(0, 'ReadVar');
geovar = getappdata(0, 'geovar');
Conf = getappdata(0, 'Conf');

%read the selection of confluence
handles.confluenceselected = eventdata.Indices(:,1);
guidata(hObject,handles)

%Wavelet tributary channel
%Plotting
SIGLVL = 0.95;
sel = 1;%Toolbox inflection points method by default
filter = 'graphtributary';
axest = [handles.tributary_axes];
Tools = 3;%Confluence Module
Conf.tribuselected = handles.confluenceselected;%rename the tributary selected
vars = Conf;
%by default plot wavelet of first confluence
mStat_plotWavel(geovar{1+Conf.tribuselected},sel,SIGLVL,filter,axest,Tools,vars)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extra Function
%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_enable(handles,enable_state)
%Set initial an load files
switch enable_state
    case 'init'
        legend(handles.pictureReach,'hide')
        cla(handles.pictureReach)
        cla(handles.wavel_axes)
        cla(handles.tributary_axes)
        set(handles.conftable, 'Data', cell(2,2));
        set(handles.calculate,'Enable','off');
        set(handles.inputtable, 'Data', cell(2,2));
        set(handles.export,'Enable','off');
        set(handles.conftable,'Enable','off');
    case 'loadfiles'
        set(handles.calculate,'Enable','on');
    case 'results'
        set(handles.export,'Enable','on');
        set(handles.conftable,'Enable','on');
    otherwise
end

%%Log Window
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
