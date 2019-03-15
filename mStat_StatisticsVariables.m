function varargout = mStat_StatisticsVariables(varargin)

% MSTAT
% Statistics variables tools

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_StatisticsVariables_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_StatisticsVariables_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

% If ERROR, write a txt file with the error dump info
% try
    
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before mStat_StatisticsVariables is made visible.
function mStat_StatisticsVariables_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.


hwait = waitbar(0,'River statistics...','Name','MSTaT tool',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(hwait,'canceling',0);

% Choose default command line output for mStat_StatisticsVariables
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.figure1,'Name',['MStaT: Statistic Variables '], ...
    'DockControls','off')


matrixOfBendStatistics = [num2cell([varargin{1}.geovar.bendID1' round(varargin{1}.geovar.sinuosityOfBends,2) ...
   round(varargin{1}.geovar.lengthCurved',2)  round(varargin{1}.geovar.wavelengthOfBends,2)  round(varargin{1}.geovar.amplitudeOfBends,2)])...
   varargin{1}.geovar.condition num2cell([round(varargin{1}.geovar.upstreamSlength',2) round(varargin{1}.geovar.downstreamSlength',2)])];

waitbar(0.5,hwait);

long=numel(matrixOfBendStatistics);
fila=long/8;
matrixOfBendStatistics=reshape(matrixOfBendStatistics,fila,8);

handles.matrixOfBendStatistics = matrixOfBendStatistics;
set(handles.riverStats, 'data', handles.matrixOfBendStatistics)
guidata(hObject, handles);
uiresume(gcbf);
waitbar(1,hwait);
delete(hwait)


% --- Outputs from this function are returned to the command line.
function varargout = mStat_StatisticsVariables_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes when entered data in editable cell(s) in riverStats.
function riverStats_CellEditCallback(hObject, eventdata, handles)
% Empty

% --- Executes when selected cell(s) is changed in riverStats.
function riverStats_CellSelectionCallback(hObject, eventdata, handles)
% Empty

% --- Executes during object deletion, before destroying properties.
function riverStats_DeleteFcn(hObject, eventdata, handles)
% Empty

% --- Executes during object creation, after setting all properties.
function riverStats_CreateFcn(hObject, eventdata, handles)
% Empty

% --- Executes on button press in closeTertiaryWindow.
function closeTertiaryWindow_Callback(hObject, eventdata, handles)
clear all;

% --- Executes during object creation, after setting all properties.
function closeTertiaryWindow_CreateFcn(hObject, eventdata, handles)
% empty

% --- Executes during object deletion, before destroying properties.
function closeTertiaryWindow_DeleteFcn(hObject, eventdata, handles)
% empty

% --- Executes during object deletion, before destroying properties.
function saveAsTxt_DeleteFcn(hObject, eventdata, handles)
% empty

% --------------------------------------------------------------------
function export_Callback(hObject, eventdata, handles)
% empty

% --------------------------------------------------------------------
function exportxlsx_Callback(hObject, eventdata, handles)
%Create table with data
tabledata = get(handles.riverStats,'data');

headers = {'Bend ID' 'Sinuosity_[m]' 'Arc_Wavelength_[m]' 'Wavelength_[m]'...
        'Amplitude[m]' 'Condition' 'Upstream_Length[m]' 'Downstream_Length[m]'};
    
pvout = vertcat(headers,tabledata);    

[file,path] = uiputfile('*.xlsx','Save file');
xlswrite([path file], pvout);
warndlg('Export succesfully!!')
