function varargout = mStat_StatisticsVariables(varargin)

% MSTAT_STATISTICSVARIABLES MATLAB code for mStat_StatisticsVariables.fig
%       Last modified by: KRD 10/14/2014
%      MSTAT_STATISTICSVARIABLES creates a new MSTAT_STATISTICSVARIABLES or raises the existing
%      singleton*.
%
%      H = MSTAT_STATISTICSVARIABLES returns the handle to a new MSTAT_STATISTICSVARIABLES or the handle to
%      the existing singleton*.
%
%      MSTAT_STATISTICSVARIABLES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSTAT_STATISTICSVARIABLES.M with the given input arguments.
%
%      MSTAT_STATISTICSVARIABLES('Property','Value',...) creates a new MSTAT_STATISTICSVARIABLES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mStat_StatisticsVariables_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mStat_StatisticsVariables_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mStat_StatisticsVariables

% Last Modified by GUIDE v2.5 27-Nov-2017 01:14:35

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
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mStat_StatisticsVariables (see VARARGIN)

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


% %Quit bends amplitude 0
% for t=2:length(amplitude)
% if curvedLength(t)>1 & amplitude(t)==0
%     amplitude(t)=amplitude(t-1);
% %     sinuosity(t-1)=[];
% %     curvedLength(t-1,:)=[];
% %     wavelength(t-1,:)=[];
% %     amplitude(t-1,:)=[];
% %     downstreamSlength(t-1,:)=[];
% %     upstreamSlength(t-1,:)=[];
% %     condition{t-1}=[];
% end
% end



matrixOfBendStatistics = [num2cell([varargin{1}.geovar.bendID1' varargin{1}.geovar.sinuosityOfBends ...
   varargin{1}.geovar.lengthCurved'  varargin{1}.geovar.wavelengthOfBends  varargin{1}.geovar.amplitudeOfBends])...
   varargin{1}.geovar.condition num2cell([varargin{1}.geovar.upstreamSlength' varargin{1}.geovar.downstreamSlength'])];

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
%close tertiaryWindow;

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
        'Amplitude_[m]' 'Condition' 'Upstream_Length_[m]' 'Downstream_Length_[m]'};
    
pvout = vertcat(headers,tabledata);    

[file,path] = uiputfile('*.xlsx','Save file');
xlswrite([path file], pvout);
warndlg('Export succesfully')
