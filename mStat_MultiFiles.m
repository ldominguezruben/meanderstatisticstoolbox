function varargout = mStat_MultiFiles(varargin)
% MSTAT_MULTIFILES MATLAB code for mStat_MultiFiles.fig
%      MSTAT_MULTIFILES, by itself, creates a new MSTAT_MULTIFILES or raises the existing
%      singleton*.
%
%      H = MSTAT_MULTIFILES returns the handle to a new MSTAT_MULTIFILES or the handle to
%      the existing singleton*.
%
%      MSTAT_MULTIFILES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSTAT_MULTIFILES.M with the given input arguments.
%
%      MSTAT_MULTIFILES('Property','Value',...) creates a new MSTAT_MULTIFILES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mStat_MultiFiles_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mStat_MultiFiles_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mStat_MultiFiles

% Last Modified by GUIDE v2.5 11-Jul-2019 11:28:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mStat_MultiFiles_OpeningFcn, ...
                   'gui_OutputFcn',  @mStat_MultiFiles_OutputFcn, ...
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


% --- Executes just before mStat_MultiFiles is made visible.
function mStat_MultiFiles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mStat_MultiFiles (see VARARGIN)

% Choose default command line output for mStat_MultiFiles
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mStat_MultiFiles wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mStat_MultiFiles_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in addfiles.
function addfiles_Callback(hObject, eventdata, handles)
% hObject    handle to addfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in quitfiles.
function quitfiles_Callback(hObject, eventdata, handles)
% hObject    handle to quitfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)

Tools=1;%Geometric parameters
    
level=5;%Decomposition level default
%       Write the level
set(handles.decompositionparameter, 'String', level);

%Calculate and plot planar variables
[geovar]=mStat_planar(handles.xCoord,handles.yCoord,handles.width,sel,...
    handles.pictureReach,handles.bendSelect,Tools,level);

%store data
setappdata(0, 'geovar', geovar);
    


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
