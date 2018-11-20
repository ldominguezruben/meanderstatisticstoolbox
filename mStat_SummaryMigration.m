function varargout = mStat_SummaryMigration(varargin)
% MSTAT_SUMMARYMIGRATION MATLAB code for mStat_SummaryMigration.fig
%      MSTAT_SUMMARYMIGRATION, by itself, creates a new MSTAT_SUMMARYMIGRATION or raises the existing
%      singleton*.
%
%      H = MSTAT_SUMMARYMIGRATION returns the handle to a new MSTAT_SUMMARYMIGRATION or the handle to
%      the existing singleton*.
%
%      MSTAT_SUMMARYMIGRATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSTAT_SUMMARYMIGRATION.M with the given input arguments.
%
%      MSTAT_SUMMARYMIGRATION('Property','Value',...) creates a new MSTAT_SUMMARYMIGRATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mStat_SummaryMigration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mStat_SummaryMigration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mStat_SummaryMigration

% Last Modified by GUIDE v2.5 01-Jan-2015 01:08:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_SummaryMigration_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_SummaryMigration_OutputFcn, ...
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


% --- Executes just before mStat_SummaryMigration is made visible.
function mStat_SummaryMigration_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for mStat_SummaryMigration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% Set the name and version
set(handles.figure1,'Name',['MStaT: Migration Summary '], ...
    'DockControls','off')

%Migracion media
for t=1:length(varargin{1}.Indext1)-1
    Summa.Average(t)=nanmean(varargin{1}.MigrationSignal(varargin{1}.Indext0{t}.ind))/varargin{1}.deltat;
    [Summa.Max(t),ubi1(t)]=nanmax(varargin{1}.MigrationSignal(varargin{1}.Indext0{t}.ind)/varargin{1}.deltat);
    [Summa.Min(t),ubi2(t)]=nanmin(varargin{1}.MigrationSignal(varargin{1}.Indext0{t}.ind)/varargin{1}.deltat);
    Summa.Dirmax(t)=varargin{1}.Direction(ubi1(t));
    Summa.Dirmin(t)=varargin{1}.Direction(ubi2(t));
end


matrixOfSummaryMigration = [num2cell([Summa.Average' Summa.Max' ...
   Summa.Min'  Summa.Dirmax'  Summa.Dirmin'])];

handles.matrixOfSummaryMigration = matrixOfSummaryMigration;
set(handles.summaryMigratable, 'data', handles.matrixOfSummaryMigration)
guidata(hObject, handles);
uiresume(gcbf);



% --- Outputs from this function are returned to the command line.
function varargout = mStat_SummaryMigration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
